# **Conseils de déboguage** 🎯  

## **Déclencher un Pipeline Jenkins avec GitHub**  
L’objectif est d’apprendre à automatiser l’exécution d’un script simple (*Hello World*) à chaque modification d’un fichier dans un dépôt GitHub, en utilisant Jenkins et GitHub. Vous allez également configurer les environnements pour Python ou Java en fonction de votre système, en appliquant des pratiques professionnelles. 

---

# **Prérequis et Méthodes Professionnelles à Suivre** 🛠️  

Avant de commencer, voici quelques étapes et conseils pour assurer une configuration robuste et fonctionnelle :  

1. **Vérifiez la présence des exécutables nécessaires :**  
   - Sur **Linux/macOS**, utilisez :  
     ```bash
     which python3
     which java
     ```
   - Sur **Windows (dans PowerShell)** :  
     ```powershell
     Get-Command python
     Get-Command java
     ```
   - **Résultat attendu :** Le chemin vers l’exécutable correspondant (par exemple `/usr/bin/python3` ou `C:\Program Files\Java\jdk-11\bin\java`).  
   - **Si rien n’apparaît :** L’outil n’est pas installé ou le chemin n’est pas configuré correctement. Consultez la section sur les variables d’environnement ci-dessous.  

2. **Soyez flexible avec vos exécutables :**  
   - Les configurations peuvent varier d’une machine à une autre :  
     - Par exemple, Python peut être `python` ou `python3`. Testez les deux pour identifier celui qui fonctionne.  
     - Même chose pour Java : vérifiez avec `java -version` et adaptez votre script Jenkinsfile si besoin.  

3. **Utilisez des alternatives d’exécution en cas de problème :**  
   - Si Jenkins ne trouve pas votre exécutable directement, vous pouvez spécifier le chemin complet dans le `Jenkinsfile` :  
     ```groovy
     sh '/usr/bin/python3 hello.py'
     ```
     ou  
     ```groovy
     sh '/usr/lib/jvm/java-11-openjdk-amd64/bin/java HelloWorld'
     ```

4. **Adaptez selon l’environnement où vous travaillez :**  
   - **Local (Linux/Windows/MacOS)** : Configurez vos variables d’environnement pour que Jenkins reconnaisse vos outils.  
   - **Cloud Jenkins (Jenkins sur AWS, Azure, etc.) :** Utilisez des conteneurs Docker ou des agents préconfigurés pour éviter les problèmes de compatibilité.  
     - Exemple : Un agent Docker avec Python préinstallé :  
       ```groovy
       agent {
           docker {
               image 'python:3.9'
           }
       }
       ```

5. **Prévoyez des erreurs et validez votre environnement :**  
   - **Test rapide des commandes avant de les intégrer à Jenkins** :  
     ```bash
     python3 hello.py  # Pour Python
     javac HelloWorld.java && java HelloWorld  # Pour Java
     ```
   - **Conseil avancé :** Surveillez les logs de Jenkins si le pipeline échoue. Les erreurs y sont souvent explicites.  

---

# **Étape 1 : Préparer le Dépôt GitHub** 🐙  

1. **Créer un nouveau dépôt GitHub.**  
2. **Cloner et créer les fichiers :**  
   - Python :  
     ```python
     print("Hello, World from Jenkins Pipeline!")
     ```
   - Java :  
     ```java
     public class HelloWorld {
         public static void main(String[] args) {
             System.out.println("Hello, World from Jenkins Pipeline!");
         }
     }
     ```

3. **Poussez vos fichiers dans GitHub.**

---

# **Étape 2 : Configurer Jenkins et les Variables d’Environnement**  

#### **Configurer les Variables d’Environnement Locales :**  

1. **Linux/macOS :**  
   - Ajoutez à votre fichier `~/.bashrc` ou `~/.zshrc` :  
     ```bash
     export PATH=$PATH:/usr/bin/python3
     export JAVA_HOME=/usr/lib/jvm/java-11-openjdk-amd64
     export PATH=$PATH:$JAVA_HOME/bin
     ```
   - Rechargez :  
     ```bash
     source ~/.bashrc
     ```

2. **Windows :**  
   - Allez dans **Panneau de configuration > Système > Paramètres avancés > Variables d’environnement.**  
   - Ajoutez ou modifiez la variable `Path` pour inclure :  
     - Le chemin vers Python (par exemple : `C:\Python39`).  
     - Le dossier `bin` du JDK Java (par exemple : `C:\Program Files\Java\jdk-11\bin`).  

3. **Validez vos variables :**  
   - Testez :  
     ```bash
     python --version
     java -version
     ```

---

# **Étape 3 : Ajouter un Fichier Jenkinsfile**  

1. **Créer le fichier `Jenkinsfile`.**  
   - Python :  
     ```groovy
     pipeline {
         agent any
         stages {
             stage('Run Script') {
                 steps {
                     sh 'python3 hello.py' // Ou ajustez : 'python hello.py'
                 }
             }
         }
     }
     ```
   - Java :  
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

2. **Si une commande échoue dans Jenkins :**  
   - Vérifiez le chemin complet des exécutables. Exemple :  
     ```groovy
     sh '/usr/bin/python3 hello.py'
     ```

---

# **Étape 4 : Adaptez selon l’Environnement (Conseils Avancés)**  

1. **Agents Jenkins dans des environnements spécifiques :**  
   - **Local :** Configurez vos outils comme mentionné plus haut.  
   - **Docker :** Utilisez un conteneur avec l’outil préinstallé :  
     ```groovy
     pipeline {
         agent {
             docker {
                 image 'python:3.9'
             }
         }
         stages {
             stage('Run Script') {
                 steps {
                     sh 'python hello.py'
                 }
             }
         }
     }
     ```

2. **Serveurs Jenkins sur le Cloud :**  
   - Configurez un agent personnalisé avec les outils nécessaires ou demandez à votre administrateur Jenkins.  

3. **En cas de problèmes persistants :**  
   - Testez les commandes directement sur le serveur Jenkins.  
   - Si une commande fonctionne localement mais échoue dans Jenkins, cela peut être dû à des permissions ou à un chemin incorrect. Vérifiez les journaux Jenkins pour diagnostiquer.  

---

# **Étape 5 : Testez et Vérifiez le Pipeline**  

1. **Test local des scripts avant de les exécuter dans Jenkins.**  
2. **Configurez un webhook ou une vérification périodique pour déclencher Jenkins.**  

---

# **Annexe : Résumé des Conseils**  

1. **Variables d’Environnement :** Configurez pour que Python et Java soient accessibles depuis Jenkins.  
2. **Exécution manuelle :** Testez vos scripts localement avant de les intégrer dans Jenkins.  
3. **Alternatives d’exécution :** Si vous travaillez dans le cloud ou avec Docker, utilisez des agents avec l’environnement déjà configuré.  
4. **Logs :** Utilisez les journaux de Jenkins pour comprendre les échecs.  

