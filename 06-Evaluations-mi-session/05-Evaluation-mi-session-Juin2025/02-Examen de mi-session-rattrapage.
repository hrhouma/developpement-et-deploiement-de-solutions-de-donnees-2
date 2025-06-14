# Examen de mi-session (rattrapage)

**Thème :** Déploiement – Jenkins, Git, AWS
**Durée :** 4 heures
**Matériel autorisé :** Documentation en ligne et notes personnelles



## Partie 1 – Questions à choix multiples

**Instructions :** Cochez une seule réponse correcte par question, sauf indication contraire.

1. Quelle commande permet d’exécuter un pipeline Jenkins localement à des fins de test (dans un Jenkins installé en local) ?

   * a) `jenkins start pipeline`
   * b) `jenkins-cli run`
   * c) Aucun exécutable direct, on doit pousser ou déclencher dans l’interface Jenkins
   * d) `jenkins runfile Jenkinsfile`

2. Quel type de plugin Jenkins permet de déployer automatiquement dans un environnement AWS ?

   * a) AWS EC2 Plugin
   * b) Amazon S3 Publisher
   * c) AWS CodePipeline Notifier
   * d) Amazon Deployer

3. Quel rôle joue la section `post` dans un `Jenkinsfile` ?

   * a) Définir des variables globales
   * b) Déclencher des étapes conditionnelles après l'échec ou le succès
   * c) Gérer le code source Git
   * d) Lancer le job toutes les nuits

4. Dans AWS, quel service est le plus adapté pour stocker les artefacts d’un build Jenkins ?

   * a) Amazon EC2
   * b) Amazon S3
   * c) Amazon Lambda
   * d) Amazon SNS

5. Quelle stratégie permet de maintenir un `pipeline Jenkins` propre et rapide en production ?

   * a) Garder tous les logs pendant 2 ans
   * b) Déclencher le build manuellement à chaque fois
   * c) Utiliser des agents temporaires avec nettoyage post-exécution
   * d) Éviter les tests pour gagner du temps

6. Quelle ressource n'est pas déployable directement via AWS CloudFormation ?

   * a) Un bucket S3
   * b) Un repository GitHub
   * c) Un rôle IAM
   * d) Une instance EC2

7. Quelle commande permet de forker un dépôt Git distant ?

   * a) `git fork`
   * b) `git remote fork <url>`
   * c) Cela se fait uniquement depuis l’interface (ex : GitHub, GitLab)
   * d) `git copy --remote`

8. Lequel de ces services AWS est considéré comme **serverless** ?

   * a) Amazon EC2
   * b) Amazon RDS
   * c) AWS Lambda
   * d) Amazon EBS



## Partie 2 – Réponses ouvertes

9. Quelle est la différence entre les trois niveaux suivants dans Jenkins :

   * **stage**
   * **steps**
   * **agent**
     Expliquez clairement leur rôle dans un pipeline déclaratif.



10. Quelle est la différence entre **CodeCommit** et **GitHub** dans un environnement DevOps AWS ? Dans quel cas préféreriez-vous l’un ou l’autre ? Justifiez.



11. Pourquoi est-il recommandé d’archiver certains fichiers dans Jenkins après chaque exécution ?
    Donnez deux cas d’usage concrets.



12. Complétez le pipeline suivant en YAML en ajoutant l'étape manquante pour exécuter `python main.py` dans un environnement avec `requirements.txt`.

```groovy
pipeline {
  agent any

  stages {
    stage('Install') {
      steps {
        sh 'pip install -r requirements.txt'
      }
    }

    stage('Run') {
      steps {
        // compléter ici
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: '**/*.csv', allowEmptyArchive: true
      }
    }
  }
}
```



13. Vous devez améliorer le pipeline Jenkins suivant pour qu’il soit robuste, modulaire et adapté à un environnement d’exécution isolé.

> Objectifs :
>
> * Utiliser un **environnement virtuel Python** (via `venv`)
> * Gérer les erreurs lors de l’exécution du script (`main.py`) avec un code de retour
> * Nettoyer l’environnement à la fin du pipeline (suppression du dossier `venv`)
> * Archiver tous les fichiers `.csv` générés
>
> Complétez les étapes manquantes dans le pipeline ci-dessous :

```groovy
pipeline {
  agent any

  environment {
    VENV_DIR = 'venv'
  }

  stages {
    stage('Prepare') {
      steps {
        // Créer l'environnement virtuel
        sh 'python3 -m venv $VENV_DIR'
      }
    }

    stage('Install') {
      steps {
        // Activer venv et installer les dépendances
        sh '''
          . $VENV_DIR/bin/activate
          pip install --upgrade pip
          pip install -r requirements.txt
        '''
      }
    }

    stage('Run') {
      steps {
        // Complétez ici : exécuter main.py et gérer les erreurs
      }
    }

    stage('Archive') {
      steps {
        archiveArtifacts artifacts: '**/*.csv', allowEmptyArchive: false
      }
    }
  }

  post {
    always {
      // Complétez ici : nettoyage de l’environnement virtuel
    }
    failure {
      echo 'Le pipeline a échoué. Consultez les logs.'
    }
  }
}
```



