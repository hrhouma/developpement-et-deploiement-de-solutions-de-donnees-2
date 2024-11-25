#  Déclencher un Pipeline Jenkins avec GitHub

### Objectif
Automatiser l'exécution d'un script "Hello World" à l'aide d'un pipeline Jenkins qui se déclenche à chaque fois que le fichier `README.md` est modifié et poussé sur GitHub.

---

## Prérequis

- Un compte GitHub.
- Un serveur Jenkins avec le plugin GitHub installé et configuré.
- Connaissances de base en Git.

---

## Instructions Détaillées

### Partie 1 : Préparation du Dépôt GitHub

#### 1. Créer un Nouveau Dépôt GitHub
- Connectez-vous à GitHub et créez un nouveau dépôt nommé `jenkins-hello-world`.
- Clonez le dépôt sur votre machine locale.

#### 2. Ajouter un Script "Hello World"
- **Pour Python** : Créez un fichier `hello.py` avec le contenu suivant :
  ```python
  print("Hello, World from Jenkins Pipeline!")
  ```
- **Pour Java** : Créez un fichier `HelloWorld.java` avec le contenu suivant :
  ```java
  public class HelloWorld {
      public static void main(String[] args) {
          System.out.println("Hello, World from Jenkins Pipeline!");
      }
  }
  ```
- Ajoutez un fichier `README.md` avec une description simple de votre projet.

#### 3. Poussez vos Modifications
- Utilisez Git pour ajouter, commettre et pousser vos fichiers sur GitHub :
  ```bash
  git add .
  git commit -m "Initial commit with Hello World script and README"
  git push origin main
  ```

---

### Partie 2 : Configuration du Pipeline Jenkins

#### 1. Créer un Nouveau Job Pipeline dans Jenkins
- Dans Jenkins, sélectionnez **"Nouveau Job"**.
- Nommez votre job (par exemple, `HelloWorldPipeline`), sélectionnez **"Pipeline"** et créez-le.

#### 2. Configurer le Pipeline pour Utiliser Votre Dépôt GitHub
- Dans la configuration du job, dans la section **"Pipeline"**, choisissez **"Pipeline script from SCM"**.
- Sélectionnez **"Git"** comme SCM.
- Entrez l'URL de votre dépôt GitHub et spécifiez la branche (par exemple, `main`).
- Dans le champ **"Script Path"**, entrez le nom de votre `Jenkinsfile`.

#### 3. Créer un Jenkinsfile dans Votre Dépôt
- Créez un fichier nommé `Jenkinsfile` à la racine de votre dépôt avec le contenu suivant :
  ```groovy
  pipeline {
      agent any
      stages {
          stage('Build') {
              steps {
                  script {
                      // Choisissez la commande en fonction de votre script
                      sh 'python hello.py' // Pour Python
                      // sh 'javac HelloWorld.java && java HelloWorld' // Pour Java
                  }
              }
          }
      }
  }
  ```
- Poussez le `Jenkinsfile` dans votre dépôt GitHub :
  ```bash
  git add Jenkinsfile
  git commit -m "Add Jenkinsfile for pipeline"
  git push origin main
  ```

#### 4. Configurer le Pipeline pour Utiliser Votre Dépôt GitHub avec Vérification Périodique
- Dans la configuration du job, dans la section **"Pipeline"**, choisissez **"Pipeline script from SCM"**.
- Sélectionnez **"Git"** comme SCM.
- Entrez l'URL de votre dépôt GitHub et spécifiez la branche (par exemple, `main`).
- Dans le champ **"Script Path"**, entrez le nom de votre `Jenkinsfile`.
- **Activer la vérification périodique** :
  - Allez dans la section **"Build Triggers"** de la configuration du job et sélectionnez **"Poll SCM"**.
  - Entrez une programmation selon la syntaxe cron, par exemple :
    ```
    H/5 * * * *
    ```
    (Vérifie le dépôt toutes les 5 minutes).

---

### Partie 3 : Tester Votre Configuration

1. Modifiez le fichier `README.md` dans votre dépôt GitHub, puis commettez et poussez la modification :
   ```bash
   echo "Modification pour déclencher le pipeline." >> README.md
   git add README.md
   git commit -m "Update README to trigger Jenkins pipeline"
   git push origin main
   ```

2. Vérifiez que le pipeline est déclenché automatiquement dans Jenkins.

3. Confirmez que le message "Hello, World from Jenkins Pipeline!" apparaît dans la console de sortie Jenkins.

---

## BONUS : Configurer un Webhook GitHub pour Déclencher le Pipeline

1. Dans votre dépôt GitHub, allez dans **"Settings" > "Webhooks"** et ajoutez un nouveau webhook.
2. L'URL du webhook sera celle de votre serveur Jenkins suivie de `/github-webhook/`, par exemple :
   ```
   http://your-jenkins-server/github-webhook/
   ```
3. Sélectionnez **"Just the push event"** et activez le webhook.

---

## Livrable

Soumettez un rapport contenant les éléments suivants :

1. **Dépôt GitHub** : Capture du dépôt montrant `hello.py`/`HelloWorld.java`, `README.md`, et `Jenkinsfile`.
2. **Configuration Jenkins** : Capture de la configuration du pipeline Jenkins, montrant **"Pipeline script from SCM"** avec l'URL du dépôt et le chemin du `Jenkinsfile`.
3. **Vérification SCM** : Capture de la programmation cron dans **"Build Triggers"** (si applicable).
4. **Pipeline en Action** : Capture du pipeline Jenkins en cours d'exécution après une modification du `README.md`.
5. **Résultat du Pipeline** : Capture de la sortie de la console Jenkins montrant l'exécution réussie du script.
6. **Webhook GitHub** (Optionnel) : Capture de la configuration du webhook.

---

## Consignes

- Soyez clair et organisé.
- Chaque capture doit être brièvement décrite.
- Assurez-vous de la lisibilité des captures.
- Soumettez en format PDF ou Word.
```
