
# Examen de mi-session

**Déploiement – Jenkins, Git, AWS**
**Durée :** 4 heures
**Matériel autorisé :** Documentation en ligne et notes personnelles

---

## Partie 1 – Questions à choix multiples

**Instructions :** Cochez une seule réponse correcte par question, sauf indication contraire.

1. Quel type de projet Jenkins devez-vous sélectionner pour exécuter automatiquement un pipeline défini dans un fichier `Jenkinsfile` situé dans un dépôt Git ?

   * a) Freestyle project
   * b) Maven project
   * c) Pipeline project
   * d) Build flow project

2. Quel est le rôle principal d’AWS CodeCommit ?

   * a) Orchestrer des tâches CI/CD sur le cloud
   * b) Fournir une base de données NoSQL pour Git
   * c) Héberger des dépôts Git privés dans AWS
   * d) Déclencher des alarmes CloudWatch

3. Dans AWS CodePipeline, quelle étape permet l’automatisation du déploiement vers un environnement cible ?

   * a) Source
   * b) Build
   * c) Deploy
   * d) Approval

4. Quel fichier est essentiel pour exécuter automatiquement une stack CloudFormation ?

   * a) `deploy.sh`
   * b) `template.yml`
   * c) `main.tf`
   * d) `aws.config`

5. Quelle commande Git permet de relier un dépôt local à un dépôt CodeCommit distant ?

   * a) `git connect aws`
   * b) `git remote add origin <url>`
   * c) `aws codecommit link`
   * d) `git clone s3://bucket`

6. Quelle ressource est définie dans un template CloudFormation pour créer un repository Git ?

   * a) `AWS::CodePipeline::Repository`
   * b) `AWS::CodeCommit::Repository`
   * c) `AWS::EC2::GitRepo`
   * d) `AWS::DevTools::GitService`

7. Dans Jenkins, quel type de déclencheur permet de surveiller automatiquement les commits dans AWS CodeCommit ?

   * a) Poll SCM
   * b) GitHub webhook
   * c) CloudWatch Event trigger
   * d) AWS CodeCommit plugin + webhook

8. Quelle option de Git permet de cloner un seul *branch* spécifique d’un dépôt ?

   * a) `git branch --only`
   * b) `git clone -b <branch> --single-branch <url>`
   * c) `git fetch branch=<branch>`
   * d) `git pull branch <branch>`

9. Lequel des services suivants permet de déclencher un pipeline CI/CD sans serveur ?

   * a) Jenkins installé sur EC2
   * b) AWS CodePipeline
   * c) AWS Lambda uniquement
   * d) Amazon ECS

10. Parmi les éléments suivants, lesquels peuvent figurer dans un template CloudFormation ?
    (2 bonnes réponses)

* a) `Resources`
* b) `Modules`
* c) `Outputs`
* d) `Events`

---

## Partie 2 – Questions de réflexion

11. Expliquez en 3 à 5 lignes la différence entre Jenkins et AWS CodePipeline en termes de CI/CD. Donnez un avantage et un inconvénient pour chacun.

---

12. Complétez le diagramme suivant en indiquant l’ordre exact d’exécution (1 à 5), et justifiez brièvement :

* [ ] Déclenchement via commit sur CodeCommit
* [ ] Étape de build Jenkins
* [ ] Déploiement via CloudFormation
* [ ] Validation du commit dans CodePipeline
* [ ] Tests automatisés

---

13. Pourquoi est-il important de versionner les fichiers d’infrastructure comme les templates CloudFormation dans un dépôt Git ? Comment cela s’intègre-t-il dans une logique DevOps ?

---

14. Expliquez la différence entre un service de gestion de conteneurs et un orchestrateur CI/CD. Donnez deux exemples concrets.

---

15. Analysez le template CloudFormation suivant :

