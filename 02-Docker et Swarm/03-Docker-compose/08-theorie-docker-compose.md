
# Cours sur Docker Compose

#### Introduction

Docker Compose est un outil qui permet de définir et de gérer des applications multi-conteneurs Docker. Plutôt que de démarrer et gérer chaque conteneur séparément, Docker Compose vous permet de définir et de démarrer tous les conteneurs nécessaires pour votre application via un fichier YAML unique. Cela simplifie énormément le processus de déploiement d'applications complexes.

---

### Objectifs du cours
1. Comprendre ce qu'est Docker Compose.
2. Apprendre à définir des services multi-conteneurs à l'aide de Docker Compose.
3. Apprendre à exécuter et gérer ces services avec les commandes Docker Compose.
4. Développer un projet simple en utilisant Docker Compose.

---

### I. Pourquoi Docker Compose ?
- **Problème des conteneurs multiples** : Lorsqu'une application a besoin de plusieurs services (comme une base de données, un serveur web, un système de cache, etc.), chaque service doit être démarré et configuré séparément avec Docker.
- **Solution avec Docker Compose** : Docker Compose automatise cette orchestration en permettant de définir ces services dans un fichier YAML. En une seule commande, vous pouvez démarrer tous les services.

---

### II. Installation de Docker Compose

Docker Compose fait partie de Docker Desktop pour Windows et macOS, mais sur Linux, vous devrez l’installer séparément.

1. **Vérifier Docker** : Docker doit déjà être installé. Tapez :
   ```bash
   docker --version
   ```

2. **Installer Docker Compose** :
   Pour Linux, vous pouvez utiliser la commande suivante :
   ```bash
   sudo apt install docker-compose
   ```
   Vérifiez ensuite l’installation avec :
   ```bash
   docker-compose --version
   ```

---

### III. Structure d'un fichier `docker-compose.yml`

Le fichier `docker-compose.yml` est au cœur de Docker Compose. Il décrit les services que votre application utilise, les volumes, les réseaux, etc.

Voici un exemple de fichier `docker-compose.yml` :

```yaml
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  database:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: userpassword
```

**Détails :**
- `version` : Spécifie la version de Docker Compose utilisée.
- `services` : Définit les différents services qui seront démarrés. Ici, nous avons un service `web` basé sur l'image Nginx et un service `database` basé sur l'image MySQL.
- `ports` : Définit le mappage des ports entre le conteneur et l'hôte (ici, le port 8080 de la machine locale est redirigé vers le port 80 du conteneur Nginx).
- `environment` : Définit les variables d'environnement pour la configuration du service (comme les mots de passe de la base de données).

---

### IV. Commandes Docker Compose

Voici quelques commandes essentielles pour utiliser Docker Compose.

1. **Démarrer une application** : 
   Pour démarrer tous les services définis dans le fichier `docker-compose.yml`, utilisez :
   ```bash
   docker-compose up
   ```
   Ajoutez `-d` pour démarrer en mode détaché (en arrière-plan) :
   ```bash
   docker-compose up -d
   ```

2. **Arrêter les services** : 
   Pour arrêter tous les services :
   ```bash
   docker-compose down
   ```

3. **Lister les services actifs** :
   Pour lister les services en cours d'exécution :
   ```bash
   docker-compose ps
   ```

4. **Construire des images** :
   Si vous utilisez des images personnalisées, vous pouvez construire toutes les images définies dans le `docker-compose.yml` :
   ```bash
   docker-compose build
   ```

5. **Redémarrer un service spécifique** :
   Vous pouvez redémarrer un seul service :
   ```bash
   docker-compose restart nom_du_service
   ```

6. **Afficher les logs** :
   Pour afficher les logs des services :
   ```bash
   docker-compose logs
   ```
   Vous pouvez aussi afficher les logs d'un seul service :
   ```bash
   docker-compose logs nom_du_service
   ```

---

### V. Exercice Pratique

**Objectif** : Créer une application simple avec un serveur web Nginx et une base de données MySQL à l'aide de Docker Compose.

1. **Étape 1** : Créez un fichier `docker-compose.yml` avec le contenu suivant :

```yaml
version: '3.8'
services:
  web:
    image: nginx:alpine
    ports:
      - "8080:80"
  db:
    image: mysql:5.7
    environment:
      MYSQL_ROOT_PASSWORD: rootpassword
      MYSQL_DATABASE: mydb
      MYSQL_USER: user
      MYSQL_PASSWORD: userpassword
```

2. **Étape 2** : Exécutez la commande suivante pour démarrer l'application :

```bash
docker-compose up -d
```

3. **Étape 3** : Ouvrez votre navigateur et accédez à [http://localhost:8080](http://localhost:8080) pour vérifier que le serveur Nginx fonctionne.

4. **Étape 4** : Utilisez `docker-compose ps` pour vérifier que les services Nginx et MySQL sont en cours d'exécution.

5. **Étape 5** : Pour arrêter les services, utilisez :
```bash
docker-compose down
```

---

### VI. Volumes et Réseaux

Docker Compose permet également de configurer des volumes persistants et des réseaux pour faciliter la communication entre les services.

**Volumes :**
```yaml
services:
  database:
    image: mysql:5.7
    volumes:
      - db_data:/var/lib/mysql
volumes:
  db_data:
```
Cela permet de persister les données MySQL même après l'arrêt du conteneur.

**Réseaux :**
```yaml
services:
  web:
    networks:
      - front
  db:
    networks:
      - back
networks:
  front:
  back:
```

Cela permet de séparer la communication entre différents services sur des réseaux distincts.

---

### Conclusion

Docker Compose simplifie énormément la gestion d'applications multi-conteneurs en permettant de tout définir dans un fichier unique et de démarrer/arrêter l'application avec une seule commande. C'est un outil essentiel pour les développeurs et les administrateurs système qui gèrent des environnements complexes.

---

### Devoirs

1. Modifiez le fichier `docker-compose.yml` pour ajouter un service Redis.
2. Utilisez Docker Compose pour monter un volume afin de sauvegarder les données MySQL localement.
3. Explorez les logs de vos services avec la commande `docker-compose logs`.

