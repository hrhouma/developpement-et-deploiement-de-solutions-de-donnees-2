#  Jenkins, GitHub, Webhooks, Docker et Déploiement

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





-------------------------
-------------------------
-------------------------
-------------------------
# Annexe 01 - Résumé pour tester le webhook GitHub avec Jenkins
-------------------------

Pour continuer avec la configuration des webhooks entre GitHub et Jenkins, voici les étapes suivantes :

## Configurer le webhook GitHub

1. Allez dans les paramètres de votre dépôt GitHub
2. Cliquez sur "Webhooks" dans le menu de gauche
3. Cliquez sur "Add webhook"
4. Configurez le webhook comme suit :
   - Payload URL : `http://<adresse-jenkins>/github-webhook/`
   - Content type : application/json
   - Secret : laissez vide pour l'instant
   - Événements : sélectionnez "Just the push event"
5. Cliquez sur "Add webhook" pour sauvegarder

## Configurer Jenkins

1. Installez le plugin GitHub dans Jenkins si ce n'est pas déjà fait
2. Dans votre job Jenkins :
   - Allez dans la configuration
   - Dans la section "Build Triggers", cochez "GitHub hook trigger for GITScm polling"
3. Sauvegardez la configuration du job

## Tester le webhook

1. Faites un commit et un push sur votre dépôt GitHub
2. Vérifiez dans Jenkins que le build est déclenché automatiquement
3. Dans GitHub, vérifiez les "Recent Deliveries" du webhook pour vous assurer qu'il a bien été appelé

## Sécuriser le webhook (optionnel)

1. Générez un token API dans Jenkins :
   - Allez dans la configuration de l'utilisateur Jenkins
   - Cliquez sur "Add new token" dans la section API Token
   - Copiez le token généré
2. Mettez à jour le webhook GitHub :
   - Retournez dans les paramètres du webhook
   - Collez le token Jenkins dans le champ "Secret"
3. Sauvegardez les modifications

En suivant ces étapes, vous aurez une intégration fonctionnelle entre GitHub et Jenkins utilisant les webhooks pour déclencher automatiquement des builds à chaque push.

-------------------------
# Annexe 2 - Tester à nouveau le webhook GitHub avec Jenkins
-------------------------

- *Pour tester à nouveau le webhook GitHub avec Jenkins, suivez ces étapes :*

1. Déclenchez manuellement un événement sur GitHub :
   - Faites un petit changement dans votre dépôt (par exemple, modifiez un fichier README)
   - Committez et poussez ce changement

2. Vérifiez dans Jenkins :
   - Allez sur le dashboard de votre projet Jenkins
   - Regardez si un nouveau build a été automatiquement déclenché

3. Inspectez les logs Jenkins :
   - Si un build a été déclenché, ouvrez-le et examinez les logs de console
   - Cherchez des messages indiquant la réception du webhook

4. Vérifiez les livraisons récentes sur GitHub :
   - Dans votre dépôt GitHub, allez dans Settings > Webhooks
   - Cliquez sur votre webhook Jenkins
   - Scrollez jusqu'à "Recent Deliveries"
   - Vérifiez si la dernière livraison a réussi (code 200)

5. Redélivrez manuellement le webhook :
   - Toujours dans la section "Recent Deliveries" de GitHub
   - Trouvez une livraison précédente réussie
   - Cliquez sur "Redeliver" pour la renvoyer

6. Utilisez les outils de débogage Jenkins :
   - Allez dans Manage Jenkins > System Log
   - Configurez un nouveau logger pour "org.jenkinsci.plugins.github"
   - Définissez le niveau sur "FINE" ou "ALL"
   - Déclenchez à nouveau un événement et examinez ces logs détaillés

En suivant ces étapes, vous pourrez tester à nouveau votre webhook et identifier tout problème potentiel dans la communication entre GitHub et Jenkins.

