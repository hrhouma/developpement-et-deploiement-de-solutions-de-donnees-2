## 📝 Partie 8/15 – 🚀 Partie pratique formative à faire individuellement – Déclencher un Pipeline Jenkins avec GitHub

### 🎯 Objectif
Automatiser l'exécution d'un script "Hello World" en configurant un pipeline Jenkins qui se déclenche à chaque fois qu'une modification est effectuée sur le fichier **README.md** et poussée sur GitHub.

### 📋 Prérequis
- Un compte **GitHub**.
- Un serveur **Jenkins** avec le plugin **GitHub** installé et configuré.
- Des connaissances de base en **Git**.

---

## 🔧 Partie 1 : Préparation du Dépôt GitHub

### 🡺 Étape 1.1 : Créer un Nouveau Dépôt GitHub
1. Connectez-vous à **GitHub** et créez un nouveau dépôt nommé `jenkins-hello-world`.
2. Clonez le dépôt sur votre machine locale pour y ajouter des fichiers.

### 🡺 Étape 1.2 : Ajouter un Script "Hello World"
- **Pour Python** : Créez un fichier nommé **hello.py** avec le contenu suivant :
  ```python
  print("Hello, World from Jenkins Pipeline!")
  ```
- **Pour Java** : Créez un fichier nommé **HelloWorld.java** avec le contenu suivant :
  ```java
  public class HelloWorld {
      public static void main(String[] args) {
          System.out.println("Hello, World from Jenkins Pipeline!");
      }
  }
  ```
- **Ajouter un fichier README.md** : Écrivez une brève description de votre projet dans le fichier README.md.

### 🡺 Étape 1.3 : Pousser les Modifications
- Utilisez **Git** pour ajouter, commettre et pousser les fichiers `hello.py` ou `HelloWorld.java`, et `README.md` sur votre dépôt GitHub.

---

## 🛠️ Partie 2 : Configuration du Pipeline Jenkins

### 🡺 Étape 2.1 : Créer un Nouveau Job Pipeline dans Jenkins
1. Dans Jenkins, allez dans **Nouveau Job**.
2. Nommez votre job, par exemple, `HelloWorldPipeline`.
3. Sélectionnez **Pipeline** et créez le job.

### 🡺 Étape 2.2 : Configurer le Pipeline pour Utiliser Votre Dépôt GitHub
1. Dans la configuration du job Jenkins, allez dans la section **Pipeline**.
2. Choisissez **Pipeline script from SCM** comme source du pipeline.
3. Sélectionnez **Git** comme SCM et entrez l'URL de votre dépôt GitHub.
4. Spécifiez la branche à utiliser (par exemple, `main`).
5. Dans le champ **Script Path**, entrez `Jenkinsfile` (nom du fichier Jenkinsfile que vous allez créer).

### 🡺 Étape 2.3 : Créer un Jenkinsfile dans Votre Dépôt
1. Dans votre dépôt GitHub, créez un fichier nommé **Jenkinsfile** avec le contenu suivant :
   ```groovy
   pipeline {
       agent any
       stages {
           stage('Build') {
               steps {
                   script {
                       // Utilisez la commande en fonction de votre script
                       sh 'python hello.py' // Pour Python
                       // sh 'javac HelloWorld.java && java HelloWorld' // Pour Java
                   }
               }
           }
       }
   }
   ```
2. Poussez le fichier **Jenkinsfile** dans votre dépôt GitHub.

### 🡺 Étape 2.4 : Configurer le Pipeline pour Utiliser Votre Dépôt GitHub avec Vérification Périodique
1. Dans la configuration du job Jenkins, dans la section **Pipeline**, assurez-vous que **Pipeline script from SCM** est sélectionné avec l'URL de votre dépôt.
2. Allez dans la section **Build Triggers** et sélectionnez **Poll SCM**.
3. Dans le champ de programmation, entrez une syntaxe cron pour la vérification périodique (ex. : `H/5 * * * *` pour vérifier toutes les cinq minutes).

---

## 🔄 Partie 3 : Testez Votre Configuration

1. Modifiez le fichier **README.md** dans votre dépôt GitHub, puis **commettez** et **poussez** la modification.
2. Cette modification devrait **déclencher automatiquement votre pipeline Jenkins**.
3. Vérifiez que le pipeline s'exécute correctement et que le message `"Hello, World from Jenkins Pipeline!"` s'affiche dans la console de sortie Jenkins.

---

## 🎁 BONUS : Configurer un Webhook GitHub pour Déclencher le Pipeline

Au lieu de la vérification périodique, vous pouvez configurer un **webhook** GitHub pour que le pipeline soit déclenché à chaque **push**.

1. Dans votre dépôt GitHub, allez dans **Settings** > **Webhooks**.
2. Ajoutez un nouveau webhook avec l'URL de votre serveur Jenkins suivi de `/github-webhook/` (ex. : `http://your-jenkins-server/github-webhook/`).
3. Choisissez **Just the push event** et activez le webhook.

---

## 📄 Livrable : Rapport de l'exercice "Déclencher un Pipeline Jenkins avec GitHub"

Soumettez un rapport incluant les éléments suivants, avec des **captures d'écran** comme preuves :

1. **Dépôt GitHub** : Montrez les fichiers `hello.py`/`HelloWorld.java`, `README.md`, et `Jenkinsfile`.
2. **Configuration Jenkins** : Capture de la configuration du pipeline Jenkins avec **Pipeline script from SCM** et l'URL du dépôt.
3. **Vérification SCM** : (Si applicable) Capture de la configuration cron dans **Build Triggers**.
4. **Pipeline en Action** : Capture de l'exécution du pipeline après modification du `README.md`.
5. **Résultat du Pipeline** : Capture de la sortie console Jenkins affichant le message `"Hello, World from Jenkins Pipeline!"`.
6. **Webhook GitHub** (Optionnel) : Capture de la configuration du webhook.

### 📝 Consignes
- Organisez et décrivez chaque capture d’écran brièvement.
- Assurez la lisibilité des captures d’écran.
- Soumettez le rapport en **PDF** ou **Word**.

Bonne chance et amusez-vous bien en configurant votre premier pipeline Jenkins déclenché par GitHub ! 🚀
