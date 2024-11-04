### Explication des Fonctions Intrinsèques

1. **`!Ref`**:
   - **Description** : La fonction `Ref` retourne la valeur d'un paramètre ou l'identifiant d'une ressource définie dans le template. C'est utile pour faire référence à des valeurs configurées dynamiquement.
   - **Exemple dans le template** : 
     ```yaml
     InstanceType: !Ref InstanceTypeParameter
     ```
     Ici, `!Ref InstanceTypeParameter` renvoie la valeur du paramètre `InstanceTypeParameter` choisi (comme `t2.micro`).

2. **`!GetAtt`**:
   - **Description** : `GetAtt` permet d'obtenir un attribut spécifique d'une ressource AWS. Par exemple, pour une instance EC2, vous pouvez obtenir son adresse IP publique ou son ID.
   - **Exemple dans le template** : 
     ```yaml
     WebServerPublicIP:
       Value: !GetAtt 'CafeInstance.PublicIp'
     ```
     Ici, `!GetAtt 'CafeInstance.PublicIp'` récupère l'adresse IP publique de l'instance EC2 `CafeInstance`.

3. **`!FindInMap`**:
   - **Description** : `FindInMap` récupère une valeur spécifique d'un mappage défini dans la section `Mappings`. Cela vous permet de définir des valeurs différentes selon la région ou d'autres paramètres.
   - **Exemple dans le template** :
     ```yaml
     KeyName: !FindInMap 
       - RegionMap
       - !Ref 'AWS::Region'
       - keypair
     ```
     Ici, `!FindInMap` recherche dans le mappage `RegionMap` pour récupérer la clé SSH associée à la région AWS actuelle.

4. **`!ImportValue`**:
   - **Description** : `ImportValue` permet d'importer des valeurs exportées par d'autres stacks CloudFormation. C'est très utile pour partager des ressources entre différents stacks.
   - **Exemple dans le template** :
     ```yaml
     VpcId: !ImportValue
       'Fn::Sub': '${CafeNetworkParameter}-VpcID'
     ```
     Ici, `!ImportValue` est utilisé pour importer l'ID du VPC correspondant à `CafeNetworkParameter-VpcID` d'un autre stack.

5. **`!Sub`**:
   - **Description** : `Sub` (Substitute) permet d'insérer des valeurs de variables dans des chaînes de caractères. Vous pouvez également l'utiliser avec des expressions comme `${}` pour des substitutions plus complexes.
   - **Exemple dans le template** :
     ```yaml
     VpcId: !ImportValue
       'Fn::Sub': '${CafeNetworkParameter}-VpcID'
     ```
     Ici, `!Sub` est utilisé pour créer dynamiquement une chaîne de caractères en combinant la valeur de `CafeNetworkParameter` avec `-VpcID`.

     Un autre exemple est l'utilisation dans la section `UserData` :
     ```yaml
     Fn::Base64:
       !Sub |
         #!/bin/bash
         yum -y update
         ...
     ```
     Ici, `!Sub` est utilisé pour insérer du texte dans le script `UserData`, permettant potentiellement l'insertion de variables si nécessaire.

6. **`Fn::Base64`**:
   - **Description** : `Fn::Base64` encode une chaîne de caractères en Base64, souvent utilisée pour les scripts `UserData` dans EC2 afin qu'ils puissent être correctement interprétés par l'instance.
   - **Exemple dans le template** :
     ```yaml
     Fn::Base64:
       !Sub |
         #!/bin/bash
         yum -y update
         yum install -y httpd mariadb-server wget
         ...
     ```
     Ici, le script bash est encodé en Base64 avant d'être transmis à l'instance EC2 pour être exécuté au démarrage.

### Résumé
- Ces fonctions vous permettent de créer des templates CloudFormation dynamiques et modulaires, en réutilisant des valeurs, en accédant à des attributs spécifiques, en important des valeurs d'autres stacks, et en substituant des variables dans des chaînes de caractères. 
- Cela rend vos templates plus flexibles et adaptés à divers environnements AWS.


# Table comparative

- Voici une table comparative des fonctions intrinsèques utilisées dans votre template AWS CloudFormation : `!Ref`, `!GetAtt`, `!FindInMap`, `!ImportValue`, `!Sub`, et `Fn::Base64`.

