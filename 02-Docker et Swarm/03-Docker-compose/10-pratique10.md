# Introduction

- Nous allons exécuter notre scénario en utilisant Docker Compose avec la version 3.2. 
- Je vous propose un guide détaillé des étapes

### 1. **Préparer le projet avec Docker Compose**

Tout d'abord, créez un répertoire pour votre projet :

```bash
sudo su -
pwd
mkdir projet1 && cd projet1
```

### 2. **Créer le fichier `docker-compose.yaml`**

Ensuite, créez le fichier `docker-compose.yaml` avec la version 3.2 et la configuration de votre application Flask connectée à Redis.

#### Contenu du fichier `docker-compose.yaml` :

```yaml
version: "3.2"
services:
  web:
    build: .
    ports:
      - "81:8080" # Changement du port externe de 80 à 81
    links:
      - redis
    networks:
      - mynet

  redis:
    image: redis:latest
    expose:
      - "6379"
    networks:
      - mynet

networks:
  mynet:
```

#### Explication :
- La version 3.2 est utilisée pour tirer parti des nouvelles fonctionnalités de Docker Compose.
- Le service `web` expose maintenant le port 81 à l'extérieur et redirige vers le port 8080 dans le conteneur Flask.
- Le service `redis` utilise l'image Redis officielle.
- Les deux services partagent le réseau `mynet`.

### 3. **Lancer Docker Compose**

Maintenant, lancez les services :

```bash
docker-compose up
```

### 4. **Gérer l'erreur de port (si le port 80 est déjà utilisé)**

Si vous obtenez une erreur indiquant que le port 80 est déjà utilisé, éditez le fichier `docker-compose.yaml` pour changer le port à 81 :

```bash
nano docker-compose.yaml
```

Modifiez la ligne de ports pour ressembler à ceci :

```yaml
ports:
  - "81:8080"
```

Ensuite, relancez Docker Compose :

```bash
docker-compose up
```

### 5. **Arrêter et redémarrer en mode détaché**

Arrêtez et nettoyez les services :

```bash
docker-compose down
```

Ensuite, relancez-les en arrière-plan (mode détaché) :

```bash
docker-compose up -d
```

### 6. **Vérification des conteneurs en cours d'exécution**

Vérifiez l'état des services :

```bash
docker-compose ps
```

### 7. **Scalabilité du service Redis**

Si vous souhaitez faire évoluer le nombre d'instances Redis, utilisez la commande `docker-compose scale` :

```bash
docker-compose scale redis=2
```

Cela lancera deux instances du service Redis.

### 8. **Tester l'application Flask**

Entrez dans le conteneur Flask pour tester l'application via `curl` :

```bash
docker exec -it <container_id_web> bash
curl localhost:8080
exit
```

Ensuite, testez depuis l'extérieur avec le port que vous avez configuré (ici le port 81) :

```bash
curl localhost:81
```

### 9. **Arrêter et supprimer les conteneurs et images**

Lorsque vous avez terminé, vous pouvez arrêter et supprimer tous les conteneurs ainsi que les images associées :

```bash
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
docker rmi $(docker images -q)
```

Si vous souhaitez forcer la suppression des images, utilisez la commande suivante :

```bash
docker rmi -f $(docker images -q)
```

---

### Conclusion

Vous venez de voir à quel point Docker Compose simplifie le processus de gestion de plusieurs services Docker, en automatisant non seulement le déploiement des conteneurs, mais aussi leur mise à l'échelle, la gestion des ports, et les connexions réseau.
