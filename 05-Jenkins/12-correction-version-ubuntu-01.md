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

----

# Annexe 3 - Explication de `PATH = "${env.PATH}:/usr/bin/python3"`

Cette ligne fait partie de la configuration d'environnement dans un **Jenkinsfile**, spécifiquement utilisée pour s'assurer que Jenkins peut exécuter le programme Python dans l'environnement correct. Décomposons cette instruction pour mieux comprendre :

---

#### **1. Le Contexte : La Variable d'Environnement `PATH`**

- `PATH` est une **variable d'environnement système** utilisée par votre système d'exploitation pour localiser les exécutables.
- Quand vous exécutez une commande comme `python3` ou `java`, votre système recherche ces programmes dans les répertoires listés dans `PATH`.

---

#### **2. Que Fait `PATH = "${env.PATH}:/usr/bin/python3"` ?**

1. **`${env.PATH}`**  
   - Cette syntaxe indique la valeur actuelle de la variable d'environnement `PATH`.  
   - Exemple de valeur actuelle de `PATH` sur Ubuntu :
     ```
     /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
     ```
   - Jenkins utilise cette valeur pour accéder aux programmes et outils nécessaires.

2. **`:/usr/bin/python3`**  
   - `:/usr/bin/python3` ajoute un répertoire supplémentaire à la variable `PATH`.
   - Dans ce cas, on ajoute explicitement le chemin où **Python 3** est installé sur la plupart des distributions Linux.

3. **Combinaison**
   - En combinant `${env.PATH}` et `:/usr/bin/python3`, on s'assure que les répertoires déjà présents dans le `PATH` restent accessibles, tout en ajoutant le chemin spécifique à **Python 3**.

4. **Pourquoi Cette Ligne est-elle Nécessaire ?**
   - Dans certains cas, Jenkins peut ne pas utiliser le même environnement système que votre terminal. Cela peut poser des problèmes si le chemin de Python 3 (`/usr/bin/python3`) n'est pas déjà dans le `PATH` utilisé par Jenkins.
   - En ajoutant explicitement ce chemin, on garantit que Jenkins pourra trouver et exécuter Python 3.

---

#### **3. Exemple Avant et Après**

##### **Avant Ajout :**
- Valeur de `PATH` :
  ```
  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
  ```
- Si Jenkins ne trouve pas Python 3 dans l'un de ces répertoires, il renvoie une erreur du type :
  ```
  python3: command not found
  ```

##### **Après Ajout :**
- Valeur de `PATH` :
  ```
  /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/bin/python3
  ```
- Jenkins peut désormais exécuter Python 3 correctement.

---

#### **4. Pourquoi Utiliser `${env.PATH}` ?**

- `${env.PATH}` permet de **préserver les chemins existants** dans `PATH`. Si on ne l’utilisait pas et remplaçait `PATH` uniquement par `/usr/bin/python3`, Jenkins perdrait l'accès à tous les autres outils (comme `git`, `javac`, etc.).

---

#### **5. Où Se Trouve `/usr/bin/python3` ?**

- Sur Ubuntu (ou d'autres distributions Linux), **`/usr/bin/python3`** est l'emplacement par défaut de l'exécutable Python 3.
- Vous pouvez confirmer cet emplacement avec la commande :
  ```bash
  which python3
  ```
  Résultat attendu :
  ```
  /usr/bin/python3
  ```

---

### **Résumé**

- `PATH = "${env.PATH}:/usr/bin/python3"` garantit que Python 3 est accessible pour Jenkins en ajoutant son chemin au `PATH`.
- Cela évite les erreurs "command not found" lorsque Jenkins exécute un script Python.
- `${env.PATH}` assure que les autres outils restent accessibles en maintenant les chemins existants dans `PATH`.






---

### **Bon Travail !** 🎉

