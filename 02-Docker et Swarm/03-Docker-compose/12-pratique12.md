# Exercice 1 - Docker Compose avec WordPress et MySQL (P1)

Dans cet exercice, vous allez utiliser Docker Compose pour configurer et lancer une application WordPress connectée à une base de données MySQL. Vous allez également explorer les différences entre l'arrêt et la suppression des conteneurs via Docker Compose.

#### Étape 1 : Créer le fichier `docker-compose.yaml`

Commencez par créer le fichier `docker-compose.yaml` qui définira les services pour WordPress et MySQL.

```bash
touch docker-compose.yaml
nano docker-compose.yaml
```

#### Contenu du fichier `docker-compose.yaml` :

```yaml
version: '3.3'

services:
   db:
     image: mysql:5.7
     volumes:
       - db_data:/var/lib/mysql
     restart: always
     environment:
       MYSQL_ROOT_PASSWORD: somewordpress
       MYSQL_DATABASE: wordpress
       MYSQL_USER: wordpress
       MYSQL_PASSWORD: wordpress

   wordpress:
     depends_on:
       - db
     image: wordpress:latest
     ports:
       - "8000:80"
     restart: always
     environment:
       WORDPRESS_DB_HOST: db:3306
       WORDPRESS_DB_USER: wordpress
       WORDPRESS_DB_PASSWORD: wordpress
       WORDPRESS_DB_NAME: wordpress

volumes:
    db_data: {}
```

#### Explication :
- **db** : Service qui utilise l'image MySQL 5.7 et stocke les données dans un volume Docker `db_data`.
- **wordpress** : Service qui dépend de la base de données `db`, expose le port 80 du conteneur sur le port 8000 de l'hôte, et se connecte à la base de données MySQL avec les variables d'environnement fournies.
- **volumes** : Le volume `db_data` est utilisé pour persister les données de la base de données.

#### Étape 2 : Lancer Docker Compose

Lancez les services en arrière-plan (détaché) avec la commande suivante :

```bash
docker-compose up -d
```

#### Étape 3 : Vérifier que WordPress est en cours d'exécution

Ouvrez votre navigateur et allez à l'adresse suivante : [http://localhost:8000](http://localhost:8000). Vous devriez voir la page d'installation de WordPress.

#### Étape 4 : Arrêter Docker Compose avec CTRL + C

- Utilisez `CTRL + C` pour arrêter les services, puis exécutez la commande suivante pour voir que les conteneurs existent toujours mais sont arrêtés :

```bash
docker ps -a
```

Vous verrez que les conteneurs sont toujours là, mais leur état est "Exited". Vous pouvez les redémarrer à tout moment avec `docker start <id>`.

#### Étape 5 : Supprimer les conteneurs avec `docker-compose down`

Utilisez maintenant la commande `docker-compose down` pour arrêter et **supprimer** les conteneurs :

```bash
docker-compose down
```

Ensuite, vérifiez que les conteneurs n'existent plus :

```bash
docker ps -a
```

Les conteneurs ont été supprimés, ce qui est similaire à l'utilisation de `docker rm <id>`.

---

### Exercice 2 : Docker Compose avec WordPress et MySQL (P2)

Dans cet exercice, vous allez manipuler un conteneur en utilisant les commandes `pause`, `stop`, et `start` pour observer l'effet de la mise en pause et de l'arrêt d'un service.

#### Étape 1 : Lancer les services WordPress et MySQL

Lancez les services avec Docker Compose :

```bash
docker-compose up -d
```

#### Étape 2 : Vérifier que les services sont en cours d'exécution

Utilisez la commande `docker ps` pour lister les conteneurs en cours d'exécution :

```bash
docker ps
```

Vous verrez deux conteneurs : un pour WordPress et un pour MySQL. Notez l'ID du conteneur MySQL (ici `123f` pour l'exemple).

#### Étape 3 : Mettre en pause le conteneur MySQL

Mettez en pause le conteneur MySQL :

```bash
docker pause 123f
```

Ensuite, essayez d'accéder à WordPress via le navigateur à [http://localhost:8000](http://localhost:8000). Vous devriez voir une erreur, car la base de données est en pause.

#### Étape 4 : Arrêter le conteneur MySQL

Arrêtez le conteneur MySQL avec la commande suivante :

```bash
docker stop 123f
```

Vérifiez à nouveau dans le navigateur [http://localhost:8000](http://localhost:8000). WordPress ne devrait plus fonctionner car la base de données est complètement arrêtée.

#### Étape 5 : Redémarrer le conteneur MySQL

Redémarrez le conteneur MySQL :

```bash
docker start 123f
```

Vérifiez à nouveau WordPress via [http://localhost:8000](http://localhost:8000). Le service devrait de nouveau fonctionner correctement.

#### Étape 6 : Supprimer les services et les images

Lorsque vous avez terminé, vous pouvez tout supprimer en utilisant `docker-compose down` pour supprimer les services, puis nettoyer les images :

```bash
docker-compose down
```

Ensuite, supprimez toutes les images Docker utilisées avec la commande :

```bash
docker rmi -f $(docker images -q)
```

---

### Conclusion

Ces exercices montrent comment Docker Compose simplifie la gestion des applications multi-conteneurs, comme WordPress et MySQL, en automatisant la gestion des dépendances, du réseau, et du stockage persistant. Vous avez également appris comment mettre en pause, arrêter, et redémarrer des conteneurs, et vu la différence entre arrêter un service (`stop`) et le supprimer (`down`).
