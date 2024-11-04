# Configuration de Base pour CloudFormation

Configurer correctement CloudFormation est une étape essentielle pour garantir un déploiement d’infrastructure stable et adapté à différents environnements. Cette section vous guidera dans la configuration de base de CloudFormation, notamment en utilisant les paramètres, les sorties et les mappages pour rendre les templates flexibles, réutilisables et adaptables.

---

## 1. Utiliser des Paramètres (Parameters)

La section **Parameters** permet d’ajouter des valeurs dynamiques aux templates. Les paramètres permettent d’adapter les configurations en fonction des besoins sans modifier directement le template.

### Exemple : Définir un Paramètre pour la Taille d'Instance EC2

```yaml
Parameters:
  InstanceType:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Description: "Sélectionnez la taille de l'instance EC2."
```

**Explications :**
- **Type** : Le type de paramètre (ici `String`).
- **Default** : La valeur par défaut si aucune autre valeur n’est spécifiée.
- **AllowedValues** : Les options acceptables pour ce paramètre.

> **Utilité** : Ce paramètre rend le template flexible et adaptable, car vous pouvez facilement ajuster la taille de l'instance selon l’environnement (par exemple, petite taille en développement et grande taille en production).

---

## 2. Mappages (Mappings)

Les mappages permettent de définir des valeurs statiques basées sur des régions ou d'autres critères spécifiques. Ils sont utiles pour adapter les configurations selon l’environnement géographique ou d’autres paramètres.

### Exemple : Utiliser un Mapping pour les IDs d'AMI par Région

```yaml
Mappings:
  AMIMap:
    us-east-1:
      AMI: ami-0c55b159cbfafe1f0
    us-west-2:
      AMI: ami-0d6621c01e8c2de2c
```

**Explications :**
- **AMIMap** : Le nom du mapping.
- Les sous-sections (comme `us-east-1`) correspondent aux clés, et **AMI** fournit la valeur spécifique pour chaque région.

> **Utilité** : En utilisant ce mapping, vous pouvez sélectionner l’AMI appropriée en fonction de la région, sans avoir à modifier le template pour chaque déploiement régional.

---

## 3. Références et Fonctions Intrinsèques

CloudFormation inclut des fonctions intégrées qui permettent de faire référence aux paramètres et mappages dans les templates.

### Référence de Paramètres avec `Ref`

La fonction **Ref** permet d’utiliser la valeur d’un paramètre ou d’une ressource ailleurs dans le template.

**Exemple : Utiliser Ref pour Spécifier la Taille de l’Instance**

```yaml
Resources:
  MyEC2Instance:
    Type: "AWS::EC2::Instance"
    Properties:
      InstanceType: !Ref InstanceType
      ImageId: !FindInMap [AMIMap, us-east-1, AMI]
```

> **Utilité** : Ici, `Ref` permet d’utiliser la valeur du paramètre `InstanceType`, rendant la configuration de l’instance flexible et paramétrable.

### Utiliser `FindInMap` pour les Mappages

La fonction **FindInMap** permet d’accéder aux valeurs dans les mappages.

**Exemple** :
```yaml
ImageId: !FindInMap [AMIMap, us-east-1, AMI]
```

Dans cet exemple, `FindInMap` récupère l’ID de l’AMI défini dans `AMIMap` pour la région `us-east-1`.

---

## 4. Utiliser les Sorties (Outputs)

La section **Outputs** permet d’exporter des informations clés d’une stack, comme l’adresse IP d’une instance ou l’URL d’un bucket S3. Cela facilite la récupération d’informations importantes après le déploiement.

### Exemple : Exporter l'Adresse IP de l'Instance et l'URL du Bucket S3

```yaml
Outputs:
  InstancePublicIP:
    Description: "Adresse IP publique de l'instance EC2"
    Value: !GetAtt MyEC2Instance.PublicIp

  BucketURL:
    Description: "URL du Bucket S3"
    Value: !GetAtt MyS3Bucket.WebsiteURL
```

**Explications :**
- **InstancePublicIP** : Exporte l’adresse IP de l’instance EC2.
- **BucketURL** : Exporte l’URL du bucket S3.

> **Utilité** : Ces sorties facilitent la récupération des informations essentielles et permettent de connecter des stacks entre elles en exportant des valeurs pour d’autres stacks.

---

## 5. Bonnes Pratiques pour une Configuration de Base

1. **Utiliser des Paramètres pour la Flexibilité** : Évitez les valeurs en dur en utilisant des paramètres pour adapter les déploiements.
2. **Employer les Mappages pour les Configurations Régionales** : Utilisez des mappages pour les valeurs spécifiques aux régions (comme les IDs d’AMI).
3. **Définir les Sorties Clés** : Utilisez les sorties pour exposer les informations nécessaires aux autres équipes ou aux stacks connectées.

---

Avec une bonne configuration de base, votre template CloudFormation devient plus adaptable, plus réutilisable et mieux organisé pour répondre aux besoins d’infrastructures variées.
