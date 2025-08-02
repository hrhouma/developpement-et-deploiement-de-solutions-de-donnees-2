# 🚪 NodePort : Service pour Développement et Test

## 🎯 Qu'est-ce que NodePort ?

**NodePort** expose le service sur un port spécifique de **chaque nœud** du cluster. Il permet d'accéder au service depuis l'extérieur du cluster.

### ✅ Quand l'utiliser ?

- ✅ **Développement local** (Kind, Minikube)
- ✅ **Tests et prototypage**
- ✅ **Environnements de développement**
- ✅ **Démonstrations rapides**

### ❌ Quand NE PAS l'utiliser ?

- ❌ **Production** (sauf cas très spécifiques)
- ❌ **Applications critiques**
- ❌ **Quand vous avez besoin d'un vrai load balancer**
- ❌ **Environnements cloud** (utilisez LoadBalancer à la place)

## 📊 Plage de Ports NodePort

- **Plage par défaut** : 30000-32767
- **Configurable** dans la configuration du cluster
- **Allocation automatique** si non spécifié

## 📝 Configuration

### Exemple basique

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
    - port: 8080        # Port du service (interne)
      targetPort: 80     # Port du conteneur
      nodePort: 31200    # Port exposé sur chaque nœud
      protocol: TCP
```

### Port automatique

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
      # nodePort sera alloué automatiquement (30000-32767)
```

## 🏗️ Architecture NodePort

```
┌─────────────────────────────────────────────────────────────┐
│                        CLUSTER                             │
│                                                             │
│  Node 1 (IP: 192.168.1.10)     Node 2 (IP: 192.168.1.11)  │
│  ┌─────────────────────────┐   ┌─────────────────────────┐  │
│  │ Port 31200             │   │ Port 31200             │  │
│  │        ↓               │   │        ↓               │  │
│  │ [Service: webapp]      │   │ [Service: webapp]      │  │
│  │        ↓               │   │        ↓               │  │
│  │ [Pod webapp-1]         │   │ [Pod webapp-2]         │  │
│  └─────────────────────────┘   └─────────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
           ↑                               ↑
    192.168.1.10:31200            192.168.1.11:31200
```

## 🌐 Accès au Service

### Accès direct par IP du nœud

```bash
# Si vous connaissez l'IP des nœuds
curl http://192.168.1.10:31200/
curl http://192.168.1.11:31200/

# Les deux pointent vers le même service !
```

### Avec Kind/Minikube

```bash
# Kind - localhost fonctionne (avec extraPortMappings)
curl http://localhost:31200/

# Minikube - utiliser l'IP de minikube
minikube ip
curl http://$(minikube ip):31200/
```

## 🐳 Configuration spéciale pour Kind

### Problème avec Kind

Par défaut, Kind tourne dans Docker et les ports NodePort ne sont **pas accessibles** depuis l'hôte.

### Solution : extraPortMappings

```yaml
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 31200   # Port NodePort
        hostPort: 31200        # Port sur l'hôte
        protocol: TCP
```

```bash
# Créer le cluster avec la configuration
kind create cluster --config kind-config.yaml
```

### Résultat avec Kind

```bash
# ✅ Fonctionne maintenant
curl http://localhost:31200/
```

## 🔧 Debug NodePort

### Vérifier le service

```bash
# Voir les services NodePort
kubectl get svc --all-namespaces | grep NodePort

# Détails du service
kubectl describe svc webapp-service -n webapp-namespace
```

### Vérifier les nœuds

```bash
# Lister les nœuds et leurs IPs
kubectl get nodes -o wide

# Vérifier qu'un port est ouvert
nmap -p 31200 <NODE-IP>
```

### Tester la connectivité

```bash
# Test local (dans le cluster)
kubectl run test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://webapp-service.webapp-namespace:8080

# Test externe
curl http://<NODE-IP>:31200/
```

## 🚨 Limitations et Problèmes

### 1. **Plage de ports limitée**

```yaml
# ❌ Erreur - en dehors de la plage
nodePort: 8080  # Doit être entre 30000-32767
```

### 2. **Sécurité**

- Expose des ports sur **tous les nœuds**
- Difficile à sécuriser en production
- Pas de terminaison SSL native

### 3. **Load Balancing**

- Dépend de l'implémentation du client
- Pas de health checks avancés
- Distribution simple round-robin

### 4. **Gestion des IPs**

```bash
# Problème : Les IPs des nœuds peuvent changer
kubectl get nodes -o wide
NAME     STATUS   ROLES    AGE   VERSION   INTERNAL-IP   EXTERNAL-IP
node-1   Ready    master   1d    v1.21.0   10.0.0.10     203.0.113.10
node-2   Ready    worker   1d    v1.21.0   10.0.0.11     203.0.113.11
```

## 💡 Bonnes Pratiques

### 1. **Spécifiez toujours le nodePort en développement**

```yaml
# ✅ Prévisible et documenté
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 31200
```

### 2. **Utilisez des ranges cohérents**

```yaml
# Organisation par équipe/projet
# Frontend: 31000-31099
# Backend: 31100-31199
# Database: 31200-31299
```

### 3. **Documentation**

```yaml
metadata:
  name: webapp-service
  annotations:
    description: "Service NodePort pour développement"
    nodeport.url: "http://localhost:31200"
    environment: "development"
```

## 📊 Exemple complet de développement

```yaml
# dev-deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-dev
  namespace: development
  labels:
    app: webapp
    env: dev
spec:
  replicas: 1  # Un seul pod en dev
  selector:
    matchLabels:
      app: webapp
      env: dev
  template:
    metadata:
      labels:
        app: webapp
        env: dev
    spec:
      containers:
      - name: webapp
        image: nginx:latest
        ports:
        - containerPort: 80
        env:
        - name: ENV
          value: "development"

---
# dev-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-dev-service
  namespace: development
  annotations:
    description: "Service de développement accessible sur localhost:31200"
spec:
  type: NodePort
  selector:
    app: webapp
    env: dev
  ports:
    - name: http
      port: 80
      targetPort: 80
      nodePort: 31200
```

## 🔄 Migration vers LoadBalancer

Quand vous passez en production :

```yaml
# ❌ Développement
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 31200

# ✅ Production
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 8080
  # nodePort supprimé !
```

## 🎯 Résumé

**NodePort** est parfait pour :
- 🛠️ **Développement** : Accès rapide et simple
- 🧪 **Tests** : Vérification des fonctionnalités
- 📚 **Apprentissage** : Comprendre les concepts Kubernetes
- 🐳 **Environnements locaux** : Kind, Minikube

**Mais évitez en production !** Utilisez LoadBalancer + Ingress à la place.