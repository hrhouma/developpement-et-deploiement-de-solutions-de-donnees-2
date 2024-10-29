# Exercice : Travailler sans Docker Compose

Cet exercice montre les difficultés de gérer des conteneurs Docker sans Docker Compose. Vous allez construire une application Flask connectée à Redis en exécutant chaque conteneur manuellement et en gérant leurs connexions avec la commande `docker run`.

---

#### **Étape 1 : Configuration de l'environnement**

Vous allez créer les trois fichiers suivants : `Dockerfile`, `app.py`, et `requirements.txt`. Ces fichiers définissent l'environnement de votre application et ses dépendances.

##### **1. Fichier `Dockerfile`**

Ce fichier est utilisé pour construire l'image Docker de votre application Flask.

```Dockerfile
FROM python:3.7
COPY . /tmp
RUN pip install -r /tmp/requirements.txt
EXPOSE 8080
CMD ["python", "/tmp/app.py"]
```

##### **2. Fichier `app.py`**

Le fichier `app.py` est une application Flask simple qui utilise Redis pour compter les accès à la page d'accueil et retourne le nombre d'accès ainsi que le nom de l'hôte.

```python
from flask import Flask
from redis import Redis
import os
import socket

app = Flask(__name__)
redis = Redis(host=os.environ.get('REDIS_HOST', 'redis'), port=6379)

@app.route('/')
def hello():
    redis.incr('hits')
    return 'Hello from Container! I have been seen %s times and my hostname is %s\n' % (redis.get('hits'), socket.gethostname())

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080, debug=True)
```

##### **3. Fichier `requirements.txt`**

Liste des dépendances pour l'application.

```
flask
redis
```

---

#### **Étape 2 : Démarrage de l'application sans Docker Compose**

Maintenant que les fichiers sont prêts, vous allez démarrer chaque conteneur manuellement, gérer les connexions entre les conteneurs, et expérimenter la gestion sans Docker Compose.

##### **1. Construire l'image Docker Flask**

Commencez par construire l'image Docker pour l'application Flask.

```bash
docker build -t imageflask1:2.0 .
```

Cette commande construit l'image Docker en utilisant le fichier `Dockerfile` présent dans le répertoire courant (`.`) et nomme l'image `imageflask1` avec le tag `2.0`.

##### **2. Démarrer le conteneur Redis**

Vous allez maintenant démarrer un conteneur Redis séparément.

```bash
docker run -d --name redis redis
```

Cette commande lance un conteneur nommé `redis` à partir de l'image officielle Redis en arrière-plan (`-d`).

##### **3. Démarrer l'application Flask (premier essai)**

Lancez maintenant le conteneur pour l'application Flask.

```bash
docker run -d --name containerflask -p 8080:8080 imageflask1:2.0
```

Cette commande lance le conteneur nommé `containerflask` et lie le port 8080 du conteneur à celui de l’hôte. Cependant, cette étape va entraîner une **erreur** car Flask ne pourra pas se connecter à Redis. La raison est que les conteneurs sont isolés et ne peuvent pas se découvrir automatiquement.

##### **4. Tester l'application (premier essai)**

Pour vérifier l'état de l'application, entrez dans le conteneur Flask et essayez de faire une requête `curl` :

```bash
docker exec -it containerflask bash
curl localhost:8080
```

Vous allez probablement rencontrer une **erreur** de connexion, car l'application Flask ne peut pas trouver Redis.

---

### **Comprendre le problème : Pourquoi Docker Compose est important**

L'erreur que vous rencontrez se produit parce que les conteneurs sont isolés les uns des autres. Docker Compose résout ce problème en automatisant la gestion du réseau entre les services et en rendant leur communication facile.

---

#### **Étape 3 : Démarrage de l'application avec `--link` (deuxième essai)**

Pour résoudre ce problème sans Docker Compose, vous devez lier manuellement les conteneurs en utilisant l'option `--link`.

##### **1. Supprimer les conteneurs et images existants**

Avant de réessayer, nettoyez l'environnement en supprimant les conteneurs et les images :

```bash
docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q) && docker rmi -f $(docker images -q)
```

##### **2. Reconstruire l'image et relancer Redis**

Reconstruisez l'image Docker pour Flask et relancez le conteneur Redis :

```bash
docker build -t imageflask1:2.0 .
docker run -d --name redis redis
```

##### **3. Lancer l'application Flask avec `--link`**

Cette fois, vous allez lier manuellement le conteneur Flask à Redis en utilisant l'option `--link` :

```bash
docker run -d --name containerflask1 --link redis:redis -p 8080:8080 imageflask1:2.0
```

Cette commande crée un lien entre le conteneur `containerflask1` et le conteneur `redis`, permettant à Flask de se connecter à Redis via le nom d'hôte `redis`.

##### **4. Tester l'application (deuxième essai)**

Entrez dans le conteneur Flask et effectuez une requête `curl` pour vérifier si l'application fonctionne correctement :

```bash
docker exec -it containerflask1 bash
curl localhost:8080
```

Cette fois-ci, l'application devrait répondre correctement avec un message indiquant le nombre de fois que la page a été visitée.

---

#### **Étape 4 : Nettoyage de l'environnement**

Une fois que vous avez terminé, vous pouvez nettoyer tous les conteneurs et les images Docker avec les commandes suivantes :

```bash
docker stop containerflask1 redis
docker rm containerflask1 redis
docker rmi imageflask1:2.0 redis
```

---

### Conclusion

Cet exercice montre à quel point il peut être compliqué de gérer plusieurs conteneurs sans Docker Compose. Sans cet outil, il est nécessaire de gérer manuellement les connexions entre conteneurs via des options comme `--link`, ce qui devient rapidement fastidieux. Docker Compose simplifie tout ce processus en automatisant la configuration réseau, les volumes, et les dépendances entre conteneurs.
