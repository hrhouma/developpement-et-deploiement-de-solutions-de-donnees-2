# 🔒 ClusterIP : Le Service par Défaut

## 🎯 Qu'est-ce que ClusterIP ?

**ClusterIP** est le type de service **par défaut** dans Kubernetes. Il rend le service accessible **uniquement à l'intérieur du cluster**.

### ✅ Quand l'utiliser ?

- ✅ **Communication entre microservices**
- ✅ **APIs internes**
- ✅ **Bases de données**
- ✅ **Services backend** qui n'ont pas besoin d'être exposés

### ❌ Quand NE PAS l'utiliser ?

- ❌ **Applications web front-end**
- ❌ **APIs publiques**
- ❌ **Services qui doivent être accessibles depuis l'extérieur**

## 📝 Configuration

### Exemple basique

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: production
spec:
  type: ClusterIP  # Optionnel (c'est le défaut)
  selector:
    app: backend
    version: v1
  ports:
    - port: 8080        # Port du service
      targetPort: 3000   # Port du conteneur
      protocol: TCP
```

### Exemple avec nom de port

```yaml
apiVersion: v1
kind: Service
metadata:
  name: database-service
spec:
  selector:
    app: postgres
  ports:
    - name: postgres
      port: 5432
      targetPort: postgres  # Nom du port dans le pod
```

## 🏗️ Architecture typique

```
┌─────────────────────────────────────────┐
│                CLUSTER                  │
│                                         │
│  [Frontend Pod] ──→ [Backend Service]   │
│                     ↓                   │
│                   [Backend Pod 1]       │
│                   [Backend Pod 2]       │
│                   [Backend Pod 3]       │
│                                         │
│  [Backend Pod] ──→ [Database Service]   │
│                     ↓                   │
│                   [Database Pod]        │
└─────────────────────────────────────────┘
```

## 🌐 Accès au Service

### Depuis un Pod dans le même namespace

```bash
# Via le nom du service
curl http://backend-service:8080/api/users

# Via DNS complet
curl http://backend-service.production.svc.cluster.local:8080/api/users
```

### Depuis un Pod dans un autre namespace

```bash
# DNS complet obligatoire
curl http://backend-service.production.svc.cluster.local:8080/api/users
```

## 🔍 Variables d'environnement automatiques

Kubernetes injecte automatiquement des variables d'environnement :

```bash
# Pour le service "backend-service" sur le port 8080
BACKEND_SERVICE_SERVICE_HOST=10.96.45.23
BACKEND_SERVICE_SERVICE_PORT=8080
BACKEND_SERVICE_PORT_8080_TCP=tcp://10.96.45.23:8080
BACKEND_SERVICE_PORT_8080_TCP_ADDR=10.96.45.23
BACKEND_SERVICE_PORT_8080_TCP_PORT=8080
BACKEND_SERVICE_PORT_8080_TCP_PROTO=tcp
```

## 💡 Bonnes Pratiques

### 1. Nommage cohérent

```yaml
# ✅ Bon
metadata:
  name: user-api-service
spec:
  selector:
    app: user-api

# ❌ Éviter
metadata:
  name: svc-1
spec:
  selector:
    app: some-random-app
```

### 2. Utilisez des labels descriptifs

```yaml
spec:
  selector:
    app: user-api
    version: v2
    tier: backend
    environment: production
```

### 3. Définissez des ports nommés

```yaml
ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: metrics
    port: 9090
    targetPort: metrics
```

## 🧪 Test et Debug

### Vérifier le service

```bash
# Lister les services
kubectl get svc -n production

# Détails du service
kubectl describe svc backend-service -n production

# Vérifier les endpoints
kubectl get endpoints backend-service -n production
```

### Test depuis un pod temporaire

```bash
# Créer un pod de test
kubectl run test-pod --image=busybox --rm -it --restart=Never -- sh

# Dans le pod
wget -qO- http://backend-service:8080/health
```

## 📊 Exemple complet avec Deployment

```yaml
# deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: user-api
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: user-api
  template:
    metadata:
      labels:
        app: user-api
        version: v1
    spec:
      containers:
      - name: api
        image: user-api:1.2.0
        ports:
        - name: http
          containerPort: 8080
        - name: metrics
          containerPort: 9090

---
# service.yaml
apiVersion: v1
kind: Service
metadata:
  name: user-api-service
  namespace: production
spec:
  selector:
    app: user-api
  ports:
    - name: http
      port: 80
      targetPort: http
    - name: metrics
      port: 9090
      targetPort: metrics
```

## 🎯 Résumé

**ClusterIP** est parfait pour :
- 🔒 **Sécurité** : Pas d'exposition externe accidentelle
- 🚀 **Performance** : Communication directe dans le cluster
- 🏗️ **Architecture microservices** : APIs internes, bases de données
- 💰 **Coût** : Pas de resources cloud supplémentaires

C'est le **fondement** de la communication interne dans Kubernetes !