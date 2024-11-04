# Définition des Paramètres dans CloudFormation

Les **paramètres** dans un template CloudFormation permettent de rendre vos déploiements flexibles et adaptables. Grâce aux paramètres, vous pouvez personnaliser des aspects de l'infrastructure en fonction des besoins d'un environnement spécifique (développement, test, production) sans modifier directement le template. Cela rend le template plus réutilisable et facile à gérer.

---

## 1. Qu’est-ce qu’un Paramètre ?

Dans un template CloudFormation, un **paramètre** est une variable définie dans la section `Parameters` qui permet aux utilisateurs de spécifier une valeur lors du déploiement ou de la mise à jour d'une stack. En utilisant des paramètres, vous pouvez adapter une stack pour différents environnements en fournissant des valeurs dynamiques.

---

## 2. Structure d’un Paramètre

Un paramètre est composé de plusieurs attributs pour le rendre plus descriptif et pratique. Voici les attributs principaux :

- **Type** : Le type de donnée, tel que `String`, `Number`, ou `List<String>`.
- **Default** : La valeur par défaut du paramètre si aucune autre valeur n'est spécifiée.
- **AllowedValues** : Une liste de valeurs autorisées pour limiter les choix possibles.
- **Description** : Une explication pour guider les utilisateurs sur l’utilité du paramètre.

### Exemple de Paramètre

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

**Explications** :
- **Type** : Le paramètre accepte une valeur de type `String`.
- **Default** : Si l'utilisateur ne spécifie rien, la valeur par défaut sera `t2.micro`.
- **AllowedValues** : Limite les valeurs possibles aux trois options listées.
- **Description** : Fournit un contexte pour aider les utilisateurs à comprendre l’usage du paramètre.

---

## 3. Types de Paramètres Disponibles

CloudFormation prend en charge plusieurs types de paramètres, permettant des configurations précises et contrôlées.

### a. Paramètre String

Le type `String` est utilisé pour les chaînes de caractères. Vous pouvez restreindre les options avec `AllowedValues`.

```yaml
Parameters:
  EnvironmentType:
    Type: String
    AllowedValues:
      - dev
      - test
      - prod
    Description: "Type d'environnement (dev, test, prod)"
```

### b. Paramètre Number

Le type `Number` est utilisé pour les valeurs numériques. Il est pratique pour définir des configurations de capacité ou de ressources.

```yaml
Parameters:
  NodeCount:
    Type: Number
    Default: 3
    Description: "Nombre de nœuds dans le cluster"
```

### c. Paramètre List<String>

Le type `List<String>` permet de spécifier une liste de valeurs, séparées par des virgules.

```yaml
Parameters:
  SecurityGroups:
    Type: List<String>
    Description: "Liste des ID de groupes de sécurité"
```

### d. Types AWS spécifiques

CloudFormation propose des types spécifiques pour certains services AWS, comme `AWS::EC2::KeyPair::KeyName` pour un nom de paire de clés EC2, ou `AWS::SSM::Parameter::Value<String>` pour les paramètres SSM.

**Exemple avec AWS::EC2::KeyPair::KeyName**

```yaml
Parameters:
  KeyName:
    Type: AWS::EC2::KeyPair::KeyName
    Description: "Nom de la clé SSH pour accéder à l'instance EC2"
```

---

## 4. Utilisation des Paramètres dans les Ressources

Une fois les paramètres définis, vous pouvez les utiliser dans la section `Resources` avec la fonction `Ref`, qui fait référence à la valeur du paramètre.

**Exemple : Utiliser un Paramètre pour la Taille d'Instance**

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

Resources:
  MyEC2Instance:
    Type: "AWS::EC2::Instance"
    Properties:
      InstanceType: !Ref InstanceType
      ImageId: "ami-0c55b159cbfafe1f0"
```

Dans cet exemple, `Ref` permet de référencer le paramètre `InstanceType` dans la définition de l'instance EC2, ce qui rend la taille de l'instance configurable au moment du déploiement.

---

## 5. Bonnes Pratiques pour les Paramètres

1. **Utiliser AllowedValues pour Limiter les Choix** : En restreignant les options, vous réduisez le risque d'erreurs de configuration.
2. **Définir des Valeurs par Défaut** : Si une valeur est fréquemment utilisée, définissez-la comme valeur par défaut pour simplifier le déploiement.
3. **Ajouter des Descriptions** : Des descriptions claires aident les utilisateurs à comprendre les paramètres, rendant les templates plus intuitifs.
4. **Préférer les Types Spécifiques AWS** : Utilisez des types spécifiques, comme `AWS::EC2::KeyPair::KeyName`, pour garantir que les valeurs saisies sont correctes.

---

En utilisant les paramètres dans CloudFormation, vous pouvez rendre vos templates plus flexibles et dynamiques, ce qui facilite la gestion des configurations entre différents environnements. Cela rend votre infrastructure plus facilement adaptable et réutilisable.
