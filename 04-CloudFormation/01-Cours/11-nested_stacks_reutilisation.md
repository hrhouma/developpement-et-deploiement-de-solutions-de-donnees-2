# Nested Stacks et Réutilisation de Templates dans CloudFormation

Les **nested stacks** (ou stacks imbriquées) permettent de structurer les configurations CloudFormation en utilisant des templates modulaires, ce qui améliore la lisibilité et la réutilisabilité de l'infrastructure. Avec les nested stacks, vous pouvez diviser une infrastructure complexe en plusieurs stacks plus simples, chacune étant responsable d'une partie spécifique. Cela facilite la gestion, la mise à jour et la réutilisation de ces configurations.

---

## 1. Qu’est-ce qu’une Nested Stack ?

Une **nested stack** est une stack CloudFormation qui est appelée au sein d’une autre stack (appelée **parent stack**). La stack parent utilise un template principal qui référence les autres templates comme ressources de type `AWS::CloudFormation::Stack`. Ces stacks imbriquées permettent d’organiser et de structurer une infrastructure complexe en plusieurs sous-templates.

### Exemple de Cas d’Utilisation

Imaginons que vous ayez une infrastructure complexe comportant un réseau VPC, des instances EC2 et une base de données RDS. Plutôt que de tout définir dans un seul template, vous pouvez créer des templates séparés pour le réseau, le calcul, et le stockage, puis les inclure dans un template principal.

---

## 2. Création d’une Nested Stack

Pour créer une nested stack, définissez une ressource de type `AWS::CloudFormation::Stack` dans le template parent, en indiquant le chemin vers le template enfant.

### Exemple : Structure de Template Principal

```yaml
Resources:
  VPCStack:
    Type: "AWS::CloudFormation::Stack"
    Properties:
      TemplateURL: "https://s3.amazonaws.com/your-bucket/vpc-template.yaml"
      Parameters:
        VPCName: "MyVPC"

  ComputeStack:
    Type: "AWS::CloudFormation::Stack"
    Properties:
      TemplateURL: "https://s3.amazonaws.com/your-bucket/compute-template.yaml"
      Parameters:
        InstanceType: "t2.micro"
```

**Explications :**
- **VPCStack** et **ComputeStack** sont des ressources de type `AWS::CloudFormation::Stack`, chacune faisant référence à un template enfant.
- **TemplateURL** : Le chemin vers le template enfant (souvent stocké sur S3).
- **Parameters** : Les paramètres passés au template enfant pour personnaliser chaque stack imbriquée.

---

## 3. Avantages des Nested Stacks

### a. Réutilisation des Templates

Les nested stacks permettent de réutiliser des configurations d'infrastructure. Par exemple, si vous avez un template de réseau VPC, vous pouvez l’inclure dans plusieurs projets sans devoir le redéfinir à chaque fois.

### b. Meilleure Organisation et Lisibilité

En divisant une infrastructure complexe en plusieurs templates plus petits, vous améliorez la lisibilité et la structure des configurations. Chaque nested stack peut se concentrer sur une fonction spécifique (par exemple, réseau, calcul, stockage), ce qui rend les templates plus faciles à comprendre et à gérer.

### c. Maintenance et Mises à Jour Simplifiées

Avec les nested stacks, vous pouvez mettre à jour des parties spécifiques de l’infrastructure sans modifier le template principal. Par exemple, pour modifier la configuration du réseau, vous n’avez qu’à mettre à jour le template du VPC, sans toucher aux autres configurations.

---

## 4. Passer des Paramètres aux Nested Stacks

Lors de la création de nested stacks, vous pouvez passer des paramètres pour personnaliser chaque sous-stack. Cela permet de rendre les configurations flexibles et adaptées aux différents environnements.

### Exemple : Passer un Paramètre pour la Taille de l'Instance

Dans le template principal, définissez un paramètre pour la taille de l’instance EC2 et passez-le à la nested stack de calcul :

```yaml
Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Description: "Type d'instance EC2"

Resources:
  ComputeStack:
    Type: "AWS::CloudFormation::Stack"
    Properties:
      TemplateURL: "https://s3.amazonaws.com/your-bucket/compute-template.yaml"
      Parameters:
        InstanceType: !Ref InstanceType
```

Dans cet exemple, le paramètre `InstanceType` est défini dans le template principal et transmis à la stack imbriquée `ComputeStack`, permettant de personnaliser la taille de l’instance EC2 sans modifier le template enfant.

---

## 5. Références entre les Nested Stacks

CloudFormation permet de référencer des valeurs de sortie d’une stack imbriquée dans une autre stack. Utilisez la section `Outputs` pour exporter des valeurs et `Fn::ImportValue` pour les importer dans d’autres stacks.

### Exemple : Exporter et Importer une Valeur

**Dans le template enfant** (par exemple, le template du VPC), utilisez `Outputs` pour exporter le VPC ID :

```yaml
Outputs:
  VPCId:
    Description: "ID du VPC créé"
    Value: !Ref VPC
    Export:
      Name: "VPCIdExport"
```

**Dans le template principal**, importez cette valeur pour la référencer dans une autre ressource :

```yaml
Resources:
  MyInstance:
    Type: "AWS::EC2::Instance"
    Properties:
      InstanceType: t2.micro
      SubnetId: !ImportValue VPCIdExport
```

Dans cet exemple, le `VPCId` est exporté depuis le template enfant et importé dans le template principal pour être utilisé dans une instance EC2.

---

## Bonnes Pratiques pour l'Utilisation des Nested Stacks

1. **Modulariser les Templates** : Divisez votre infrastructure en templates logiques pour faciliter la gestion (ex : réseau, calcul, base de données).
2. **Réutiliser les Templates** : Utilisez des templates imbriqués pour réutiliser des configurations entre différents projets ou environnements.
3. **Gérer les Dépendances avec Outputs et Imports** : Utilisez `Outputs` et `Fn::ImportValue` pour partager des informations essentielles entre les stacks.
4. **Stocker les Templates sur S3** : Hébergez vos templates sur Amazon S3 pour faciliter leur accès et leur versioning.

---

Les nested stacks offrent une approche modulaire et réutilisable pour la gestion d'infrastructure complexe avec CloudFormation. En structurant vos configurations avec des templates imbriqués, vous facilitez la maintenance, la mise à jour et la réutilisation de l'infrastructure dans différents contextes.
