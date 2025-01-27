---
title: "Pratique 12 - Travail pratique 2"
description: "Travail pratique 2 à réaliser individuellement pour maîtriser Terraform"
emoji: "🏠"
slug: "02-travail-pratique-02"
sidebar_position: 12
---


<a name="table-des-matieres"></a>
<br/>
<br/>
# Table des matières

1. [Introduction](#introduction)
2. [Partie 1 : Proposition de solution](#partie-1--proposition-de-solution)
   - [1. Cloner le Dépôt](#1-cloner-le-dépôt)
   - [2. Naviguer vers le Répertoire Cloné](#2-naviguer-vers-le-répertoire-cloné) 
   - [3. Dézipper le Fichier](#3-dézipper-le-fichier)
3. [Partie 2 : Points à vérifier](#partie-2--points-à-vérifier)
   - [Point 1 : Configuration de l'Utilisateur IAM et AWS CLI](#point-1)
   - [Point 2 : main.tf](#point-2)
   - [Point 3 : Security Group](#point-3)
   - [Point 4 : S3 Buckets](#point-4)
   - [Point 5 : Autoscaling Configuration](#point-5)
   - [Point 6 : Autoscaling.tf](#point-6)
   - [Point 7 : Snapshot.tf](#point-7)
   - [Point 8 : RDS.tf](#point-8)
   - [Point 9 : Autoscaling vs RDS](#point-9)
   - [Point 10 : Fonction Lambda](#point-10)
4. [Exercice](#exercice)
5. [Annexe 1 : Résumé des étapes](#annexe-1)
6. [Annexe 2 : Prérequis](#annexe-2)    


<a name="introduction"></a>
<br/>
# Travail pratique 2

**Travailler avec un serveur web résistant aux attaques avec des sauvegardes automatisées du système d'exploitation et des journaux**

Vous devez créer une instance EC2 qui héberge votre site web (basé sur PHP). La base de données du site web sera sur RDS (MySQL). Vous devez créer un bucket S3 qui synchronisera les journaux et les pages web de votre serveur HTTPS dans différents dossiers. Le bucket S3 doit se synchroniser toutes les 5 minutes. Configurez tous les paramètres sur l'instance Linux. Mettez en œuvre le concept d'autoscaling (1-3 instances) avec un load balancer pour atténuer les surcharges pendant les périodes de pointe.Vous devez également créer un cycle de vie pour le bucket afin de gérer les versions précédentes des journaux. Après tous les 2 jours, les versions précédentes des journaux doivent être supprimées (ou transférées vers Glacier).SNS doit être configuré pour recevoir des notifications par e-mail lorsque le nombre d'instances augmente ou diminue.Configurez également des snapshots du disque système toutes les 12 heures et conservez au moins les 2 derniers snapshots.

<a name="partie-1--proposition-de-solution"></a>
[⬆️ Retour à la table des matières](#table-des-matieres)
<br/>

---
## Partie 1 : Proposition de solution
---

<br/>

```bash
git clone https://github.com/hrhouma/terraform-1.git
cd terraform-1
unzip terraform-1.zip   # Pour Linux/macOS
tar -xf terraform-1.zip # Pour Windows
code . # Pour ouvrir le dossier dans VSCode
```

## 1. Cloner le Dépôt
Tout d'abord, vous devez cloner le dépôt en utilisant Git. Ouvrez votre terminal (ou l'invite de commande) et exécutez la commande suivante :

```bash
git clone https://github.com/hrhouma/terraform-1.git
```

Cette commande va cloner le dépôt sur votre machine locale.

## 2. Naviguer vers le Répertoire Cloné
Après avoir cloné le dépôt, vous devez naviguer vers le répertoire où le dépôt a été cloné :

```bash
cd terraform-1
```

## 3. Dézipper le Fichier
Maintenant que vous êtes dans le répertoire cloné, vous pouvez dézipper le fichier `terraform-1.zip` en utilisant la commande suivante :

Sur **Linux ou macOS** :
```bash
unzip terraform-1.zip
```

Sur **Windows** :
Si vous utilisez l'invite de commande, vous pouvez utiliser la commande suivante :
```cmd
tar -xf terraform-1.zip
```

Vous pouvez aussi double-cliquer sur le fichier `.zip` dans l'explorateur de fichiers pour l'extraire.

<a name="partie-2--points-à-vérifier"></a>
[⬆️ Retour à la table des matières](#table-des-matieres)
<br/>
---
## Partie 2 : Points à vérifier :
---

<a name="point-1"></a>

<br/>



### 1. Point 1 : Configuration de l'Utilisateur IAM et AWS CLI

:::info Création de l'utilisateur IAM
1. Créer un utilisateur IAM nommé "john"
2. Attribuer la politique "AdministratorAccess" pour les permissions complètes
3. Générer et télécharger les clés d'accès (fichier CSV)
:::

:::tip Installation et Configuration AWS CLI
1. Télécharger AWS CLI v2 depuis le site officiel AWS
2. Installer AWS CLI en suivant les instructions pour votre système d'exploitation
3. Configurer AWS CLI avec la commande `aws configure` :
- Créer l'utilisateur IAM john et donner tous les permissions et donner AdministratorAccess
- Créer une clé d'accès pour IAM et télécharger le fichier csv.
- Télécharger AWS CLI2 depuis le site
- Écrire dans la ligne de commande aws configure et saisir 

:::info Configuration AWS CLI
- AWS Access Key ID: xxxxxxxxxxxxxxxxxxxxx
- AWS Secret Access Key: xxxxxxxxxxxxxxxxxxxxx
- Default region name: us-east-1
- Default output format: json
:::

[⬆️ Retour à la table des matières](#table-des-matieres)

<a name="point-2"></a>
<br/> 



### 2. Point 2 (main.tf)



- Dans la section Instance EC2 (6 points importants à vérifier). 
- Vérifier les paramètres suivants dans la ressource "aws_instance" "web_instance" :

1. AMI ID : ami-06b09bfacae1453cb
2. Type d'instance : t2.micro 
3. Nom de la clé : newtest
4. Zone de disponibilité : us-east-1a
5. Existence de la clé dans votre compte AWS
6. Disponibilité de l'AMI dans la région us-east-1

#### ⚠️ Section Instance EC2 dans main.tf ⚠️


```python
resource "aws_instance" "web_instance" {
  ami               = "ami-06b09bfacae1453cb"  # Remplacez par l'ID AMI souhaité
  instance_type     = "t2.micro"               # Remplacez par le type d'instance souhaité
  key_name          = "newtest"                # Remplacez par le nom de votre paire de clés
  availability_zone = "us-east-1a"             # Assurez-vous que cette zone correspond à celle du volume EBS
...
```

:::danger 1 - Vérification des paramètres ami
- Vérifier le ami ➜ ami-06b09bfacae1453cb
:::
:::danger 2 - Vérification des paramètres key_name
- Vérifier le key_name ➜ newtest
:::
:::danger 3 - Vérification des paramètres availability_zone
- Vérifier le availability_zone ➜ us-east-1a
:::
:::danger 4 - Vérification des paramètres availability_zone
- Vérifier encore le availability_zone ➜ Assurez-vous que cette zone correspond à celle du volume EBS  availability_zone = "us-east-1a" par exemple
:::
:::danger 5 - Vérification des paramètres existance de la clé
- Vérifier l'existance de la clé dans votre compte AWS sinon la créer
:::
:::danger 6 - Vérification des paramètres existance de ami-06b09bfacae1453cb
- Vérifier l'existance de ami-06b09bfacae1453cb dans us-east-1a
:::

[⬆️ Retour à la table des matières](#table-des-matieres)

<a name="point-3"></a>
<br/> 

### 3. Point 3 (main.tf dans la section security_group)


- Aller à resource "aws_security_group" "instance_sg"
- Allez à la partie description = "Security group for web instance"  
- Remplacez par une description sans accents ou caractères spéciaux


#### ⚠️ Section Groupe de sécurité pour l'instance EC2 ⚠️
```python
resource "aws_security_group" "instance_sg" {
  name        = "web_instance_sg"
  description = "Security group for web instance"  # Remplacez par une description sans accents ou caractères spéciaux
```

[⬆️ Retour à la table des matières](#table-des-matieres)
<a name="point-4"></a>
<br/>

### 4. Point 4 (main.tf dans la section s3)



- Assurer vous d'avoir 2 ID uniques dans bucket dans les 2 S3 (S3 bucket for logs et S3 bucket for webpages)

#### ⚠️ S3 bucket for logs ⚠️
```python
resource "aws_s3_bucket" "log_bucket" {
  bucket = "php-log-bucket-name-hrehouma2024"   # ça doit être unique
```

```python
# S3 bucket for webpages
resource "aws_s3_bucket" "webpage_bucket" {
  bucket = "php-webpage-bucket-name-20240816"  # ça doit être unique
```

[⬆️ Retour à la table des matières](#table-des-matieres)

<a name="point-5"></a>
<br/>

### 5. Point 5 (main.tf dans la section autoscaling)


Dans resource "aws_launch_configuration" "launch_config"  
- vérifier que nous avons le même image_id = "ami-06b09bfacae1453cb" que dans main.tf
- vérifier que le key_name = "newtest" existe  # Replace with your desired key pair name




#### Launch configuration for autoscaling group
```python
resource "aws_launch_configuration" "launch_config" {
  name                 = "web-launch-config"
  image_id             = "ami-06b09bfacae1453cb"    # Replace with your desired AMI ID
  instance_type        = "t2.micro"          # Replace with your desired instance type
  key_name             = "newtest"     # Replace with your desired key pair name
  security_groups      = [aws_security_group.instance_sg.id]
 ```

 [⬆️ Retour à la table des matières](#table-des-matieres)

<a name="point-6"></a>

<br/>

### 6. Point 6 (autoscaling.tf)
| Paramètre | Valeur | Localisation |
|-----------|---------|--------------|
| image_id | ami-06b09bfacae1453cb | aws_launch_configuration.launch_config |
| key_name | newtest | aws_launch_configuration.launch_config |
| vpc_zone_identifier | ["subnet-09a4469ba5c46ce7d"] | aws_autoscaling_group.autoscaling_group |
| subnets | ["subnet-0b2dce39a2161cdaf","subnet-09a4469ba5c46ce7d"] | aws_lb.load_balancer |
| vpc_id | vpc-0848dccf51992a448 | aws_lb_target_group.target_group |



:::success
- vpc_zone_identifier  = ["subnet-09a4469ba5c46ce7d"]  # Replace with your desired subnet IDs
- subnets            = ["subnet-0b2dce39a2161cdaf","subnet-09a4469ba5c46ce7d"]  # Replace with your desired subnet IDs
:::

[⬆️ Retour à la table des matières](#table-des-matieres)
<a name="point-7"></a>
<br/>

### 7.point 7 (snapshot.tf)

#### 7.1.Points à vérifier dans snapshot.tf

:::info Volume EBS pour le snapshot dans snapshot.tf
- endpoint dans resource "aws_sns_topic_subscription"
- "email_subscription" (# Remplacez par votre adresse email)
- availability_zone 


```python
# Volume EBS pour le snapshot
resource "aws_ebs_volume" "snapshot_volume" {
  availability_zone = "us-east-1a"  # !!!!!!!!!!! ICI !!!!!! Assurez-vous que cette zone correspond à celle de l'instance EC2
  size              = 100

```
:::

#### 7.2.Points à vérifier dans main.tf
Vérifier dans main.tf que nous avons bien configuré les paramètres ci-dessous. Ces paramètres doivent correspondre à ceux utilisés dans les autres fichiers de configuration, notamment pour la zone de disponibilité qui doit être identique à celle du volume EBS dans snapshot.tf.

- AMI ID : ami-06b09bfacae1453cb
- Type d'instance : t2.micro
- Nom de la clé : newtest 
- Zone de disponibilité : us-east-1a

:::info Instance EC2 dans main.tf

```python
resource "aws_instance" "web_instance" {
  ami               = "ami-06b09bfacae1453cb"  # Remplacez par l'ID AMI souhaité
  instance_type     = "t2.micro"               # Remplacez par le type d'instance souhaité
  key_name          = "newtest"                # Remplacez par le nom de votre paire de clés
  availability_zone = "us-east-1a"             # # !!!!!!!!!!! ICI !!!!!!  Assurez-vous que cette zone correspond à celle du volume EBS
```
:::

[⬆️ Retour à la table des matières](#table-des-matieres)
<a name="point-8"></a>

<br/>

### 8. PARTIE8 - rds.tf (1 point à vérifier)

:::info rds.tf
- Vérifier dans resource "aws_db_instance" "database" 
username             = "admin"          # Remplacez par votre nom d'utilisateur souhaité
  password             = "password" 
  
- Vérifiez   subnet_ids = ["subnet-0b2dce39a2161cdaf", "subnet-09a4469ba5c46ce7d"]  # Remplacez par vos IDs de sous-réseaux souhaités
 dans resource "aws_db_subnet_group" "subnet_group" 
::: 
 
 [⬆️ Retour à la table des matières](#table-des-matieres)
 
 <a name="point-9"></a>
 
<br/>
### 9. PARTIE9 - autoscaling.tf vs rds.tf


- *Créer deux sous réseaux à partir de votre VPC par défaut*

:::info autoscaling.tf vs rds.tf


##### Regardez les IDs des sous réseaux dans autoscaling.tf et rds.tf

- subnet-0064153d8fbdcb228
- subnet-09a4469ba5c46ce7d
:::

<a name="point-10"></a>
<br/>

[⬆️ Retour à la table des matières](#table-des-matieres)

<a name="point-10"></a>
<br/>

### 10. PARTIE10 - fonction lambda

:::info Fonction Lambda
La fonction Lambda est un composant clé qui permet d'automatiser la création de snapshots EBS. Voici les points importants à vérifier dans le fichier lambda_function.py :

1. **Définition du Handler** : 
   - La fonction `lambda_handler(event, context)` est le point d'entrée principal
   - Elle reçoit deux paramètres : `event` et `context`

2. **Configuration du Volume ID** :
   - Recherchez la ligne `volume_id = 'your_volume_id'`
   - Cette valeur doit être remplacée par l'ID réel de votre volume EBS
   - Format attendu : "vol-xxxxxxxxxxxxxxxxx"

3. **Création du Snapshot** :
   - La fonction utilise boto3 pour créer un snapshot
   - Vérifie la ligne : `ec2.create_snapshot(VolumeId=volume_id)`
   - Cette commande initie la création du snapshot

4. **Utilisation de boto3** :
   - boto3 est le SDK AWS officiel pour Python
   - La ligne `ec2 = boto3.client('ec2')` initialise le client EC2
   - Permet d'interagir avec les services AWS via Python

5. **Points de Vérification** :
   - Assurez-vous que le volume_id est correctement configuré
   - Vérifiez que boto3 est importé au début du fichier
   - Confirmez que les permissions IAM sont correctement configurées
:::

[⬆️ Retour à la table des matières](#table-des-matieres)

<a name="point-11"></a>
<br/>

# Résumé
:::info lambda_function.py

:::warning lambda_package\lambda_function.py (1 point à vérifier)
lambda_package\lambda_function.py (1 point à vérifier)
:::

[⬆️ Retour à la table des matières](#table-des-matieres)
<a name="conclusion"></a>

<br/>

# En Conclusion

:::danger points à vérifier dans le lambda_function.py
   - *point 4*  allez à def lambda_handler(event, context):
   - *point 5*     # Replace the 'your_volume_id' with the actual EBS volume ID you want to snapshot
   - *point 6*  # Chercher le volume_id = 'your_volume_id'
  - *point 11*  # Chercher le Create a snapshot of the EBS volume
  - *point 12*  # Chercher le ec2 = boto3.client('ec2'): D'après vous, c'est quoi boto3 ?
:::

[⬆️ Retour à la table des matières](#table-des-matieres)










<a name="exercice"></a>

## Exercice

:::danger Exercice
Question pour les apprenants :

Comment pourriez-vous éviter la répétition des valeurs comme "ami-06b09bfacae1453cb" et "newtest" qui apparaissent plusieurs fois dans le code ? 

Indice : Pensez à l'utilisation de variables Terraform pour centraliser ces valeurs à un seul endroit.
:::

[⬆️ Retour à la table des matières](#table-des-matieres)



<a name="annexe-1"></a>

<br/>
---
## Annexe 1 : Résumé des étapes
---
<br/>


## Instructions 

Suivez ces étapes pour cloner le projet, remplacer les variables nécessaires, et déployer l'infrastructure sur AWS à l'aide de Terraform.

### Étape 1 : Cloner le Dépôt Git
Commencez par cloner le dépôt Git contenant le projet Terraform. Ouvrez votre terminal et exécutez la commande suivante :

```sh
git clone https://github.com/hrhouma/terraform-1.git
```

### Étape 2 : Naviguer dans le Répertoire du Projet
Après avoir cloné le dépôt, accédez au répertoire du projet :

```sh
cd terraform-1
```

### Étape 3 : Ouvrir le Projet dans Votre Editeur de Code
Ensuite, ouvrez le projet dans votre éditeur de code (par exemple, Visual Studio Code) en utilisant la commande suivante :

```sh
code .
```

### Étape 4 : Remplacer les Variables Nécessaires
Avant de déployer l'infrastructure, vous devez remplacer certaines variables dans les fichiers de configuration Terraform. Voici un rappel des variables à remplacer :

1. **lambda_function.py**
   - **`volume_id`** : Remplacez par l'ID du volume EBS que vous souhaitez utiliser.

2. **log.py**
   - **`source_bucket_name`** : Remplacez par le nom de votre bucket S3 source.
   - **`destination_bucket_name`** : Remplacez par le nom de votre bucket S3 de destination.

3. **webpage.py**
   - **`source_bucket_name`** : Remplacez par le nom de votre bucket S3 source.
   - **`destination_bucket_name`** : Remplacez par le nom de votre bucket S3 de destination.

4. **autoscaling.tf**
   - **`image_id`** : Remplacez par l'ID AMI de votre choix.
   - **`key_name`** : Remplacez par le nom de votre paire de clés EC2.
   - **`vpc_zone_identifier`** : Remplacez par les IDs de vos sous-réseaux.
   - **`subnets`** : Remplacez par les IDs de vos sous-réseaux.
   - **`vpc_id`** : Remplacez par votre ID de VPC.

5. **main.tf**
   - **`region`** : Remplacez par la région AWS de votre choix.
   - **`ami`** : Remplacez par l'ID AMI de votre choix.
   - **`key_name`** : Remplacez par le nom de votre paire de clés EC2.

6. **rds.tf**
   - **`username`** : Remplacez par votre nom d'utilisateur souhaité pour la base de données RDS.
   - **`password`** : Remplacez par votre mot de passe souhaité pour la base de données RDS.
   - **`subnet_ids`** : Remplacez par les IDs de vos sous-réseaux.

7. **s3.tf**
   - **`bucket`** : Remplacez par le nom des buckets S3 pour les logs et les pages web.

8. **snapshot.tf**
   - **`endpoint`** : Remplacez par votre adresse email pour recevoir les notifications.
   - **`subnet_ids`** : Remplacez par les IDs de vos sous-réseaux pour les snapshots.

Utilisez votre éditeur de code pour rechercher et remplacer les valeurs mentionnées ci-dessus.

#### Étape 5 : Initialiser Terraform
Une fois les variables remplacées, initialisez Terraform pour configurer votre environnement :

```sh
terraform init
```

### Étape 6 : Appliquer les Modifications
Déployez l'infrastructure en appliquant les configurations avec Terraform :

```sh
terraform apply --auto-approve
```

### Étape 7 (Optionnel) : Détruire l'Infrastructure
Si vous souhaitez détruire l'infrastructure créée après avoir terminé, exécutez la commande suivante :

```sh
terraform destroy --auto-approve
```

[⬆️ Retour à la table des matières](#table-des-matieres)
<a name="annexe-2"></a>
<br/>
----
## Annexe 2 :  Prérequis 
----
<br/>

Avant de lancer Terraform pour déployer l'infrastructure, certaines ressources et configurations doivent être créées ou préparées au préalable. Voici une liste des éléments qui doivent être prêts :

### 1. **Paire de Clés EC2**
   - **Description** : Une paire de clés EC2 est nécessaire pour accéder aux instances EC2 que vous allez créer. Cette paire de clés est utilisée pour se connecter via SSH à vos instances EC2.
   - **Création** : 
     - Créez une nouvelle paire de clés via la console AWS EC2 sous la section "Network & Security" > "Key Pairs".
     - Téléchargez le fichier `.pem` associé à cette paire de clés et conservez-le en lieu sûr.
   - **Usage** : Le nom de cette paire de clés doit être référencé dans les fichiers Terraform (`main.tf` et `autoscaling.tf`).

### 2. **IDs de Sous-Réseaux**
   - **Description** : Les sous-réseaux sont des segments logiques d'un VPC dans lesquels les ressources AWS sont déployées. Vous devez disposer des IDs de sous-réseaux existants dans lesquels les instances EC2, RDS et autres ressources seront créées.
   - **Création** :
     - Si vous n'avez pas encore de sous-réseaux, créez-les dans votre VPC via la console AWS sous "VPC" > "Subnets".
   - **Usage** : Les IDs de sous-réseaux doivent être spécifiés dans les fichiers Terraform (`autoscaling.tf`, `rds.tf`, `snapshot.tf`).

### 3. **ID du VPC**
   - **Description** : Un VPC (Virtual Private Cloud) est une zone de réseau isolée dans laquelle vous déployez vos ressources AWS. Vous devez connaître l'ID de votre VPC pour l'utiliser dans les configurations Terraform.
   - **Création** :
     - Un VPC par défaut est fourni par AWS, mais vous pouvez également créer votre propre VPC via la console AWS sous "VPC" > "Your VPCs".
   - **Usage** : L'ID du VPC doit être référencé dans les fichiers Terraform (`autoscaling.tf`, `main.tf`, `rds.tf`, etc.).

### 4. **Buckets S3 (optionnel)**
   - **Description** : Si votre projet utilise des buckets S3 spécifiques pour stocker des logs ou des pages web, vous pouvez les créer à l'avance ou laisser Terraform les créer.
   - **Création** :
     - Créez les buckets via la console AWS sous "S3".
   - **Usage** : Les noms des buckets doivent être spécifiés dans `s3.tf`.

### 5. **Permissions IAM**
   - **Description** : L'utilisateur ou le rôle IAM exécutant Terraform doit disposer des permissions nécessaires pour créer et gérer toutes les ressources mentionnées dans vos fichiers Terraform.
   - **Création** :
     - Attachez des politiques comme **AdministratorAccess** ou des politiques spécifiques (AmazonEC2FullAccess, AmazonRDSFullAccess, etc.) à l'utilisateur ou au rôle IAM qui exécutera Terraform.

### 6. **Adresse Email pour SNS (optionnel)**
   - **Description** : Si vous configurez des notifications via SNS (Simple Notification Service), vous devez disposer d'une adresse email valide pour recevoir ces notifications.
   - **Création** :
     - Aucune création préalable n'est nécessaire, mais vous devez disposer d'une adresse email que vous spécifierez dans `snapshot.tf`.

### 7. **Installation de Terraform**
   - **Description** : Terraform doit être installé et configuré sur votre machine locale.
   - **Installation** :
     - Suivez les instructions d'installation pour Windows, macOS ou Linux disponibles sur le site officiel de Terraform.

[⬆️ Retour à la table des matières](#table-des-matieres)

---

## Résumé

Avant de lancer Terraform, assurez-vous que les éléments suivants sont créés et prêts à l'emploi :
1. **Paire de clés EC2**
2. **IDs de sous-réseaux**
3. **ID du VPC**
4. **Buckets S3** (si nécessaire)
5. **Permissions IAM** pour l'utilisateur ou le rôle IAM
6. **Adresse email pour SNS** (si nécessaire)
7. **Installation de Terraform** sur votre machine

Une fois ces éléments prêts, vous pouvez procéder au remplacement des variables dans les fichiers Terraform et déployer l'infrastructure.


[⬆️ Retour à la table des matières](#table-des-matieres)


