# Installation de CloudFormation

CloudFormation peut être utilisé via la console AWS, l’interface de ligne de commande (CLI) AWS ou par des SDKs dans différents langages. Pour une installation efficace et flexible, nous allons nous concentrer sur l’utilisation de l’AWS CLI, qui permet de créer et gérer des stacks CloudFormation directement depuis la ligne de commande.

## Prérequis pour l'Installation

Avant de pouvoir utiliser CloudFormation avec l’AWS CLI, assurez-vous de :
1. **Avoir un compte AWS** : Vous aurez besoin d’un accès au portail AWS pour configurer votre utilisateur.
2. **Installer l’AWS CLI** : L’AWS CLI est l’outil de ligne de commande qui permet d’interagir avec tous les services AWS, y compris CloudFormation.
3. **Configurer vos identifiants AWS** : Configurer vos identifiants AWS vous permettra d’authentifier les commandes CLI.

---

## Étape 1 : Installation de l’AWS CLI

### a. Sur Windows

1. Téléchargez l'installateur MSI de l’AWS CLI depuis le site officiel : [AWS CLI pour Windows](https://aws.amazon.com/cli/).
2. Exécutez l’installateur et suivez les étapes d’installation.
3. Pour vérifier l’installation, ouvrez l’invite de commandes et tapez :
   ```bash
   aws --version
   ```

### b. Sur macOS

1. Installez l’AWS CLI via Homebrew en utilisant la commande suivante :
   ```bash
   brew install awscli
   ```
2. Vérifiez l’installation :
   ```bash
   aws --version
   ```

### c. Sur Linux

1. Installez l’AWS CLI en téléchargeant l’installateur :
   ```bash
   curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
   unzip awscliv2.zip
   sudo ./aws/install
   ```
2. Vérifiez l’installation :
   ```bash
   aws --version
   ```

---

## Étape 2 : Configuration des Identifiants AWS

Une fois l’AWS CLI installée, configurez vos identifiants pour accéder aux services AWS.

1. Exécutez la commande de configuration :
   ```bash
   aws configure
   ```
2. Entrez les informations demandées :
   - **AWS Access Key ID** : Votre clé d’accès.
   - **AWS Secret Access Key** : Votre clé secrète.
   - **Default region name** : La région AWS par défaut (par exemple, `us-east-1`).
   - **Default output format** : Le format de sortie (JSON, text, etc.).

### Exemple de Configuration

```bash
$ aws configure
AWS Access Key ID [None]: <votre-access-key>
AWS Secret Access Key [None]: <votre-secret-access-key>
Default region name [None]: us-east-1
Default output format [None]: json
```

---

## Étape 3 : Vérification de l'Accès à CloudFormation

Pour vérifier que votre configuration est correcte et que vous avez accès à CloudFormation, exécutez une commande simple, comme la liste des stacks CloudFormation :

```bash
aws cloudformation list-stacks
```

Si votre configuration est correcte, vous devriez voir une liste des stacks existantes (ou un message indiquant qu’il n’y en a pas encore).

---

## Exemple d’Utilisation Basique : Créer une Stack CloudFormation

Pour vérifier que tout fonctionne, vous pouvez essayer de créer une simple stack CloudFormation. Utilisez un template de base (par exemple, un bucket S3) et exécutez la commande suivante :

```bash
aws cloudformation create-stack --stack-name MyTestStack --template-body file://template.yaml
```

Dans cette commande :
- **--stack-name** : Nom de la stack.
- **--template-body** : Chemin vers le fichier template.

> **Note** : Assurez-vous que `template.yaml` contient une définition de ressource valide.

---

## Conclusion

Vous êtes maintenant prêt à utiliser CloudFormation via l’AWS CLI ! Cette configuration vous donne la flexibilité de gérer vos ressources AWS de manière automatisée, tout en intégrant facilement CloudFormation dans vos scripts ou pipelines CI/CD.
