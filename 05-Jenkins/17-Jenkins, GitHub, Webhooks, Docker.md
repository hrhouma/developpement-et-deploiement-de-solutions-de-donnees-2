### ** Jenkins, GitHub, Webhooks, Docker et Déploiement**

Ce guide vous accompagne **pas à pas** pour :
1. **Créer un dépôt GitHub.**  
2. **Configurer un serveur Jenkins dans Docker.**  
3. **Configurer un webhook GitHub.**  
4. **Tester la configuration avec un vrai pipeline Jenkins.**

---

## **1️⃣ Préparer votre Environnement**

### **Matériel nécessaire :**
1. Un serveur avec **Ubuntu 22.04**.
2. Une connexion Internet stable.
3. Un compte **GitHub**.

---

## **2️⃣ Installation des Outils Requis**

### **Étape 1 : Installer Docker**
Docker permet de lancer Jenkins dans un conteneur.

#### 1. Mettre à jour votre serveur :
```bash
sudo apt update && sudo apt upgrade -y
```

#### 2. Installer Docker :
```bash
sudo apt install apt-transport-https ca-certificates curl software-properties-common -y
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install docker-ce docker-ce-cli containerd.io -y
```

#### 3. Vérifier que Docker est installé :
```bash
docker --version
```

---

### **Étape 2 : Installer Docker Compose**
Docker Compose permet de gérer plusieurs conteneurs Docker.

1. Télécharger et installer Docker Compose :
```bash
sudo curl -L "https://github.com/docker/compose/releases/download/2.20.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
docker-compose --version
```

---

## **3️⃣ Créer et Configurer un Dépôt GitHub**

### **Étape 1 : Créer un nouveau dépôt**
1. Connectez-vous à votre compte GitHub.
2. Cliquez sur **New Repository** (bouton vert).
3. Entrez les informations suivantes :
   - **Repository name :** `jenkins-pipeline-test`.
   - **Description :** `Dépôt pour tester une pipeline Jenkins avec Webhook`.
   - **Visibility :** Public ou Private (au choix).
4. Cliquez sur **Create Repository**.

---

### **Étape 2 : Ajouter des fichiers au dépôt**
1. Clonez le dépôt sur votre machine locale :
```bash
git clone https://github.com/<votre-utilisateur>/jenkins-pipeline-test.git
cd jenkins-pipeline-test
```

2. Ajoutez trois fichiers importants :
   - **`Jenkinsfile`**
   - **`HelloWorld.java`**
   - **`hello.py`**

3. Contenu des fichiers :

- **Jenkinsfile :**
```groovy
pipeline {
    agent {
        docker {
            image 'openjdk:11' // Utilise un conteneur Docker avec Java 11
        }
    }
    environment {
        PYTHON_HOME = '/usr/bin/python3' // Chemin de Python
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main',
                    credentialsId: 'github-token',
                    url: 'https://github.com/<votre-utilisateur>/jenkins-pipeline-test.git'
            }
        }
        stage('Build Java') {
            steps {
                sh 'javac HelloWorld.java'
                sh 'java HelloWorld'
            }
        }
        stage('Run Python') {
            steps {
                sh '${PYTHON_HOME} hello.py'
            }
        }
    }
}
```

- **HelloWorld.java :**
```java
public class HelloWorld {
    public static void main(String[] args) {
        System.out.println("Hello, World from Jenkins Pipeline!");
    }
}
```

- **hello.py :**
```python
print("Hello, World from Jenkins Pipeline!")
```

4. **Ajoutez et poussez les fichiers sur GitHub :**
```bash
git add .
git commit -m "Ajout des fichiers pour la pipeline Jenkins"
git push origin main
```

---

## **4️⃣ Configurer Jenkins dans Docker**

### **Étape 1 : Lancer Jenkins dans un conteneur**
```bash
docker network create jenkins
docker run -d \
  --name jenkins \
  --restart=unless-stopped \
  --network jenkins \
  -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  -v /var/run/docker.sock:/var/run/docker.sock \
  jenkins/jenkins:lts
```

### **Étape 2 : Configurer Jenkins**
1. Accédez à Jenkins : **http://<IP-DU-SERVEUR>:8080**.
2. Récupérez le mot de passe initial :
   ```bash
   docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
   ```
3. Suivez les étapes pour configurer Jenkins.

---

### **Étape 3 : Installer les plugins nécessaires**
Dans **Manage Jenkins > Manage Plugins**, installez :
- **Git Plugin**
- **GitHub Integration Plugin**
- **Pipeline Plugin**
- **Docker Pipeline Plugin**

---

### **Étape 4 : Ajouter des credentials GitHub**
1. Allez dans **Manage Jenkins > Credentials > Global Credentials**.
2. Cliquez sur **Add Credentials** :
   - **Kind :** Username with password.
   - **Username :** Votre nom d'utilisateur GitHub.
   - **Password :** Le **token GitHub** (créé dans **Settings > Developer Settings > Personal Access Tokens**).
   - **ID :** `github-token`.

---

## **5️⃣ Configurer un Webhook dans GitHub**

1. Allez dans **Settings > Webhooks** de votre dépôt GitHub.
2. Cliquez sur **Add Webhook**.
3. Entrez les informations suivantes :
   - **Payload URL :** `http://<IP-DU-SERVEUR>:8080/github-webhook/`
   - **Content Type :** `application/json`.
   - **Trigger Events :** Sélectionnez **Push events**.
4. Cliquez sur **Add Webhook**.

---

## **6️⃣ Tester la Configuration**

### **Étape 1 : Créer une pipeline dans Jenkins**
1. Allez dans **New Item > Multibranch Pipeline**.
2. Entrez le nom **GitHub-Pipeline-Test**.
3. Configurez la **Branch Sources** :
   - **Source :** GitHub.
   - **Repository URL :** `https://github.com/<votre-utilisateur>/jenkins-pipeline-test.git`.
   - **Credentials :** Sélectionnez `github-token`.
4. Cliquez sur **Save**.

---

### **Étape 2 : Lancer un Test**
1. Faites un **commit** dans votre dépôt GitHub :
```bash
echo "// Nouvelle ligne" >> HelloWorld.java
git add .
git commit -m "Test webhook"
git push origin main
```

2. Vérifiez que Jenkins démarre automatiquement une build grâce au webhook.

---

## **7️⃣ Dépannage des Problèmes Courants**

### **Problème 1 : Le Webhook ne déclenche pas la pipeline**
- Assurez-vous que le port 8080 est accessible :
  ```bash
  sudo ufw allow 8080
  ```
- Vérifiez l'URL du webhook dans GitHub :
  - Elle doit être `http://<IP-DU-SERVEUR>:8080/github-webhook/`.

### **Problème 2 : Clonage Git échoue dans Jenkins**
- Vérifiez les credentials GitHub :
  - Assurez-vous que le token GitHub a les permissions **repo**.
- Assurez-vous que l'URL du dépôt est correcte :
  - Elle doit commencer par `https://`.

### **Problème 3 : Erreur "Python introuvable"**
- Vérifiez que Python est installé dans le conteneur Jenkins :
  ```bash
  docker exec jenkins which python3
  ```
- Si Python manque, installez-le :
  ```bash
  docker exec jenkins apt-get update
  docker exec jenkins apt-get install python3 -y
  ```
