# Introduction à Dockerfile

Le **Dockerfile** est un fichier texte qui contient une série d’instructions permettant de créer une image Docker. Une image Docker est un modèle en lecture seule qui contient tout le nécessaire pour exécuter une application, y compris le code, les bibliothèques et les dépendances. 

Le Dockerfile est le cœur de la création des images Docker, car il définit étape par étape la manière dont une image sera construite. Comprendre les éléments d’un Dockerfile est essentiel pour optimiser et personnaliser les environnements de déploiement des applications.

### Syntaxe et structure de base du Dockerfile

Chaque instruction dans un Dockerfile est une commande simple qui suit une syntaxe prédéfinie. Voici les composants les plus courants et leur signification :

#### 1. **FROM**
   - **Syntaxe** : `FROM <image_de_base>`
   - **Description** : Spécifie l'image de base à partir de laquelle construire l'image Docker. C’est souvent une image standard comme une distribution Linux (par exemple, `alpine`, `ubuntu`, ou `debian`).
   - **Exemple** :
     ```Dockerfile
     FROM ubuntu:20.04
     ```
   - **Explication** : Cette instruction indique que l’image Docker sera construite en se basant sur Ubuntu version 20.04.

#### 2. **RUN**
   - **Syntaxe** : `RUN <commande_shell>`
   - **Description** : Permet d'exécuter des commandes dans le conteneur lors de la création de l’image, comme installer des dépendances ou configurer des paramètres.
   - **Exemple** :
     ```Dockerfile
     RUN apt-get update && apt-get install -y python3
     ```
   - **Explication** : Ici, `RUN` met à jour les packages et installe Python 3 dans le conteneur.

#### 3. **COPY** ou **ADD**
   - **Syntaxe** : `COPY <source> <destination>`
   - **Description** : Copies des fichiers du système hôte (source) vers le système de fichiers du conteneur (destination).
   - **Exemple** :
     ```Dockerfile
     COPY . /app
     ```
   - **Explication** : Cette instruction copie tout le contenu du répertoire local (`.`) dans le dossier `/app` du conteneur.

#### 4. **WORKDIR**
   - **Syntaxe** : `WORKDIR <chemin>`
   - **Description** : Définit le répertoire de travail dans lequel les commandes suivantes seront exécutées. Cela permet de se déplacer dans un dossier particulier à l'intérieur du conteneur.
   - **Exemple** :
     ```Dockerfile
     WORKDIR /app
     ```
   - **Explication** : Toute commande qui suit sera exécutée dans le répertoire `/app` à l'intérieur du conteneur.

#### 5. **CMD** et **ENTRYPOINT**
   - **CMD** :
     - **Syntaxe** : `CMD ["executable", "param1", "param2"]`
     - **Description** : Définit la commande par défaut qui sera exécutée lorsque le conteneur démarre. Si une autre commande est fournie lors du démarrage du conteneur, elle écrasera celle définie dans `CMD`.
     - **Exemple** :
       ```Dockerfile
       CMD ["python3", "app.py"]
       ```
     - **Explication** : Lance l'application `app.py` avec Python lorsque le conteneur démarre.

   - **ENTRYPOINT** :
     - **Syntaxe** : `ENTRYPOINT ["executable", "param1", "param2"]`
     - **Description** : Similaire à `CMD`, mais ici, la commande ne peut pas être remplacée lors de l’exécution du conteneur. Cela permet de définir une commande principale à exécuter, mais avec la possibilité d’ajouter des arguments lors de l'exécution.
     - **Exemple** :
       ```Dockerfile
       ENTRYPOINT ["python3", "app.py"]
       ```
     - **Explication** : Définit le point d'entrée du conteneur. Ce script sera toujours exécuté, peu importe ce que vous fournissez en ligne de commande.

#### 6. **EXPOSE**
   - **Syntaxe** : `EXPOSE <port>`
   - **Description** : Indique que l’application à l'intérieur du conteneur écoute sur un certain port réseau.
   - **Exemple** :
     ```Dockerfile
     EXPOSE 8080
     ```
   - **Explication** : L’application à l’intérieur du conteneur utilisera le port 8080 pour communiquer.

#### 7. **ENV**
   - **Syntaxe** : `ENV <nom> <valeur>`
   - **Description** : Définit des variables d'environnement dans le conteneur.
   - **Exemple** :
     ```Dockerfile
     ENV APP_ENV=production
     ```
   - **Explication** : Crée une variable d’environnement `APP_ENV` avec la valeur `production`.

#### 8. **VOLUME**
   - **Syntaxe** : `VOLUME ["<chemin_dans_le_conteneur>"]`
   - **Description** : Déclare un point de montage pour les volumes partagés entre le conteneur et l’hôte.
   - **Exemple** :
     ```Dockerfile
     VOLUME ["/data"]
     ```
   - **Explication** : Indique que le répertoire `/data` sera monté en tant que volume persistant à l'extérieur du conteneur.

### Exemples concrets de Dockerfile

