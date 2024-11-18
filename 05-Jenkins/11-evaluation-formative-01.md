# **Évaluation formative** 🎯  

# **Déclencher un Pipeline Jenkins avec GitHub**  
L’objectif de cet exercice est d’apprendre à utiliser Jenkins et GitHub pour automatiser l'exécution d'un script simple (*Hello World*) à chaque modification d’un fichier dans un dépôt GitHub. Cet exercice suit un processus étape par étape et ne demande aucune connaissance préalable de Jenkins ou GitHub.

---

# **Qu’est-ce qu’on va faire ?**  
1. **Créer un dépôt GitHub** : Héberger le code de votre projet.  
2. **Écrire un script simple ("Hello World")** : Script en Python ou Java.  
3. **Configurer Jenkins** : Configurer un "Pipeline" (automatisation) qui exécute le script dès qu’un fichier est modifié sur GitHub.  
4. **Tester le tout** : Vérifier que le pipeline fonctionne correctement.  

---

### **Prérequis** 🛠️  
Avant de commencer, assurez-vous de disposer de :  
1. **Un compte GitHub** : Si vous n’en avez pas, créez-en un [ici](https://github.com/).  
2. **Un serveur Jenkins installé et accessible** : Si ce n’est pas le cas, demandez à votre formateur ou utilisez un service Jenkins en ligne.  
3. **Connaissances de base de Git** : Vous devez savoir cloner un dépôt, ajouter des fichiers, les committer et les pousser.  

---

# **Étape 1 : Préparer le Dépôt GitHub** 🐙  

1. **Créer un nouveau dépôt GitHub**  
   - Connectez-vous à votre compte GitHub.  
   - Cliquez sur le bouton **"New"** (Nouveau dépôt).  
   - Donnez un nom à votre dépôt, par exemple **`jenkins-hello-world`**.  
   - Sélectionnez **"Public"** ou **"Private"** selon votre choix.  
   - Cliquez sur **"Create Repository"** pour valider.  

2. **Cloner ce dépôt sur votre machine**  
   - Copiez l’URL du dépôt (elle se trouve en haut de la page, sous le bouton vert **Code**).  
   - Dans votre terminal, entrez la commande suivante :  
     ```bash
     git clone <URL_DE_VOTRE_DEPOT>
     cd jenkins-hello-world
     ```

3. **Créer un fichier "Hello World"**  
   - Si vous utilisez **Python** :  
     - Créez un fichier `hello.py` avec le contenu suivant :  
       ```python
       print("Hello, World from Jenkins Pipeline!")
       ```  
   - Si vous utilisez **Java** :  
     - Créez un fichier `HelloWorld.java` avec le contenu suivant :  
       ```java
       public class HelloWorld {
           public static void main(String[] args) {
               System.out.println("Hello, World from Jenkins Pipeline!");
           }
       }
       ```  

4. **Ajouter un fichier README.md**  
   - Créez un fichier `README.md` (c'est un fichier texte qui décrit votre projet).  
   - Ajoutez-y une simple description, comme :  
     ```
     Ce projet contient un script "Hello World" pour démontrer un pipeline Jenkins.
     ```

5. **Poussez vos fichiers sur GitHub**  
   - Ajoutez tous vos fichiers avec Git :  
     ```bash
     git add .  
     git commit -m "Initial commit avec script Hello World"  
     git push origin main  
     ```  

---

# **Étape 2 : Configurer Jenkins** 🛠️  

1. **Accéder à Jenkins**  
   - Ouvrez votre navigateur et connectez-vous à Jenkins (par exemple : `http://localhost:8080` ou l’URL fournie par votre formateur).  

2. **Créer un Nouveau Job Jenkins**  
   - Cliquez sur **"New Item"** (ou **"Nouveau Job"**).  
   - Donnez un nom à votre job (par exemple : **`HelloWorldPipeline`**).  
   - Sélectionnez **"Pipeline"** et cliquez sur **"OK"**.  

3. **Configurer le job Jenkins**  
   - Allez dans la section **Pipeline** :  
     - **Pipeline script from SCM** : Cela signifie que Jenkins va lire les instructions à partir de votre dépôt GitHub.  
     - Sélectionnez **Git** comme système de gestion de code.  
     - Dans le champ **Repository URL**, collez l’URL de votre dépôt GitHub (par exemple : `https://github.com/votrecompte/jenkins-hello-world.git`).  
     - Spécifiez la branche : **`main`** (ou `master`, selon votre dépôt).  
     - Dans le champ **Script Path**, entrez : **`Jenkinsfile`** (on va créer ce fichier ensuite).  

---

# **Étape 3 : Ajouter un Fichier Jenkinsfile**  

1. **Créer un fichier nommé `Jenkinsfile`** à la racine de votre projet (dans votre dépôt GitHub local).  
   - Contenu pour **Python** :  
     ```groovy
     pipeline {
         agent any
         stages {
             stage('Run Script') {
                 steps {
                     sh 'python hello.py'
                 }
             }
         }
     }
     ```  
   - Contenu pour **Java** :  
     ```groovy
     pipeline {
         agent any
         stages {
             stage('Run Script') {
                 steps {
                     sh 'javac HelloWorld.java && java HelloWorld'
                 }
             }
         }
     }
     ```  

2. **Poussez ce fichier dans votre dépôt GitHub** :  
   ```bash
   git add Jenkinsfile  
   git commit -m "Ajout du fichier Jenkinsfile"  
   git push origin main  
   ```  

---

# **Étape 4 : Configurer un Déclencheur Automatique**  

1. **Vérification Périodique (CRON)**  
   - Dans Jenkins, retournez dans la configuration de votre job.  
   - Activez **"Poll SCM"** dans la section **Build Triggers**.  
   - Ajoutez une syntaxe CRON :  
     - Exemple : **`H/5 * * * *`** : Vérifie toutes les 5 minutes si le dépôt a changé.  

2. **(Optionnel) Webhook GitHub**  
   - Sur GitHub : Allez dans **Settings** > **Webhooks** > **Add Webhook**.  
   - Ajoutez l’URL de Jenkins suivie de `/github-webhook/` (par exemple : `http://votre-serveur-jenkins/github-webhook/`).  
   - Choisissez **"Just the push event"** pour déclencher Jenkins à chaque *push*.  

---

# **Étape 5 : Tester le Pipeline**  

1. **Modifier le fichier `README.md` sur GitHub** : Ajoutez une ligne (par exemple : "Modification pour test Jenkins").  
2. **Vérifiez Jenkins** : Le pipeline doit démarrer automatiquement.  
3. **Résultat attendu dans Jenkins** :  
   - Jenkins exécute le script et affiche :  
     ```
     Hello, World from Jenkins Pipeline!
     ```  

---

## **Livrable attendu**  

1. 🐙 **Capture du dépôt GitHub** : Affichez vos fichiers (`hello.py`, `Jenkinsfile`, etc.).  
2. 🛠️ **Configuration Jenkins** : Capture de l’interface Jenkins avec votre job configuré.  
3. 🔄 **Pipeline en action** : Capture montrant le pipeline en cours d'exécution.  
4. ✅ **Résultat dans la console Jenkins** : Capture de la sortie montrant "Hello, World".  

---

## **Annexe : Notions clés**  

1. **Qu’est-ce qu’un Pipeline Jenkins ?**  
   C’est un processus automatisé qui permet de compiler, tester et exécuter du code automatiquement.  

2. **SCM (Source Code Management)**  
   Outil pour gérer et versionner le code source. Ici, Git est utilisé comme SCM.  

3. **Planification CRON**  
   Syntaxe utilisée pour planifier des tâches répétitives dans Jenkins :  
   - **`H/5 * * * *`** : Exécute toutes les 5 minutes.  
   - **`H 12 * * 1-5`** : Exécute tous les jours à 12h, du lundi au vendredi.  

Bonne chance ! 🍀 