```yaml
AWSTemplateFormatVersion: '2010-09-09'
Resources:
  WebsiteBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: mon-site-statique-examen
      AccessControl: PublicRead
      WebsiteConfiguration:
        IndexDocument: index.html
        ErrorDocument: error.html
      LoggingConfiguration:
        DestinationBucketName: !Ref LogsBucket
        LogFilePrefix: logs/

  LogsBucket:
    Type: AWS::S3::Bucket
    Properties:
      BucketName: logs-bucket-examen
      AccessControl: LogDeliveryWrite

  WebsiteBucketPolicy:
    Type: AWS::S3::BucketPolicy
    Properties:
      Bucket: !Ref WebsiteBucket
      PolicyDocument:
        Version: "2012-10-17"
        Statement:
          - Sid: PublicReadGetObject
            Effect: Allow
            Principal: "*"
            Action: s3:GetObject
            Resource: !Sub "${WebsiteBucket.Arn}/*"

  EC2Role:
    Type: AWS::IAM::Role
    Properties:
      RoleName: EC2WriteLogsToS3
      AssumeRolePolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Principal:
              Service: ec2.amazonaws.com
            Action: sts:AssumeRole

  EC2WriteLogsPolicy:
    Type: AWS::IAM::Policy
    Properties:
      PolicyName: WriteLogsToS3
      Roles:
        - !Ref EC2Role
      PolicyDocument:
        Version: '2012-10-17'
        Statement:
          - Effect: Allow
            Action:
              - s3:PutObject
            Resource: !Sub "${LogsBucket.Arn}/*"

  EC2InstanceProfile:
    Type: AWS::IAM::InstanceProfile
    Properties:
      Path: /
      Roles:
        - !Ref EC2Role

Outputs:
  WebsiteURL:
    Value: !Sub "http://${WebsiteBucket}.s3-website-${AWS::Region}.amazonaws.com"
```

**Expliquez :**

* Le rôle de chaque ressource.
* Le comportement global de cette architecture.
* L’intention derrière ce template.
* Le but de la sortie (`Output`) finale.

---

## Partie 3 – Automatisation d’un projet Python avec Jenkins

### Instructions

Le fichier `scraper.py` contient un script Python qui extrait automatiquement la liste des langages de programmation depuis Wikipédia et les sauvegarde dans un fichier CSV nommé `data.csv`.

### Objectif

Vous devez :

1. Modifier ce projet pour l’intégrer dans un pipeline Jenkins.
2. Créer un fichier `Jenkinsfile` à la racine du projet qui automatise les étapes suivantes :

   * Installer les dépendances Python à partir de `requirements.txt`
   * Exécuter le script `scraper.py`
   * Archiver le fichier `data.csv` comme artefact dans Jenkins

### À faire

* Vous devez écrire vous-même le fichier `Jenkinsfile` (aucun fichier fourni)
* Vous devez exécuter le pipeline dans Jenkins avec succès
* Vous devez prendre une capture d’écran de Jenkins montrant :

  * L’état **succès** du pipeline
  * Le fichier `data.csv` visible dans les artefacts Jenkins

---

### Bonus (facultatif)

* Expliquez brièvement ce qu’est un **webhook dans Jenkins**
* Donnez un exemple concret d’utilisation d’un webhook pour déclencher automatiquement un pipeline lorsqu’un commit est poussé sur un dépôt Git

---

### Fichier `scraper.py`

```python
import requests
from bs4 import BeautifulSoup
import pandas as pd

url = "https://fr.wikipedia.org/wiki/Liste_des_langages_de_programmation"
response = requests.get(url)
if response.status_code != 200:
    print("Erreur lors du chargement de la page")
    exit()

soup = BeautifulSoup(response.text, "lxml")

# Récupération de tous les éléments <li> dans la section du contenu principal
content = soup.find("div", {"id": "mw-content-text"})
items = content.find_all("li")

langages = []
for li in items:
    a_tag = li.find("a")
    if a_tag and "/wiki/" in a_tag.get("href", ""):
        texte = a_tag.text.strip()
        if texte and texte not in langages and not texte.startswith("Liste"):
            langages.append(texte)

# Nettoyage possible : retirer les entrées comme "Langage (informatique)"
langages = [l for l in langages if len(l) > 1 and not l.startswith("Portail")]

# Export
df = pd.DataFrame(langages, columns=["Langage"])
df.to_csv("data.csv", index=False, encoding="utf-8")

print("Fichier 'data.csv' généré avec", len(df), "langages.")

```

---

### Fichier `requirements.txt`

```
requests
beautifulsoup4
lxml
pandas
```


