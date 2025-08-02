# Chapitre 11 - Démonstration introductive de la gestion des services (pratique8)



<a name="table-des-matieres"></a>
## Table des matières
- [Introduction](#introduction)
- [Prérequis](#prerequis)
- [Arborescence des fichiers](#arborescence-des-fichiers)
- [1 - Étape 1: Création du fichier YAML](#etape1)
- [2 - Étape 2: Déploiement du Service](#etape2) 
- [3 - Étape 3: Vérification du Service](#etape3)
- [4 - Résumé des Commandes](#resume-des-commandes)
- [Conclusion](#conclusion)


<a name="introduction"></a>
---
# Introduction
---

Les Services dans Kubernetes permettent de communiquer avec un ou plusieurs Pods. Habituellement, les Pods sont éphémères et peuvent changer fréquemment d'adresse IP. Les Services fournissent une adresse IP fixe et un nom DNS pour un ensemble de Pods, et chargent également la balance du trafic vers ces Pods.

#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="prerequis"></a>
---
# Prérequis
---

- Avoir installé `kubectl`.
- Avoir accès à un cluster Kubernetes.
- Avoir fait le lab précédent *Gestion-des-deploiments* et avoir crée 1 déploiement nginx avec 3 pods avec cette section. Sinon, vous pouvez utiliser le fichier *mydeployment.yaml* dans l'étape 1 :


#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="arborescence-des-fichiers"></a>
---
# Arborescence des fichiers
---

> *Voici l'arborescence des fichiers :*

```bash
.
├── mydeployment.yaml
├── myservice.yaml
```

> *Voici le contenu du fichier *myservice.yaml* :*

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30008
```

> *Voici les commandes à exécuter :*


```ssh
kubectl apply -f mydeployment.yaml
kubectl apply -f myservice.yaml
kubectl get services
kubectl describe service nginx-service
kubectl get deployments --show-labels --selector app=nginx --namespace=default
kubectl delete service nginx-service
```


#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="etape1"></a>
---
# 1 - Étape 1: Création du fichier YAML pour le Service
---

Pour exposer le déploiement `nginx` créé précédemment, nous utiliserons un Service de type `NodePort` qui rendra l'application accessible de l'extérieur du cluster Kubernetes.

1. *Ouvrez votre éditeur de texte ou IDE*.
2. *Créez un fichier nommé *`myservice.yaml`*.
3. *Ajoutez le contenu suivant au fichier* :

> *Voici le contenu du fichier *myservice.yaml* :*  

```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30008
```



**Particulièrement, cette section est très importante !**

```yaml
spec:
  type: NodePort
  selector:
    app: nginx
```

Le sélecteur `app: nginx` dans le Service correspond aux labels des pods créés par le déploiement. Cette correspondance permet au Service de découvrir et de router le trafic vers les pods appropriés. C'est un concept fondamental dans Kubernetes qui permet le couplage dynamique entre les Services et les pods qu'ils exposent.

```yaml
  template:
    metadata:
      labels:
        app: nginx
```

En effet, à titre d'exemple, nous créons ce déploiement qui contient 3 réplicas de pods nginx, chacun portant le label `app: nginx`. Ce label est crucial car il permet au service de découvrir et d'identifier dynamiquement les pods qu'il doit gérer. Cette approche déclarative offre une grande flexibilité : même si des pods sont ajoutés ou supprimés, le service continuera automatiquement à router le trafic vers tous les pods correspondant à ce label.


```ssh
kubectl apply -f mydeployment.yaml
```
> Voici le contenu du fichier *mydeployment.yaml* qui définit notre déploiement nginx avec 3 réplicas :

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

#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="etape2"></a>
---
# 2 - Étape 2: Déploiement du Service et explication des sections
---

Déployez le Service dans votre cluster Kubernetes pour exposer le déploiement `nginx`.

- *Ouvrez un terminal*.
- *Naviguez au répertoire contenant* `myservice.yaml`.
- *Exécutez la commande* pour créer le Service :

```bash
kubectl apply -f myservice.yaml
```

Voici le contenu complet du fichier *myservice.yaml* qui définit notre service NodePort pour exposer le déploiement nginx :


```yaml
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30008
```

Voici la partie pour sélectionner les pods à exposer :  

```yaml
  selector:
    app: nginx
```

Voici la partie pour définir le type de service :


```yaml
spec:
  type: NodePort
``` 

Voici la partie pour définir le nom du service :

```yaml
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
```

Voici la partie pour définir le port du service :

```yaml
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
      nodePort: 30008
```

> C'est la partie CRUCIALE pour définir les ports du service - c'est ici que toute la magie de la connectivité se produit !

> Cette configuration des ports est ABSOLUMENT ESSENTIELLE car elle détermine comment le trafic circule à travers votre service. Regardez attentivement comment nous définissons chaque aspect :

#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="etape3"></a>
---
# 3 - Étape 3: Vérification du Service
---

Après avoir créé le Service, vérifiez qu'il est correctement configuré et qu'il route le trafic vers votre Pod `nginx`.

- **Pour obtenir des informations sur le Service, exécutez** :

```bash
kubectl get services
```

- **Pour obtenir des détails plus spécifiques sur le Service 'nginx-service', utilisez** :

```bash
kubectl describe service nginx-service
```


```bash
minikube ip
curl IP: 30008

```

#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="resume-des-commandes"></a>
---
# 4 - Résumé des Commandes 
---

```bash
# Créer le fichier YAML pour le Service
echo "
apiVersion: v1
kind: Service
metadata:
  name: nginx-service
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
" > myservice.yaml

# Déployer le Service
kubectl apply -f myservice.yaml

# Lister les services pour vérifier l'état
kubectl get services

# Obtenir des détails sur le service 'nginx-service'
kubectl describe service nginx-service
```

Ce guide fournit une introduction pratique à la gestion des services dans Kubernetes, ce qui est crucial pour la production et la gestion efficace des applications.

#### [↩️ Retour à la table des matières : Table des matieres](#table-des-matieres)

<a name="conclusion"></a>
---
# 6 - Conclusion
---

Les Services sont essentiels pour la gestion du trafic réseau dans les applications Kubernetes, fournissant un point d'accès stable aux applications dynamiques. Ce tutoriel vous a guidé à travers la création d'un Service qui expose un déploiement Nginx dans un cluster Kubernetes.