### Contraintes 

* L’étape **Run** doit :

  * Activer l’environnement virtuel
  * Exécuter `main.py`
  * Interrompre le pipeline manuellement si `main.py` échoue (`exit 1` si code de retour ≠ 0)
* Le bloc `post > always` doit :

  * Supprimer complètement le dossier `venv/`
  * S’assurer que la suppression ne provoque pas d’échec du pipeline (utiliser `|| true`)








## Partie 3 – Extraction, transformation et publication automatisées d'offres d’emploi



## Contexte

Vous faites partie d’une cellule technologique chargée d’automatiser la veille sur les offres d’emploi dans le domaine du développement logiciel. L’objectif est de construire un pipeline complet qui récupère des offres depuis plusieurs sources, génère un rapport HTML lisible et déploie automatiquement ce rapport via Jenkins sur un espace public.



## Objectifs 

* Automatiser une chaîne complète de traitement de données (scraping → transformation → publication)
* Appliquer les pratiques d’intégration et de déploiement continu (CI/CD)
* Utiliser Jenkins pour coordonner les étapes de traitement
* Générer un résultat concret et déployé en production



## Fichiers fournis

* `scraper.py` : script Python complet pour extraire des offres depuis plusieurs sites (HackerNews, Python.org, Remotive, JSRemotely, etc.)
* `requirements.txt` : dépendances Python à installer
* Accès Jenkins préconfiguré avec un agent disponible


```
import requests
from bs4 import BeautifulSoup
import pandas as pd

headers = {
    "User-Agent": (
        "Mozilla/5.0 (Windows NT 10.0; Win64; x64) "
        "AppleWebKit/537.36 (KHTML, like Gecko) "
        "Chrome/114.0.0.0 Safari/537.36"
    )
}


def scrape_hackernews():
    url = "https://news.ycombinator.com/jobs"
    offers = []
    try:
        res = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(res.text, "lxml")
        for row in soup.find_all("tr", class_="athing"):
            a = row.find("a")
            if a and "item?id=" in a.get("href", ""):
                offers.append({
                    "Source": "HackerNews",
                    "Titre": a.text.strip(),
                    "Entreprise": "N/A",
                    "Lien": "https://news.ycombinator.com/" + a["href"]
                })
    except Exception as e:
        print("Erreur HackerNews:", e)
    return offers


def scrape_python_jobs():
    url = "https://www.python.org/jobs/"
    offers = []
    try:
        res = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(res.text, "lxml")
        for job in soup.select(".list-recent-jobs li"):
            title = job.h2.text.strip()
            company = job.find("span", class_="listing-company-name").text.strip()
            link = "https://www.python.org" + job.h2.a["href"]
            offers.append({
                "Source": "Python.org",
                "Titre": title,
                "Entreprise": company,
                "Lien": link
            })
    except Exception as e:
        print("Erreur Python.org:", e)
    return offers


def scrape_jsremotely():
    url = "https://jsremotely.com/"
    offers = []
    try:
        res = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(res.text, "lxml")
        for div in soup.find_all("div", class_="job"):
            a = div.find("a")
            if a:
                title = a.text.strip()
                link = "https://jsremotely.com" + a["href"]
                offers.append({
                    "Source": "JSRemotely",
                    "Titre": title,
                    "Entreprise": "N/A",
                    "Lien": link
                })
    except Exception as e:
        print("Erreur JSRemotely:", e)
    return offers


def scrape_remotive():
    url = "https://remotive.io/api/remote-jobs?category=software-dev"
    offers = []
    try:
        res = requests.get(url, headers=headers, timeout=10)
        jobs = res.json()["jobs"]
        for job in jobs:
            offers.append({
                "Source": "Remotive",
                "Titre": job["title"],
                "Entreprise": job["company_name"],
                "Lien": job["url"]
            })
    except Exception as e:
        print("Erreur Remotive:", e)
    return offers


def scrape_workingnomads():
    url = "https://www.workingnomads.com/jobs"
    offers = []
    try:
        res = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(res.text, "lxml")
        for li in soup.select("div#jobsboard > a"):
            title = li.find("h3")
            company = li.find("h4")
            if title and company:
                offers.append({
                    "Source": "WorkingNomads",
                    "Titre": title.text.strip(),
                    "Entreprise": company.text.strip(),
                    "Lien": "https://www.workingnomads.com" + li["href"]
                })
    except Exception as e:
        print("Erreur WorkingNomads:", e)
    return offers


def scrape_authenticjobs():
    url = "https://authenticjobs.com/"
    offers = []
    try:
        res = requests.get(url, headers=headers, timeout=10)
        soup = BeautifulSoup(res.text, "lxml")
        for job in soup.select(".job-listing"):
            title_tag = job.find("h4")
            company_tag = job.find("h5")
            a_tag = job.find("a", href=True)
            if title_tag and a_tag:
                offers.append({
                    "Source": "AuthenticJobs",
                    "Titre": title_tag.text.strip(),
                    "Entreprise": company_tag.text.strip() if company_tag else "N/A",
                    "Lien": "https://authenticjobs.com" + a_tag["href"]
                })
    except Exception as e:
        print("Erreur AuthenticJobs:", e)
    return offers


def main():
    print("Scraping multi-sources en cours...\n")

    all_offers = []
    all_offers += scrape_hackernews()
    all_offers += scrape_python_jobs()
    all_offers += scrape_jsremotely()
    all_offers += scrape_remotive()
    all_offers += scrape_workingnomads()
    all_offers += scrape_authenticjobs()

    df = pd.DataFrame(all_offers)
    df.to_csv("jobs.csv", index=False, encoding="utf-8")

    print(f"\nFichier jobs.csv généré avec {len(df)} offres d'emploi.")
    if not df.empty:
        display(df.head(10))


main()
```