| **Fonction**   | **Description**                                                                                           | **Usage Principal**                                                                 | **Exemple**                                                                                      |
|----------------|-----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------|--------------------------------------------------------------------------------------------------|
| **`!Ref`**     | Retourne la valeur d'un paramètre ou l'ID d'une ressource définie dans le template.                        | Obtenir la valeur d'un paramètre ou l'identifiant d'une ressource.                  | `InstanceType: !Ref InstanceTypeParameter`                                                       |
| **`!GetAtt`**  | Récupère la valeur d'un attribut spécifique d'une ressource AWS.                                           | Accéder à une propriété spécifique d'une ressource AWS (comme l'IP d'une instance). | `WebServerPublicIP: !GetAtt 'CafeInstance.PublicIp'`                                             |
| **`!FindInMap`**| Récupère une valeur spécifique dans un mappage défini dans la section `Mappings` du template.              | Chercher des valeurs dynamiques selon des paramètres comme la région AWS.           | `KeyName: !FindInMap - RegionMap - !Ref 'AWS::Region' - keypair`                                 |
| **`!ImportValue`**| Importe une valeur exportée par un autre stack CloudFormation.                                          | Partager des valeurs entre différents stacks CloudFormation.                        | `VpcId: !ImportValue 'Fn::Sub': '${CafeNetworkParameter}-VpcID'`                                 |
| **`!Sub`**     | Effectue une substitution de variables dans une chaîne de caractères.                                      | Insérer dynamiquement des valeurs dans des chaînes de caractères.                   | `VpcId: !Sub '${CafeNetworkParameter}-VpcID'`                                                    |
| **`Fn::Base64`**| Encode une chaîne de caractères en Base64.                                                                | Encoder un script ou du texte à transmettre à une ressource comme EC2.              | `Fn::Base64: !Sub | #!/bin/bash yum -y update ...`                                               |

### Explication des Colonnes :

- **Fonction** : Le nom de la fonction intrinsèque utilisée dans AWS CloudFormation.
- **Description** : Une brève explication de ce que fait la fonction.
- **Usage Principal** : Indique le cas d'utilisation principal ou la raison pour laquelle vous utiliseriez cette fonction.
- **Exemple** : Un exemple tiré du template pour illustrer comment la fonction est utilisée.



# Annexe 01 


| **Fonction**   | **Description**                                                                                           | **Exemple Vulgarisé**                                                                                             | **Explication avec Contexte**                                                                                                           |
|----------------|-----------------------------------------------------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------|
| **`!Ref`**     | Retourne la valeur d'un paramètre ou l'ID d'une ressource définie dans le template.                        | **Exemple :** `!Ref InstanceTypeParameter`                                                                        | **Contexte :** Imaginons que vous avez un paramètre qui s'appelle `InstanceTypeParameter`, où vous pouvez choisir le type d'instance EC2 (par exemple, `t2.micro`). En utilisant `!Ref InstanceTypeParameter`, vous récupérez la valeur choisie (par exemple, `t2.micro`) et l'utilisez ailleurs dans le template. C'est comme dire : "Utilise la valeur que j'ai définie plus tôt." |
| **`!GetAtt`**  | Récupère la valeur d'un attribut spécifique d'une ressource AWS.                                           | **Exemple :** `!GetAtt CafeInstance.PublicIp`                                                                     | **Contexte :** Après avoir créé une instance EC2 (`CafeInstance`), vous voulez obtenir son adresse IP publique pour la partager. Avec `!GetAtt CafeInstance.PublicIp`, vous dites : "Donne-moi l'adresse IP publique de cette instance que je viens de créer." |
| **`!FindInMap`**| Récupère une valeur spécifique dans un mappage défini dans la section `Mappings`.                         | **Exemple :** `!FindInMap [RegionMap, us-east-1, keypair]`                                                        | **Contexte :** Vous avez un mappage (`Mappings`) qui associe des régions AWS à des paires de clés SSH. Avec `!FindInMap [RegionMap, us-east-1, keypair]`, vous récupérez la clé SSH pour la région `us-east-1`. C'est comme dire : "Trouve la clé qui correspond à cette région." |
| **`!ImportValue`**| Importe une valeur exportée par un autre stack CloudFormation.                                          | **Exemple :** `!ImportValue NetworkStack-SubnetID`                                                                | **Contexte :** Vous avez un autre stack CloudFormation qui a déjà créé un sous-réseau et a exporté son ID. Avec `!ImportValue NetworkStack-SubnetID`, vous importez cet ID dans votre template actuel. C'est comme dire : "Prends l'ID du sous-réseau que quelqu'un d'autre a déjà créé." |
| **`!Sub`**     | Effectue une substitution de variables dans une chaîne de caractères.                                      | **Exemple :** `!Sub '${AWS::Region}-bastion'`                                                                     | **Contexte :** Vous voulez créer un nom pour une ressource qui inclut la région AWS actuelle. Avec `!Sub '${AWS::Region}-bastion'`, si vous êtes dans la région `us-east-1`, cela devient `us-east-1-bastion`. C'est comme dire : "Remplis ce modèle avec la région actuelle." |
| **`Fn::Base64`**| Encode une chaîne de caractères en Base64.                                                                | **Exemple :** `Fn::Base64: !Sub "Hello, World!"`                                                                  | **Contexte :** Vous voulez envoyer un script à une instance EC2 au démarrage, mais il doit être encodé en Base64. Avec `Fn::Base64: !Sub "Hello, World!"`, le texte `Hello, World!` est converti en une chaîne encodée en Base64. C'est comme dire : "Transforme ce message en un format que l'instance peut lire." |

