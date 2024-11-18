### **Instructions pour Windows : Configuration Complète**

---

# **Partie 1 : Création du Dépôt GitHub**

1. **Créer un Dépôt sur GitHub**  
   - Accédez à [GitHub](https://github.com) et créez un dépôt nommé **`hello-python`**.
   - Téléversez les fichiers suivants :
     - **HelloWorld.java**
     - **hello.py**
     - **Jenkinsfile** (sans extension).
   - **Le contenu des fichiers se trouve dans Annexe 1**.

2. **Cloner le Dépôt**  
   - Copiez l’URL HTTPS du dépôt et exécutez la commande suivante dans le terminal :
     ```bash
     git clone https://github.com/hrhouma/hello-python.git
     cd hello-python
     ```

---

# **Partie 2 : Configuration de la Pipeline Jenkins**

01. **Créer une Nouvelle Pipeline**
   - Accédez à Jenkins, cliquez sur **New Item** (*Nouveau Job*).
   - Donnez un nom (exemple : **HelloWorldPipeline**), sélectionnez le type **Pipeline**, puis cliquez sur **OK**.

02. **Activer Poll SCM**
   - Allez dans la section **Build Triggers** et cochez **Poll SCM**.

03. **Choisir "Pipeline Script from SCM"**
   - Dans la section **Pipeline**, sélectionnez **Pipeline script from SCM**.

04. **Configurer SCM (Source Code Management)**  
   - Dans SCM, choisissez **Git**.  
   - Indiquez l’URL de votre dépôt, par exemple :
     ```bash
     https://github.com/hrhouma/hello-python.git
     ```

05. **Ajouter vos Identifiants GitHub**
   - Cliquez sur **Add** > **Jenkins** > **Username with password**.
     - **Nom d’utilisateur** : `hrhouma`
     - **Mot de passe** : Votre jeton GitHub (*Token*).

06. **Sélectionner les Credentials**
   - Assurez-vous que les credentials que vous venez d’ajouter sont bien sélectionnés.

07. **Configurer la Branche**
   - Dans **Branch Specifier**, remplacez **`*/master`** par **`*/main`** si votre branche GitHub est `main`.

08. **Appliquer et Sauvegarder**
   - Cliquez sur **Apply**, puis **Save**.

---

# **Partie 3 : Configurer Git sur Windows dans Jenkins**

09. **Configurer le Chemin de l’Exécutable Git**  
   - Retournez dans **Manage Jenkins** > **Global Tool Configuration** > **Git installations**.
   - Ajoutez une nouvelle installation avec :
     - **Name** : Default
     - **Path to Git executable** :  
       ```bash
       C:\Program Files\Git\cmd\git.exe
       ```
   - Pour trouver l’exécutable Git sur Windows, exécutez la commande suivante dans votre terminal :  
     ```cmd
     for %i in (git.exe) do @echo. %~$PATH:i
     ```

10. **Appliquer et Sauvegarder**
    - Cliquez sur **Apply**, puis **Save**.

---

# **Partie 4 : Configuration du Jenkinsfile pour Windows**

11. **Mettre à Jour le Jenkinsfile**  
   - Assurez-vous que votre `Jenkinsfile` respecte le contenu suivant, qui configure les variables d’environnement pour Windows :

   ```groovy
   pipeline {
       agent any
       environment {
           JAVA_HOME = 'C:\\Program Files\\Java\\jdk1.8.0_202'
           PYTHON_HOME = 'C:\\Users\\rehou\\AppData\\Local\\Microsoft\\WindowsApps'
           PATH = "${env.PATH};${JAVA_HOME}\\bin;${PYTHON_HOME}"
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

12. **Ne Pas Utiliser les Variables Globales Jenkins**
   - Dans Jenkins > **Manage Jenkins > Global Properties**, laissez les variables d’environnement désactivées.  
   - Toutes les variables nécessaires sont configurées directement dans le `Jenkinsfile`.

---

# **Partie 5 : Tester la Pipeline**

13. **Exécuter la Pipeline**
   - Retournez sur votre pipeline dans Jenkins et cliquez sur **Build Now**.

14. **Vérifier les Résultats**
   - Sur Windows, le pipeline doit afficher dans la console :
     ```bash
     Running on Windows
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
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk1.8.0_202'
        PYTHON_HOME = 'C:\\Users\\rehou\\AppData\\Local\\Microsoft\\WindowsApps'
        PATH = "${env.PATH};${JAVA_HOME}\\bin;${PYTHON_HOME}"
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

# **Annexe 2 : Détection des Chemins Java et Python sous Windows**

Pour détecter les chemins de Java ou Python sur votre machine Windows, utilisez les commandes suivantes dans le terminal :

- Pour Java :
  ```cmd
  for %i in (java.exe) do @echo. %~$PATH:i
  ```
- Pour Python :
  ```cmd
  for %i in (python.exe) do @echo. %~$PATH:i
  ```
- Résultats typiques :
  - **Java** : `C:\Program Files\Java\jdk1.8.0_202\bin\java.exe`
  - **Python** : `C:\Users\rehou\AppData\Local\Microsoft\WindowsApps\python.exe`

---

# **Références**

1. [Configurer Git sur Jenkins](https://stackoverflow.com/questions/8639501/jenkins-could-not-run-git)
2. [Pipeline Jenkins avec Python](https://stackoverflow.com/questions/56291513/execute-a-python-script-that-is-on-my-git-via-jenkins)
3. [Exemple de Jenkinsfile avec Git](https://stackoverflow.com/questions/3454424/unix-which-java-equivalent-command-on-windows)

**Bon Travail !** 🎉