#### Exemple 1 : Dockerfile simple pour une application Node.js
```Dockerfile
# Utilise l'image de base officielle de Node.js
FROM node:14

# Définit le répertoire de travail dans le conteneur
WORKDIR /usr/src/app

# Copie les fichiers package.json et package-lock.json
COPY package*.json ./

# Installe les dépendances
RUN npm install

# Copie tout le code source dans le répertoire de travail
COPY . .

# Expose le port sur lequel l'application écoutera
EXPOSE 8080

# Définit la commande par défaut pour démarrer l'application
CMD ["node", "app.js"]
```

#### Exemple 2 : Dockerfile pour une application Python avec Flask
```Dockerfile
# Utilise une image Python comme image de base
FROM python:3.9-slim

# Définit le répertoire de travail
WORKDIR /app

# Copie les fichiers requirements.txt et installe les dépendances
COPY requirements.txt .
RUN pip install -r requirements.txt

# Copie le reste de l'application
COPY . .

# Expose le port pour Flask
EXPOSE 5000

# Définit la commande par défaut
CMD ["flask", "run", "--host=0.0.0.0"]
```

### Bonnes pratiques dans un Dockerfile
1. **Minimiser les couches** : Chaque instruction dans un Dockerfile crée une nouvelle couche dans l’image. Réduire le nombre d'instructions, par exemple en combinant plusieurs commandes `RUN`, permet d'alléger l'image.
2. **Utiliser des images légères** : Préférez des images de base légères comme `alpine` pour réduire la taille de l’image.
3. **Gérer le cache efficacement** : Le Docker cache les couches intermédiaires lors de la construction des images, ce qui accélère la reconstruction si rien n’a changé dans une étape précédente.
4. **Nettoyer après installation** : Supprimer les fichiers temporaires et les caches après l'installation de paquets permet de réduire la taille finale de l’image.


--------------------
# Annexe - Commandes pour construire et exécuter une image Docker
--------------------


#### 1. **Construction de l’image Docker : `docker build`**

La commande `docker build` est utilisée pour créer une image Docker à partir d’un Dockerfile. Voici la syntaxe générale :

```bash
docker build -t <nom_image>:<tag> <chemin_vers_le_dockerfile>
```

- **`-t`** : Cette option permet de nommer l'image. Le nom est optionnel mais recommandé pour pouvoir l'identifier facilement par la suite.
- **`<nom_image>`** : Le nom que vous donnez à l'image.
- **`<tag>`** : Le tag est facultatif et permet de versionner l'image (par défaut, c'est `latest` si non spécifié).
- **`<chemin_vers_le_dockerfile>`** : Chemin vers le répertoire contenant le Dockerfile. Par défaut, le chemin est `.` pour indiquer le répertoire courant.

#### Exemple :

```bash
docker build -t mon_app:1.0 .
```

- **`-t mon_app:1.0`** : Nomme l'image `mon_app` avec la version `1.0`.
- **`.`** : Indique que le Dockerfile est dans le répertoire courant.

#### 2. **Exécution du conteneur Docker : `docker run`**

Une fois l’image construite, vous pouvez créer et exécuter un conteneur à partir de cette image en utilisant la commande `docker run`. Voici la syntaxe générale :

```bash
docker run -d -p <port_hote>:<port_conteneur> --name <nom_conteneur> <nom_image>:<tag>
```

- **`-d`** : Exécute le conteneur en arrière-plan (détaché).
- **`-p <port_hote>:<port_conteneur>`** : Lie le port de l’hôte au port du conteneur (par exemple, pour rendre accessible une application web à travers un port).
- **`--name <nom_conteneur>`** : Donne un nom au conteneur pour l’identifier facilement.
- **`<nom_image>:<tag>`** : Indique le nom et le tag de l’image à partir de laquelle créer le conteneur.

#### Exemple :

```bash
docker run -d -p 8080:8080 --name conteneur_mon_app mon_app:1.0
```

- **`-d`** : Le conteneur est exécuté en arrière-plan.
- **`-p 8080:8080`** : Le port 8080 de l’hôte est lié au port 8080 du conteneur.
- **`--name conteneur_mon_app`** : Le conteneur sera nommé `conteneur_mon_app`.
- **`mon_app:1.0`** : L’image utilisée pour créer le conteneur est `mon_app` avec le tag `1.0`.

#### 3. **Lister les conteneurs en cours d'exécution : `docker ps`**

Pour vérifier quels conteneurs sont en cours d'exécution, utilisez la commande :

```bash
docker ps
```

Cela vous montrera une liste des conteneurs actifs avec leur ID, nom, et autres détails.

#### 4. **Arrêter un conteneur : `docker stop`**

Si vous souhaitez arrêter un conteneur en cours d'exécution, utilisez la commande suivante en précisant le nom ou l'ID du conteneur :

```bash
docker stop <nom_conteneur_ou_id>
```

#### 5. **Supprimer un conteneur : `docker rm`**

Après avoir arrêté un conteneur, vous pouvez le supprimer avec la commande :

```bash
docker rm <nom_conteneur_ou_id>
```

#### 6. **Supprimer une image Docker : `docker rmi`**

Si vous voulez supprimer une image Docker, utilisez :

```bash
docker rmi <nom_image>:<tag>
```
