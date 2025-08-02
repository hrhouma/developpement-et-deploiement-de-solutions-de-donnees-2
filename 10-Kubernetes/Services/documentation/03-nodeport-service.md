# Cours 3 : NodePort – Service pour Développement et Tests dans Kubernetes

## Qu'est-ce que NodePort ?

Le type **NodePort** expose un service Kubernetes sur un port spécifique de chaque nœud du cluster. Cela permet un accès facile au service depuis l'extérieur, idéal pour les environnements de développement et de tests.

## Quand utiliser un service NodePort ?

* **Développement local** (Kind, Minikube)
* **Prototypage rapide et tests internes**
* **Environnements de démonstration et formation**

## Quand ne pas utiliser NodePort ?

* **Environnement de production** (sauf exceptions précises)
* **Applications nécessitant une sécurité forte ou une gestion avancée du trafic**
* **Environnements cloud** : privilégier le type LoadBalancer ou Ingress

## Plage de Ports NodePort

* **Plage par défaut** : 30000-32767
* **Personnalisable** : modifiable dans la configuration du cluster
* **Allocation automatique** : par Kubernetes si non spécifié explicitement

## Exemples détaillés de configuration

### Exemple basique explicite

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  namespace: webapp-namespace
spec:
  type: NodePort
  selector:
    app: webapp
  ports:
    - port: 8080        # Port interne du service
      targetPort: 80    # Port du conteneur
      nodePort: 31200   # Port externe sur chaque nœud
```

### Exemple avec allocation automatique

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
spec:
  type: NodePort
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 8080
      # nodePort alloué automatiquement
```

## Architecture NodePort expliquée simplement

```
Cluster Kubernetes

Node 1 (IP: 192.168.1.10)      Node 2 (IP: 192.168.1.11)
 ┌───────────────┐             ┌───────────────┐
 │ Port 31200    │             │ Port 31200    │
 │      ↓        │             │      ↓        │
 │ Service webapp│             │ Service webapp│
 │      ↓        │             │      ↓        │
 │ Pod webapp-1  │             │ Pod webapp-2  │
 └───────────────┘             └───────────────┘
      ↑                               ↑
  Accès : 192.168.1.10:31200 ou 192.168.1.11:31200
```

## Accéder au service NodePort

### Directement par IP des nœuds

```bash
curl http://192.168.1.10:31200/
curl http://192.168.1.11:31200/
```

### Utilisation avec Minikube

```bash
minikube ip
curl http://$(minikube ip):31200/
```

## Configuration spéciale pour Kind

Kind nécessite une configuration supplémentaire (`extraPortMappings`) pour exposer les NodePorts :

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 31200
        hostPort: 31200
        protocol: TCP
```

```bash
kind create cluster --config kind-config.yaml
```

Accès avec Kind :

```bash
curl http://localhost:31200/
```

## Techniques de debug pour NodePort

### Vérifier l'état du service

```bash
kubectl get svc --all-namespaces | grep NodePort
kubectl describe svc webapp-service -n webapp-namespace
```

### Vérifier l'état des nœuds

```bash
kubectl get nodes -o wide
nmap -p 31200 <IP_NOEUD>
```

### Tester la connectivité

```bash
kubectl run test --image=busybox --rm -it --restart=Never -- wget -qO- http://webapp-service.webapp-namespace:8080
curl http://<IP_NOEUD>:31200/
```

## Limitations importantes

* **Plage de ports limitée** : seulement entre 30000 et 32767
* **Exposition sur tous les nœuds** : sécurité réduite
* **Load balancing basique** : pas adapté aux grandes charges
* **Gestion des IPs compliquée** : changement possible des IPs de nœuds

## Bonnes pratiques pour NodePort

### Définir explicitement le nodePort en développement

```yaml
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 31200
```

### Organiser les plages de ports

* Frontend : 31000-31099
* Backend : 31100-31199
* Database : 31200-31299

### Documenter clairement le service

```yaml
metadata:
  name: webapp-service
  annotations:
    description: "Service NodePort pour environnement de développement"
    accès: "http://localhost:31200"
```

## Exemple complet pour environnement de développement

### Deployment et Service

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-dev
  namespace: development
spec:
  replicas: 1
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
        - name: webapp
          image: nginx:latest
          ports:
            - containerPort: 80
---
apiVersion: v1
kind: Service
metadata:
  name: webapp-dev-service
  namespace: development
spec:
  type: NodePort
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 80
      nodePort: 31200
```

## Migration vers LoadBalancer pour la production

Quand vous migrez en production, remplacez NodePort par LoadBalancer :

```yaml
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 8080
```

## Résumé

NodePort est idéal pour le développement, les tests rapides et l'apprentissage de Kubernetes, mais évitez absolument son utilisation en production. Préférez toujours LoadBalancer ou Ingress dans un contexte professionnel.