### Explications Vulgarisées:

- **`!Ref`** : Pensez à `!Ref` comme un rappel. Si vous avez déjà défini quelque chose (comme un paramètre), `!Ref` vous permet de le réutiliser ailleurs. C'est comme dire "Utilise cette chose que j'ai déjà définie."

- **`!GetAtt`** : Considérez `!GetAtt` comme une manière d'obtenir une caractéristique spécifique d'une ressource que vous avez déjà créée. C'est comme demander l'adresse d'une maison que vous venez de construire : "Donne-moi l'adresse (IP publique) de cette maison (instance)."

- **`!FindInMap`** : Imaginez que vous avez un tableau avec des informations pour différentes régions. `!FindInMap` vous permet de chercher une entrée spécifique dans ce tableau en fonction de la région. C'est comme dire "Regarde dans le tableau et trouve ce dont j'ai besoin pour cette région."

- **`!ImportValue`** : Pensez à `!ImportValue` comme un moyen de récupérer quelque chose que quelqu'un d'autre a déjà fait. Par exemple, si quelqu'un d'autre a déjà préparé un réseau, vous pouvez dire "Donne-moi ce réseau que quelqu'un d'autre a déjà configuré."

- **`!Sub`** : `!Sub` est comme un modèle que vous remplissez avec des informations spécifiques. C'est comme avoir un modèle d'email où vous insérez le nom de la personne : "Cher [Nom], merci pour votre achat."

- **`Fn::Base64`** : Imaginez que vous devez envoyer un message codé que seule la machine peut lire. `Fn::Base64` encode votre message en une langue que la machine peut comprendre.



# Annexe 02

- Exemple de template AWS CloudFormation utilisant les fonctions intrinsèques `!Ref`, `!GetAtt`, `!FindInMap`, `!ImportValue`, `!Sub`, et `Fn::Base64`.
- Je vais aussi vous proposer un exercice pour trouver les valeurs correspondantes après la création des ressources.

### Exemple de Template CloudFormation