#### `requirements.txt`

```
requests
beautifulsoup4
lxml
pandas
```


## Arborescence cible du projet

```
projet-offres/
├── Jenkinsfile
├── scraper.py
├── html_generator.py         # À créer
├── requirements.txt
├── data/
│   └── jobs.csv              # Généré automatiquement
├── public/
│   └── index.html            # Généré automatiquement
└── README.md
```



## Étapes obligatoires

### 1. Étape de préparation (Install)

* Installer toutes les dépendances Python nécessaires via `pip install -r requirements.txt`
* S'assurer que Python et `pip` sont bien accessibles depuis Jenkins

### 2. Étape de scraping (Scraping)

* Exécuter `scraper.py` depuis Jenkins
* Générer automatiquement le fichier `jobs.csv` dans un répertoire `data/`

### 3. Étape de transformation (Conversion)

* Créer un script Python `html_generator.py` permettant de transformer le contenu de `jobs.csv` en un fichier HTML lisible (table, mise en page basique, liens cliquables)
* Générer le fichier dans `public/index.html`

### 4. Étape de test (Qualité)

* Ajouter des vérifications dans Jenkins pour s’assurer que :

  * `jobs.csv` contient au moins 10 offres
  * `index.html` contient bien des offres visibles
  * Aucun fichier n’est vide ou invalide

### 5. Étape d’archivage

* Archiver `jobs.csv` et `index.html` comme artefacts Jenkins
* Permettre leur consultation après chaque exécution du pipeline

### 6. Étape de déploiement

Vous devez déployer le fichier `index.html` généré vers un des environnements suivants :

* **Option A** : Déploiement vers un serveur NGINX local (ex : `/var/www/html`)
* **Option B** : Déploiement vers un bucket S3 public configuré en mode site statique
* **Option C** : Déploiement via GitHub Pages
* **Option D** : Déploiement automatique sur un VPS via `scp`

**Justifiez votre choix dans le `README.md`.**

### 7. Déclenchement automatique du pipeline (Trigger)

Le pipeline Jenkins doit se déclencher automatiquement lorsqu’un nouveau commit est poussé dans le dépôt Git contenant le projet. Vous pouvez aussi déclencher le pipeline si les offres d’emploi changent (modification du fichier `jobs.csv`).



## Livrables obligatoires

* `Jenkinsfile` complet, fonctionnel et commenté
* `html_generator.py` avec transformation correcte vers un tableau HTML
* `jobs.csv` généré automatiquement
* `index.html` généré automatiquement
* `README.md` expliquant :

  * Le fonctionnement global
  * La structure du pipeline
  * Les choix techniques
  * Le mécanisme de déclenchement
* Captures d’écran de Jenkins montrant :

  * Le pipeline en exécution
  * Les artefacts générés
  * Le déploiement réussi



## Bonus (+3 points maximum)

Implémentez un système de détection automatique de changement : si les offres n’ont **pas changé** depuis la dernière exécution, le pipeline **s’arrête prématurément** et ne génère pas de nouveaux fichiers.

Exemples :

* Comparaison des hash du fichier `jobs.csv`
* Sauvegarde du fichier précédent (`jobs_previous.csv`) et `diff` automatique
* Utilisation d’un système de version dans Git pour vérifier les changements








