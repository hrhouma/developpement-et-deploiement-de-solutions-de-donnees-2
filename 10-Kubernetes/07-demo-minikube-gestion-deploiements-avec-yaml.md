---
title: "Chapitre 7 - démonstration-minikube du gestion des déploiements avec yaml (pratique5)"
description: "Approfondissez vos connaissances avec des explications supplémentaires et des solutions de dépannage complémentaires aux 5 tutoriels précédents."
emoji: "🔧"
---

# Chapitre 7 - démonstration-minikube du gestion des déploiements avec yaml (pratique5)

<a name="table-des-matieres"></a>
## Table des matières

- [Introduction](#introduction)
- [Prérequis](#prerequis)
- [Étape 1: Création du fichier YAML pour le Déploiement](#etape-1)
- [Étape 2: Déploiement de l'application](#etape-2)
- [Étape 3: Vérification du Déploiement](#etape-3)
- [Étape 4: Suppression de quelques pods du déploiement et observation si nous avons encore le même nombre de pods](#etape-4)
- [Étape 5: Suppression du Déploiement](#etape-5)
- [Conclusion](#conclusion)
- [Résumé des Commandes](#resume)

<a name="introduction"></a>
# Introduction

Ce tutoriel explique comment gérer les déploiements dans Kubernetes, en utilisant le `kubectl` et des fichiers de configuration YAML. Vous apprendrez à configurer un déploiement pour un serveur web Nginx simple.

#### [🔙 Retour à la table des matières](#table-des-matieres)

---

<a name="prerequis"></a>
# Prérequis

- Avoir installé `kubectl`.
- Avoir accès à un cluster Kubernetes comme Minikube ou un cluster dans un cloud.

---

<a name="etape-1"></a>
# 1 - Étape 1: Création du fichier YAML pour le Déploiement

Un déploiement assure que le nombre spécifié de réplicas de pods roule en continu. Créez un fichier YAML pour le déploiement qui définit un serveur Nginx.

1. **Ouvrez votre éditeur de texte ou IDE** (Visual Studio Code par exemple).
2. **Créez un fichier nommé** `mydeployment.yaml`.
3. **Ajoutez le contenu suivant au fichier** :

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```

#### [🔙 Retour à la table des matières](#table-des-matieres)
---

<a name="etape-2"></a>
# 2 - Étape 2: Déploiement de l'application

Déployez le fichier YAML dans votre cluster Kubernetes pour créer le déploiement.

- **Ouvrez un terminal**.
- **Naviguez au répertoire contenant** `mydeployment.yaml`.
- **Exécutez la commande** pour déployer :

```bash
kubectl apply -f mydeployment.yaml
```

#### [🔙 Retour à la table des matières](#table-des-matieres)
---

<a name="etape-3"></a>
# 3 - Étape 3: Vérification du Déploiement

Après le déploiement, il est essentiel de vérifier son état pour s'assurer qu'il fonctionne comme prévu.

- **Pour obtenir des informations sur le déploiement, exécutez** :

```bash
kubectl get deployments
```


- **Pour obtenir des détails plus spécifiques sur le déploiement 'nginx', utilisez** :

```bash
kubectl describe deployment nginx
```

#### [🔙 Retour à la table des matières](#table-des-matieres)
---

<a name="etape-4"></a>
# 4 - Étape 4: Suppression de quelques pods du déploiement et observation si nous avons encore le même nombre de pods

- Affichez les ids de vos pods en exécutant  *kubectl get pods*
- Récupérer l'id de 1 de vos pods
- Comptez le nombre de pods ( Nous avons 3 puisque c'est spécifié dans le déploiement)
- Supprimer ce pod en utilisant son id avec la commande *kubectl delete po id_pod_récupéré*
- Afficher les pods avec *kubectl get po*
- Comment vous expliquez que nous avons toujours 3 pods ???????



#### [🔙 Retour à la table des matières](#table-des-matieres)
---

<a name="etape-5"></a>
# 5 - Étape 5: Suppression du Déploiement

Pour supprimer le déploiement lorsque vous n'en avez plus besoin :

- **Exécutez la commande suivante** :

```bash
kubectl delete deployment nginx
```

#### [🔙 Retour à la table des matières](#table-des-matieres)
---

<a name="conclusion"></a>
# 6 - Conclusion

Ce tutoriel a guidé les étapes de la gestion d'un déploiement dans Kubernetes, couvrant la création, le déploiement, la vérification et la suppression. Vous avez appris à utiliser `kubectl` pour gérer des applications plus complexes en production.

#### [🔙 Retour à la table des matières](#table-des-matieres)
---

<a name="resume"></a>
# 7 - Résumé des Commandes

```bash
# Créer le fichier YAML pour le déploiement - commande numéro 1
echo "
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
" > mydeployment.yaml

# Déployer le déploiement - commande numéro 2 (après avoir créé le fichier YAML)
kubectl apply -f mydeployment.yaml

# Lister les déploiements pour vérifier l'état - commande numéro 3
kubectl get deployments 

# Obtenir des détails sur le déploiement 'nginx' - commande numéro 4
kubectl describe deployment nginx

# Suppression des pods - commande numéro 5 (*kubectl delete po id_pod_récupéré*)
- Affichez les ids de vos pods en exécutant  *kubectl get pods*
- Récupérer l'id de 1 de vos pods
- Comptez le nombre de pods ( Nous avons 3 puisque c'est spécifié dans le déploiement)
- Supprimer ce pod en utilisant son id avec la commande *kubectl delete po id_pod_récupéré*
- Afficher les pods avec *kubectl get po*
- Comment vous expliquez que nous avons toujours 3 pods ???????


# Supprimer le déploiement - commande numéro 6
kubectl delete deployment nginx
```

#### [🔙 Retour à la table des matières](#table-des-matieres)

# Annexe - différence entre un déploiement, un réplica set et un pod

- Un déploiement est un objet de plus haut niveau qui gère les ReplicaSets et fournit des mises à jour déclaratives pour les Pods.
- Un ReplicaSet assure qu'un nombre spécifié de réplicas de Pod sont en cours d'exécution à tout moment.
- Un Pod est la plus petite unité déployable dans Kubernetes, contenant un ou plusieurs conteneurs qui partagent des ressources.

Hiérarchie :

1. Déploiement
   - Gère les mises à jour et les rollbacks
   - Maintient l'historique des versions
   - Permet les mises à jour progressives

2. ReplicaSet
   - Créé et géré par le Déploiement
   - Maintient un ensemble stable de Pods répliqués
   - Assure la disponibilité du nombre souhaité de Pods

3. Pod
   - Unité d'exécution de base
   - Contient un ou plusieurs conteneurs
   - Partage le même réseau et espace de stockage

Le Déploiement est généralement préféré car il offre plus de fonctionnalités que l'utilisation directe des ReplicaSets ou des Pods.



# Pod simple (niveau le plus bas)
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
```
---
# ReplicaSet (niveau intermédiaire)
```yaml
apiVersion: apps/v1
kind: ReplicaSet
metadata:
  name: nginx-rs
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
```
---
# Deployment (niveau le plus haut)
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx-deployment
spec:
  replicas: 3
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx:alpine
        ports:
        - containerPort: 80
``` 

# Annexe 2 - exercice de comparaison entre Pod, ReplicaSet et Deployment

## Analyse comparative des configurations YAML

### Question d'observation:

En observant les trois configurations YAML ci-dessus (Pod, ReplicaSet et Deployment), pouvez-vous identifier:

1. **Les différences au niveau de l'attribut `kind`**:
   - Pod: `kind: Pod`
   - ReplicaSet: `kind: ReplicaSet` 
   - Deployment: `kind: Deployment`

2. **Les éléments qui s'ajoutent dans un ReplicaSet par rapport à un Pod**:
   - Ajout de `replicas: 3` pour gérer plusieurs instances
   - Ajout de `selector` avec `matchLabels` pour sélectionner les pods
   - Le Pod devient un `template` dans la configuration

3. **Ce qui reste identique dans les trois configurations**:
   - La structure de base des conteneurs sous `spec.containers`
   - Les métadonnées de base (`apiVersion`, `metadata`)
   - La configuration du conteneur nginx reste la même

4. **Les avantages de chaque niveau**:
   - Pod: Unité la plus simple, parfait pour les applications stateless uniques
   - ReplicaSet: Ajoute la réplication et l'auto-guérison
   - Deployment: Ajoute la gestion des mises à jour et des rollbacks

Cette progression montre comment Kubernetes construit des abstractions de plus en plus sophistiquées tout en maintenant une cohérence dans la structure de base.

