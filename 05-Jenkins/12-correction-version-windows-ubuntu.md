### **Étape 1 : Créer votre dépôt GitHub**

**Fichiers nécessaires :**
1. **HelloWorld.java**  
2. **hello.py**  
3. **Jenkinsfile** (sans extension)

📂 **Remarque** : Assurez-vous que ces fichiers sont bien dans le dépôt GitHub. Leur contenu est disponible dans **l'annexe 1**.

---

### **Étape 2 : Configurer la pipeline Jenkins**

#### **Instructions détaillées :**
1️⃣ **Créer une nouvelle pipeline :**
   - Accédez à Jenkins et cliquez sur **New Item**.  
   - Saisissez un nom, sélectionnez **Pipeline**, et cliquez sur **OK**.

2️⃣ **Activer Poll SCM :**
   - Cette option permet de surveiller automatiquement les changements dans votre dépôt GitHub.

3️⃣ **Configurer le script de pipeline :**
   - Allez dans **Pipeline > Definition** et sélectionnez **Pipeline Script from SCM**.

4️⃣ **Sélectionner GIT comme SCM :**
   - Dans la section SCM, choisissez **GIT**.

5️⃣ **Indiquer l'URL du dépôt GitHub :**
   - Exemple : `https://github.com/hrhouma/hello-python.git`.

6️⃣ ⚠️ **Ajouter des credentials :**
   - Accédez à **Jenkins > Add > Username with password** et configurez :  
     - Nom d'utilisateur : **Votre identifiant GitHub**  
     - Mot de passe : **Un token personnel GitHub**  

7️⃣ **Sélectionner vos credentials :**
   - Vérifiez que vos credentials sont bien sélectionnés. Cela est souvent oublié.

8️⃣ **Branch Specifier :**
   - Modifiez `/*master` en `/*main` si votre branche par défaut est **main**.

9️⃣ **Enregistrer les modifications :**
   - Cliquez sur **Apply**, puis sur **Save**.

---

### **Étape 3 : Configurer Git dans Jenkins**

1️⃣ **Gérer les outils Git :**
   - Depuis le tableau de bord, accédez à **Manage Jenkins > Tools > Git installations**.

2️⃣ **Configurer l'emplacement de Git :**
   - **Linux :** `/usr/bin/git`.  
   - **Windows :** `C:\Program Files\Git\cmd\git.exe`.  

3️⃣ **Vérifier l'emplacement de Git :**
   - **Linux :** Utilisez `which git` dans le terminal.  
   - **Windows :** Exécutez dans le terminal :
     ```cmd
     for %i in (git.exe) do @echo. %~$PATH:i
     ```

4️⃣ **Enregistrer vos modifications :**
   - Cliquez sur **Apply**, puis sur **Save**.

---

### **Étape 4 : Conseils pour le Jenkinsfile**

1️⃣ **Syntaxe correcte pour les commandes Git :**
   - **Évitez :**
     ```groovy
     git clone ...
     ```
   - **Utilisez plutôt :**
     ```groovy
     git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
     ```

2️⃣ **Ne pas définir de variables globales dans Jenkins :**
   - Gérez toutes les variables d’environnement directement dans le **Jenkinsfile**.

---

### **Annexe 1 : Contenu des fichiers**

#### **1. Jenkinsfile**
```groovy
pipeline {
    agent any
    environment {
        PATH = "${env.PATH}:/usr/bin/python3" // Linux : Inclure Python 3 dans le PATH
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
                        // Linux-specific commands
                    } else {
                        bat 'echo "Running on Windows"'
                        // Windows-specific commands
                    }
                }
            }
        }
    }
}
```

#### **2. hello.py**
```python
print("Hello, World from Jenkins Pipeline!")
```

#### **3. HelloWorld.java**
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World from Jenkins Pipeline!");
    }
}
```

---

### **Annexe 2 : Exécutions spécifiques**

#### **Pipeline pour Windows uniquement**
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
                    bat 'javac HelloWorld.java'
                    bat 'java HelloWorld'
                    bat 'python hello.py'
                }
            }
        }
    }
}
```

#### **Pipeline pour Linux uniquement**
```groovy
pipeline {
    agent any
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-8-openjdk-amd64'
        PATH = "${env.PATH}:${JAVA_HOME}/bin:/usr/bin"
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
                    sh 'javac HelloWorld.java'
                    sh 'java HelloWorld'
                    sh 'python3 hello.py'
                }
            }
        }
    }
}
```

---

### **Annexe 3 : Commandes d'installation et vérification**

#### **Linux (Ubuntu 22.04)**
- Installer Java :
  ```bash
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk
  ```
- Vérifier les chemins :
  ```bash
  which java    # Résultat : /usr/bin/java
  which javac   # Résultat : /usr/bin/javac
  which python3 # Résultat : /usr/bin/python3
  ```

#### **Windows**
- Vérifier les chemins :
  ```cmd
  for %i in (java.exe) do @echo. %~$PATH:i
  for %i in (python.exe) do @echo. %~$PATH:i
  ```

---

### Références utiles
- [Problème Jenkins et Git](https://stackoverflow.com/questions/8639501/jenkins-could-not-run-git)  
- [Exécution de scripts Python depuis Jenkins](https://stackoverflow.com/questions/56291513/execute-a-python-script-that-is-on-my-git-via-jenkins)  
- [Configuration avancée Git](https://stackoverflow.com/questions/76136556/jenkins-how-to-execute-git-clone-for-the-second-git-repo-outside-the-main-r)  

🎉 **Bonne chance pour votre pipeline Jenkins !** 🚀
