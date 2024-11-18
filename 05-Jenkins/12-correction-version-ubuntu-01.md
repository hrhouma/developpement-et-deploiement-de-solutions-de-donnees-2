### **Version Ubuntu : Instructions Détaillées**

---

# **Partie 1 : Création du Dépôt GitHub**
1. **Créer le Dépôt GitHub**
   - Accédez à [GitHub](https://github.com) et créez un nouveau dépôt nommé **`hello-python`**.
   - Téléversez les fichiers suivants dans le dépôt :
     - **HelloWorld.java**
     - **hello.py**
     - **Jenkinsfile** (sans extension).
   - Le contenu de ces fichiers est fourni dans **Annexe 1**.

2. **Cloner le Dépôt**
   - Depuis GitHub, copiez l’URL HTTPS de votre dépôt.
   - Clonez-le dans un répertoire local :
     ```bash
     git clone https://github.com/hrhouma/hello-python.git
     cd hello-python
     ```

---

# **Partie 2 : Configuration de la Pipeline Jenkins**

01. **Créer un Nouveau Job**
   - Allez sur Jenkins. Cliquez sur **New Item** (*Nouveau Job*).
   - Entrez un nom, choisissez le type **Pipeline**, puis cliquez sur **OK**.

02. **Activer le Déclencheur Poll SCM**
   - Dans **Build Triggers**, cochez **Poll SCM**.

03. **Configurer le Pipeline pour Utiliser le Script SCM**
   - Dans la section **Pipeline**, sélectionnez **Pipeline script from SCM**.

04. **Configurer le Gestionnaire de Code Source (SCM)**
   - Choisissez **Git** comme SCM.
   - Entrez l’URL du dépôt GitHub, par exemple :
     ```
     https://github.com/hrhouma/hello-python.git
     ```

05. **Ajouter vos Identifiants GitHub**
   - Cliquez sur **Add** > **Jenkins** > **Username with password**.
     - **Nom d’utilisateur** : `hrhouma`
     - **Mot de passe** : Le jeton personnel GitHub (*Token*).

06. **Sélectionner vos Identifiants**
   - Vérifiez que vos *credentials* sont bien sélectionnés dans le champ approprié.

07. **Configurer la Branche**
   - Dans **Branch Specifier**, remplacez **`*/master`** par **`*/main`** si votre branche est nommée `main`.

08. **Appliquer et Sauvegarder**
   - Cliquez sur **Apply**, puis **Save**.

---

# **Partie 3 : Configuration de Git dans Jenkins**

09. **Configurer le Chemin de l’Exécutable Git**
   - Allez dans **Manage Jenkins** > **Global Tool Configuration** > **Git installations**.
   - Ajoutez une nouvelle installation avec :
     - **Nom** : Default
     - **Path to Git executable** : `/usr/bin/git`.

10. **Vérification du Chemin Git**
    - Sur Ubuntu, utilisez :
      ```bash
      which git
      ```
      Cela retourne `/usr/bin/git`, le chemin correct pour Jenkins.

---

# **Partie 4 : Création et Modification du Jenkinsfile**

11. **Contenu du Jenkinsfile**
    - Le fichier Jenkinsfile (voir **Annexe 1**) utilise Groovy pour définir les étapes. Assurez-vous d'utiliser la syntaxe correcte :
      ```groovy
      git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
      ```
      **Important : Ne pas utiliser `git clone ...`.**

12. **Variables d’Environnement**
    - N'ajoutez pas de variables d’environnement dans **Global Properties** sous **Manage Jenkins**. Ces variables seront définies directement dans le Jenkinsfile.

---

# **Partie 5 : Tester la Pipeline**

13. **Exécuter le Job**
    - Retournez au tableau de bord Jenkins, sélectionnez votre pipeline, puis cliquez sur **Build Now**.

14. **Résultat Attendu**
    - Jenkins affiche dans la console :
      ```bash
      Running on Unix
      Hello, World from Jenkins Pipeline! (Java)
      Hello, World from Jenkins Pipeline! (Python)
      ```

---

# **Annexe 1 : Contenu des Fichiers**
#### **Jenkinsfile**
```groovy
pipeline {
    agent any
    environment {
        PATH = "${env.PATH}:/usr/bin/python3"
    }
    stages {
        stage('Checkout') {
            steps {
               git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
            }
        }
        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'echo "Running on Unix"'
                        sh 'javac HelloWorld.java'
                        sh 'java HelloWorld'
                        sh 'python3 hello.py'
                    } else {
                        bat 'echo "Running on Windows"'
                        bat 'javac HelloWorld.java'
                        bat 'java HelloWorld'
                        bat 'python hello.py'
                    }
                }
            }
        }
    }
}
```

#### **hello.py**
```python
print("Hello, World from Jenkins Pipeline!")
```

#### **HelloWorld.java**
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World from Jenkins Pipeline!");
    }
}
```

---

# **Annexe 2 : Commandes d’Installation pour Ubuntu**

- Installer Java :
  ```bash
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk
  ```
- Vérifier les chemins des exécutables :
  ```bash
  which java     # /usr/bin/java
  which javac    # /usr/bin/javac
  which python3  # /usr/bin/python3
  ```
- Ajouter les chemins des exécutables dans Jenkinsfile (variable PATH).

---

### **Bon Travail !** 🎉
