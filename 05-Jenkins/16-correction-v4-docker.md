### **Tutoriel: Installation et Configuration de Jenkins avec Docker, Java, et Python sur Ubuntu 22.04**


# **1️⃣ Préparer le Serveur Ubuntu 22.04**

### **Étape 1 : Mettre à jour le système**
**Pourquoi ?** Cela garantit que tous les paquets installés sont à jour et compatibles entre eux.  
**Commande :**
```bash
sudo apt update && sudo apt upgrade -y
```
- **sudo :** Exécute les commandes en tant qu’administrateur.  
- **apt update :** Met à jour les informations des paquets disponibles.  
- **apt upgrade :** Installe les nouvelles versions des paquets déjà installés.  
- **-y :** Accepte automatiquement les confirmations pour gagner du temps.

---

# **2️⃣ Installer Docker et Docker Compose**

### **Étape 1 : Installer Docker**
**Docker est une plateforme qui permet d'exécuter des applications dans des conteneurs isolés.**

#### 1. Installer les dépendances nécessaires :
**Pourquoi ?** Ces paquets garantissent que Docker peut être téléchargé et installé sans erreurs.  
```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
```
- **apt-transport-https :** Permet de télécharger via HTTPS.  
- **ca-certificates :** Ajoute des certificats de confiance pour la communication sécurisée.  
- **curl :** Utilisé pour télécharger des fichiers depuis le web.  
- **software-properties-common :** Permet d’ajouter des dépôts supplémentaires.

#### 2. Ajouter la clé GPG de Docker :
**Pourquoi ?** Cela garantit que les paquets téléchargés proviennent d’une source officielle et sécurisée.  
```bash
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
```
- **curl -fsSL :** Télécharge un fichier de manière silencieuse.  
- **gpg :** Gestionnaire de clés pour vérifier la signature des paquets Docker.

#### 3. Ajouter le dépôt officiel de Docker :
**Pourquoi ?** Pour que le gestionnaire de paquets puisse télécharger Docker directement depuis ses serveurs officiels.  
```bash
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```
- **dpkg --print-architecture :** Vérifie si votre système est en `amd64` ou `arm64`.  
- **lsb_release -cs :** Retourne la version de votre distribution Ubuntu, ex. `jammy` pour Ubuntu 22.04.

#### 4. Installer Docker :
```bash
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
```
- **docker-ce :** Version communautaire de Docker (gratuite).  
- **containerd.io :** Composant pour gérer les conteneurs.

#### 5. Vérifier l’installation :
```bash
docker --version
```
- **docker --version :** Vérifie que Docker est bien installé et affiche sa version.

---

### **Étape 2 : Installer Docker Compose**
**Pourquoi ?** Docker Compose permet de gérer des configurations complexes de plusieurs conteneurs.  
#### 1. Télécharger Docker Compose :
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
```
- **curl -L :** Télécharge le fichier à l'URL spécifiée.  
- **uname -s :** Retourne le système d'exploitation (`Linux`).  
- **uname -m :** Retourne l’architecture (`x86_64`).

#### 2. Ajouter les permissions d'exécution :
```bash
sudo chmod +x /usr/local/bin/docker-compose
```
- **chmod +x :** Rend le fichier exécutable.

#### 3. Vérifier l'installation :
```bash
docker-compose --version
```
- **docker-compose --version :** Vérifie que Docker Compose est installé et fonctionne correctement.

---

# **3️⃣ Installer Jenkins avec Docker**

### **Étape 1 : Créer un réseau Docker pour Jenkins**
**Pourquoi ?** Pour que Jenkins puisse communiquer avec d’autres conteneurs, comme ceux de vos projets.  
```bash
docker network create jenkins
```
- **docker network create :** Crée un réseau isolé pour Docker.

---

### **Étape 2 : Lancer Jenkins dans un conteneur Docker**
```bash
docker run -d \
  --name jenkins \
  --restart=unless-stopped \
  --network jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```
**Explications :**
- **-d :** Exécute Jenkins en arrière-plan.  
- **--name jenkins :** Nom du conteneur.  
- **--restart=unless-stopped :** Redémarre automatiquement Jenkins après un redémarrage du serveur.  
- **--network jenkins :** Connecte le conteneur au réseau Docker `jenkins`.  
- **-p 8080:8080 :** Mappe le port 8080 du serveur au conteneur Jenkins.  
- **-v jenkins_home:/var/jenkins_home :** Stocke les données Jenkins de manière persistante.  
- **-v /var/run/docker.sock:/var/run/docker.sock :** Permet à Jenkins de contrôler Docker.  
- **jenkins/jenkins:lts :** Image officielle de Jenkins en version stable (LTS).

---

### **Étape 3 : Accéder à Jenkins**
1. **Vérifiez que Jenkins est actif :**
   ```bash
   docker ps
   ```
   - **docker ps :** Liste les conteneurs en cours d'exécution.

2. **Accédez à Jenkins via un navigateur :**  
   `http://<IP-DU-SERVEUR>:8080`

---

### **Étape 4 : Configurer Jenkins**
1. **Récupérez le mot de passe initial :**
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
   - **docker exec :** Exécute une commande dans un conteneur.  
   - **cat :** Affiche le contenu du fichier contenant le mot de passe.

2. **Suivez l'interface web Jenkins pour terminer la configuration.**

---

# **4️⃣ Installer Git, Java et Python dans le conteneur Jenkins**

### **Étape 1 : Entrer dans le conteneur Jenkins**
```bash
docker exec -it jenkins bash
```
- **-it :** Ouvre une session interactive dans le conteneur.  

### **Étape 2 : Installer Git**
```bash
apt-get update
apt-get install git -y
git --version  # Vérifie la version
```

### **Étape 3 : Installer Java**
```bash
apt-get install openjdk-11-jdk -y
java --version  # Vérifie la version
which java      # Vérifie le chemin de Java
```

### **Étape 4 : Installer Python**
```bash
apt-get install python3 python3-pip -y
python3 --version  # Vérifie la version
which python3      # Vérifie le chemin de Python
```

---

# **5️⃣ Créer une Pipeline Jenkins**

### **Exemple Jenkinsfile**
Voici une pipeline qui utilise **Git**, **Java**, et **Python** :

```groovy
pipeline {
    agent {
        docker {
            image 'openjdk:11'  // Image Docker avec Java 11
        }
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/your-repo/your-project.git'
            }
        }
        stage('Build Java') {
            steps {
                sh 'javac HelloWorld.java'  // Compile le fichier Java
                sh 'java HelloWorld'       // Exécute le fichier Java
            }
        }
        stage('Run Python') {
            steps {
                sh 'python3 hello.py'      // Exécute le script Python
            }
        }
    }
}
```

---

# **6️⃣ Commandes Utiles pour Dépanner**

1. **Redémarrer Jenkins :**
   ```bash
   docker restart jenkins
   ```

2. **Vérifier les logs de Jenkins :**
   ```bash
   docker logs jenkins
   ```

3. **Entrer dans le conteneur Jenkins :**
   ```bash
   docker exec -it jenkins bash
   ```

