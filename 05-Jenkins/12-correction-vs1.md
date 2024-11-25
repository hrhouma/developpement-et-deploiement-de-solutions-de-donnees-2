# 🚀 Guide Complet pour Configurer une Pipeline Jenkins avec GitHub 🎉

### **1️⃣ Étape : Créer le Dépôt GitHub**  
Créez un dépôt GitHub contenant les fichiers suivants :  
📄 **HelloWorld.java**  
📄 **hello.py**  
📄 **Jenkinsfile** *(sans extension)*  

Le contenu des fichiers est fourni dans **l'Annexe 1**.  

---

### **2️⃣ Configuration de la Pipeline Jenkins** 🛠️

#### **Étapes détaillées :**  
1️⃣ **Créer une nouvelle pipeline :**  
   - Donnez un nom à votre pipeline, sélectionnez **Pipeline**, et cliquez sur **OK**.

2️⃣ **Activer Poll SCM :**  
   - Cela permet de surveiller les changements dans le dépôt GitHub.

3️⃣ **Choisir "Pipeline Script from SCM" :**  
   - Sélectionnez **GIT** comme SCM.

4️⃣ **Configurer l'URL du dépôt :**  
   - Exemple : `https://github.com/hrhouma/hello-python.git`.

5️⃣ ⚠️ **Configuration des credentials :**  
   - Accédez à **Jenkins > Add > Username with password**.  
     Utilisez votre nom d’utilisateur GitHub et un **token personnel** comme mot de passe.

6️⃣ **Sélectionnez vos credentials :**  
   - Assurez-vous de sélectionner les credentials créés.

7️⃣ **Spécifiez la branche :**  
   - Remplacez `/*master` par `/*main` si votre branche par défaut est **main**.

8️⃣ **Sauvegardez vos modifications :**  
   - Cliquez sur **Apply**, puis **Save**.

---

### **3️⃣ Configurer Git dans Jenkins** 🖥️  

1️⃣ **Depuis le Dashboard Jenkins :**  
   - Allez dans **Manage Jenkins > Tools > Git installations**.

2️⃣ **Configurer l’emplacement de Git :**  
   - Sous Linux : `/usr/bin/git`.  
   - Sous Windows : `C:\Program Files\Git\cmd\git.exe`.

3️⃣ **Vérifiez l’emplacement de Git :**  
   - Commande Linux : `which git`.  
   - Commande Windows :  
     ```cmd
     for %i in (git.exe) do @echo. %~$PATH:i
     ```

4️⃣ **Appliquer et Sauvegarder.**

---

### **4️⃣ ⚡ Points Importants pour le Jenkinsfile**  

1️⃣ **Évitez les commandes directes comme :**  
   ```groovy
   git clone ...
   ```  
   👉 Utilisez cette syntaxe dans votre Jenkinsfile :  
   ```groovy
   git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
   ```

2️⃣ **Gestion des variables d’environnement :**  
   - Configurez les variables dans le Jenkinsfile (voir l'Annexe 1).

---

### **Annexe 1 📄 : Contenu des Fichiers**

#### **Jenkinsfile : Exemple Générique**  
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
                    } else {
                        bat 'echo "Running on Windows"'
                    }
                }
            }
        }
    }
}
```

#### **hello.py : Script Python**  
```python
print("Hello, World from Jenkins Pipeline!")
```

#### **HelloWorld.java : Script Java**  
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World from Jenkins Pipeline!");
    }
}
```

---

### **Annexe 2 🖥️ : Exécution sur Windows et Linux**

#### **Pipeline pour Windows et Linux (Version 2-en-1)**  
```groovy
pipeline {
    agent any
    environment {
        JAVA_HOME = isUnix() ? '/usr/lib/jvm/java-8-openjdk-amd64' : 'C:\\Program Files\\Java\\jdk1.8.0_202'
        PATH = isUnix() ? "${env.PATH}:${JAVA_HOME}/bin:/usr/bin" : "${env.PATH};${JAVA_HOME}\\bin;C:\\Users\\rehou\\AppData\\Local\\Microsoft\\WindowsApps"
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
                        sh 'javac HelloWorld.java'
                        sh 'java HelloWorld'
                        sh 'python3 hello.py'
                    } else {
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

---

### **Annexe 3 📦 : Installation de Java et Python**

#### **Sur Linux (Ubuntu 22.04)**  
- **Installer Java :**  
  ```bash
  sudo apt-get update
  sudo apt-get install openjdk-8-jdk
  ```
- **Vérifier les emplacements :**  
  ```bash
  which java    # /usr/bin/java
  which javac   # /usr/bin/javac
  which python3 # /usr/bin/python3
  ```

#### **Sur Windows**  
- **Vérifier les emplacements :**  
  ```cmd
  for %i in (java.exe) do @echo. %~$PATH:i
  for %i in (python.exe) do @echo. %~$PATH:i
  ```

---

🎉 **Bon travail et bonne configuration de Jenkins avec GitHub !** 🚀
