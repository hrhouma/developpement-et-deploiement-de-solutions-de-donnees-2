## 🛠️ Partie 6/15 - Installations


-------------
###### *MÉTHODE 1 - 💻 Installation sur Windows : Java 17 et Maven 3.9.0*
-------------

### 🌟 Étape 1 : Installation de Java 17

1. **Téléchargez Java 17** :
   - Rendez-vous sur [Oracle](https://www.oracle.com/java/technologies/javase-jdk17-downloads.html) ou [OpenJDK](https://jdk.java.net/17/).
   - Téléchargez la version Windows x64.

2. **Installez Java 17** :
   - Ouvrez le fichier `.exe` téléchargé et suivez les instructions.
   - Notez le chemin d'installation (ex. : `C:\Program Files\Java\jdk-17`).

3. **Configurez `JAVA_HOME`** :
   - Dans **Paramètres système avancés**, ajoutez une variable d'environnement `JAVA_HOME` avec le chemin de Java.

4. **Ajoutez Java au `Path`** :
   - Ajoutez `%JAVA_HOME%\bin` au `Path`.

5. **Vérifiez l'installation** :
   - Tapez `java -version` dans **cmd**.

---

### 🛠️ Étape 2 : Installation de Maven 3.9.0

1. **Téléchargez Maven 3.9.0** :
   - Téléchargez le fichier `apache-maven-3.9.0-bin.zip` sur le site d'[Apache Maven](https://maven.apache.org/download.cgi).

2. **Extrayez l'archive** :
   - Extrayez dans `C:\Program Files\Apache\maven-3.9.0`.

3. **Configurez `MAVEN_HOME`** :
   - Ajoutez une variable système `MAVEN_HOME` avec le chemin Maven.

4. **Ajoutez Maven au `Path`** :
   - Ajoutez `%MAVEN_HOME%\bin` au `Path`.

5. **Vérifiez l'installation** :
   - Tapez `mvn -version` dans **cmd**.


### 🛠️ Étape 3 : Installation de Jenkins sur windows

## Commandes pour libérer le port 8080

   ```bash
   netstat -noa |findstr :8080
   taskkill /F /PID 8864 (LE PID)
   ```






---------------
######  *MÉTHODE 2 - 🐧 Installation sur Linux (Ubuntu 22.04) : Java 17, Maven 3.9.0, et Jenkins*
-------------


### 🖥️ Étape 1 : Préparation de la VM Ubuntu

1. **Créez une VM Ubuntu 22.04**.
2. **Installez SSH** pour un accès facile :
   ```bash
   sudo apt update
   sudo apt install openssh-server -y
   ```
3. **Configurez le réseau en mode "bridge"** pour une IP locale :
   ```bash
   ip a
   ssh eleve@IP_ADDRESS
   ```

### ☕ Étape 2 : Installation de Java 17

```bash
sudo apt install fontconfig openjdk-17-jre -y
java -version
```

### 🛠️ Étape 3 : Installation de Maven

1. **Installez Maven** :
   ```bash
   sudo apt install maven -y
   ```
2. **Vérifiez l'installation** :
   ```bash
   mvn -version
   ```

### 🤖 Étape 4 : Installation de Jenkins

1. **Ajoutez la clé Jenkins** :
   ```bash
   sudo wget -O /usr/share/keyrings/jenkins-keyring.asc https://pkg.jenkins.io/debian-stable/jenkins.io-2023.key
   ```

2. **Ajoutez Jenkins aux sources** :
   ```bash
   echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] https://pkg.jenkins.io/debian-stable binary/ | sudo tee /etc/apt/sources.list.d/jenkins.list > /dev/null
   ```
3. **Installez Jenkins** :
   ```bash
   sudo apt update
   sudo apt install jenkins -y
   ```

4. **Configurez l'accès** :
   - **Démarrez Jenkins** et **autorisez le port 8080** :
   ```bash
   sudo systemctl enable jenkins
   sudo ufw allow 8080/tcp
   sudo ufw reload
   ```
5. **Récupérez le mot de passe initial** :
   ```bash
   sudo cat /var/lib/jenkins/secrets/initialAdminPassword
   ```















---------------
######  *MÉTHODE 3 - 🐳 Installation avec Docker : Java, Maven, et Jenkins*
-------------

### 🚀 Étape 1 : Installation de Docker




1. **Téléchargez et installez Docker** :

   ```bash
   su
   sudo apt update
   git clone https://github.com/hrhouma/install-docker.git
   cd install-docker/
   chmod +x install-docker.sh
   ./install-docker.sh
   #ou sh install-docker.sh
   ```
   
2. **Vérifiez l'installation de Docker** :
   ```bash
   docker --version
   ```

### Important : 

- Installer les outils essentiels et Git sur Ubuntu 22.04

```bash
sudo apt update && sudo apt install -y build-essential git curl wget vim unzip
```

Cette commande va installer :

- **build-essential** : Contient les outils de développement essentiels (comme `gcc`, `make`).
- **git** : Le gestionnaire de versions Git.
- **curl** : Un utilitaire pour transférer des données depuis ou vers un serveur.
- **wget** : Un autre utilitaire pour récupérer des fichiers via HTTP, HTTPS, et FTP.
- **vim** : Un éditeur de texte avancé.
- **unzip** : Pour extraire les fichiers `.zip`.


### ☕ Étape 2 : Lancer un conteneur avec Java et Maven

1. **Lancez un conteneur Ubuntu avec Java et Maven** :
   ```bash
   docker run -it --name jdk_maven_container ubuntu
   apt update
   apt install openjdk-17-jdk maven -y
   java -version
   mvn -version
   ```

### 🤖 Étape 3 : Lancer un conteneur Jenkins

1. **Téléchargez l'image Jenkins** :
   ```bash
   docker pull jenkins/jenkins:lts
   ```

2. **Lancez le conteneur Jenkins** :
   ```bash
   docker run -d -p 8080:8080 -v jenkins_home:/var/jenkins_home --name my_jenkins jenkins/jenkins:lts
   ```

3. **Accédez à Jenkins** :
   - Ouvrez `http://localhost:8080` dans votre navigateur et utilisez le mot de passe initial disponible avec :
   ```bash
   docker logs my_jenkins
   ```

---

## 📊 Comparatif des Méthodes d'Installation

*Cette table vous aidera à choisir l’installation la plus adaptée à vos besoins. Que vous soyez sur **Windows**, **Linux**, ou que vous préfériez utiliser des conteneurs avec **Docker**, vous avez maintenant toutes les informations pour configurer Java, Maven et Jenkins !*

| Critère                  | **Windows**                  | **Linux (Ubuntu 22.04)**         | **Docker**                   |
|--------------------------|------------------------------|----------------------------------|------------------------------|
| **Facilité d'installation** | Moyen                      | Facile                           | Facile                       |
| **Utilisation des ressources** | Moyen               | Léger                            | Léger                        |
| **Portabilité**          | Faible                       | Moyenne                          | Élevée                       |
| **Mises à jour**         | Manuelle                     | Semi-automatique                 | Automatique avec nouvelle image |
| **Flexibilité**          | Moyenne                      | Élevée                           | Élevée                       |
| **Temps d’installation** | Moyen                        | Rapide                           | Rapide                       |

