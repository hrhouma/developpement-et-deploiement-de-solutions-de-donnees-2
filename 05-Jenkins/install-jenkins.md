# Method 1

##  **Prerequisites**

1. Docker installed on your system

   * [Install Docker](https://docs.docker.com/get-docker/)
2. Optional: Docker Compose (for more complex setups)



##  **Step-by-Step Jenkins Installation with Docker**

### **Step 1: Pull the Jenkins LTS Docker image**

```bash
docker pull jenkins/jenkins:lts
```



### **Step 2: Create a Docker volume for Jenkins data**

```bash
docker volume create jenkins_home
```



### **Step 3: Run the Jenkins container**

```bash
docker run -d \
  --name jenkins \
  -p 8080:8080 \
  -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts
```

* `-p 8080:8080`: Exposes Jenkins UI on `http://localhost:8080`
* `-p 50000:50000`: For Jenkins agents
* `-v jenkins_home:/var/jenkins_home`: Persists Jenkins configuration and jobs



### **Step 4: Get the initial admin password**

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

Use this password to unlock Jenkins in your browser (`http://localhost:8080`).



##  (Optional) Docker Compose version

Create a file named `docker-compose.yml`:

```yaml
version: '3'
services:
  jenkins:
    image: jenkins/jenkins:lts
    ports:
      - "8080:8080"
      - "50000:50000"
    volumes:
      - jenkins_home:/var/jenkins_home

volumes:
  jenkins_home:
```

Then run:

```bash
docker-compose up -d
```



##  To Stop and Remove Jenkins Container

```bash
docker stop jenkins
docker rm jenkins
```


# Method 2




```bash
docker run -d --name jenkins -p 8080:8080 -p 50000:50000 -v jenkins_home:/var/jenkins_home jenkins/jenkins:lts
```


###  Détail de la commande :

* `-d` : mode détaché (en arrière-plan)
* `--name jenkins` : nom du conteneur
* `-p 8080:8080` : port web Jenkins
* `-p 50000:50000` : port pour les agents (build nodes)
* `-v jenkins_home:/var/jenkins_home` : volume pour stocker les données de Jenkins
* `jenkins/jenkins:lts` : image Jenkins version LTS (stable)



###  Accès :

Ensuite, ouvre ton navigateur à `http://localhost:8080`
Et récupère le mot de passe admin initial avec :

```bash
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```