```yaml
AWSTemplateFormatVersion: 2010-09-09
Description: Exemple de template pour démontrer l'utilisation des fonctions intrinsèques

Parameters:
  InstanceTypeParameter:
    Type: String
    Default: t2.micro
    AllowedValues:
      - t2.micro
      - t2.small
      - t2.medium
    Description: Choisissez le type d'instance EC2

  EnvironmentName:
    Type: String
    Default: Dev
    Description: Nom de l'environnement (Dev, Prod, etc.)

Mappings:
  RegionMap:
    us-east-1:
      AMI: ami-0c55b159cbfafe1f0
    us-west-2:
      AMI: ami-061392db613a6357b

Resources:

  ExampleSecurityGroup:
    Type: 'AWS::EC2::SecurityGroup'
    Properties:
      GroupDescription: Sécurité de base pour l'instance
      VpcId: !ImportValue DefaultVPCId
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: '22'
          ToPort: '22'
          CidrIp: 0.0.0.0/0

  ExampleInstance:
    Type: 'AWS::EC2::Instance'
    Properties:
      InstanceType: !Ref InstanceTypeParameter
      ImageId: !FindInMap [RegionMap, !Ref 'AWS::Region', AMI]
      SecurityGroupIds:
        - !Ref ExampleSecurityGroup
      KeyName: my-key-pair
      UserData:
        Fn::Base64:
          !Sub |
            #!/bin/bash
            echo "Bienvenue dans l'environnement ${EnvironmentName}!" > /var/www/html/index.html
      Tags:
        - Key: Name
          Value: !Sub "${EnvironmentName}-Instance"

Outputs:
  InstanceId:
    Description: ID de l'instance EC2
    Value: !Ref ExampleInstance

  PublicIP:
    Description: Adresse IP publique de l'instance
    Value: !GetAtt ExampleInstance.PublicIp

  InstanceAMI:
    Description: AMI utilisée pour lancer l'instance
    Value: !FindInMap [RegionMap, !Ref 'AWS::Region', AMI]
```

### Explication du Template

- **`!Ref`** :
  - Utilisé pour récupérer la valeur du paramètre `InstanceTypeParameter` pour déterminer le type d'instance EC2.
  - Utilisé pour récupérer la région AWS actuelle avec `!Ref 'AWS::Region'`.

- **`!GetAtt`** :
  - Utilisé dans les sorties pour obtenir l'adresse IP publique de l'instance EC2 créée (`ExampleInstance`).

- **`!FindInMap`** :
  - Utilisé pour récupérer l'AMI (Amazon Machine Image) en fonction de la région AWS. Le mappage `RegionMap` est utilisé ici.

- **`!ImportValue`** :
  - Utilisé pour récupérer l'ID du VPC par défaut d'un autre stack CloudFormation avec la clé `DefaultVPCId`.

- **`!Sub`** :
  - Utilisé pour insérer dynamiquement le nom de l'environnement (`EnvironmentName`) dans les valeurs des balises et le contenu du script `UserData`.

- **`Fn::Base64`** :
  - Utilisé pour encoder le script `UserData` en Base64 avant qu'il ne soit transmis à l'instance EC2 pour être exécuté au démarrage.

### Exercice pour Trouver les Valeurs

1. **Trouver le type d'instance utilisé :**
   - **Question :** Quelle est la valeur du type d'instance utilisée pour `ExampleInstance` ?
   - **Piste :** Regardez la valeur du paramètre `InstanceTypeParameter` et comment il est référencé dans la ressource `ExampleInstance`.

2. **Obtenir l'adresse IP publique de l'instance :**
   - **Question :** Quelle est l'adresse IP publique de l'instance EC2 après son lancement ?
   - **Piste :** Vérifiez la sortie `PublicIP` qui utilise `!GetAtt`.

3. **Identifier l'AMI utilisée :**
   - **Question :** Quelle AMI (Amazon Machine Image) est utilisée pour lancer l'instance EC2 en fonction de la région ?
   - **Piste :** Consultez la section `Mappings` et la manière dont `!FindInMap` est utilisé.

4. **Vérifier le contenu de la page web générée :**
   - **Question :** Quel message est écrit dans la page web `/var/www/html/index.html` de l'instance EC2 ?
   - **Piste :** Regardez le script `UserData` encodé en Base64 et comment `!Sub` est utilisé pour insérer la variable `EnvironmentName`.

5. **Importation du VPC ID :**
   - **Question :** D'où vient l'ID du VPC utilisé pour le groupe de sécurité `ExampleSecurityGroup` ?
   - **Piste :** Examinez comment `!ImportValue` est utilisé pour importer une valeur externe.

### Résumé

Ce template illustre comment chaque fonction intrinsèque est utilisée dans AWS CloudFormation, avec des exemples concrets et un exercice pour vérifier votre compréhension en trouvant les valeurs utilisées après le déploiement.
