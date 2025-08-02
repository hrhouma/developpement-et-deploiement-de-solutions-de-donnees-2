# ⚖️ LoadBalancer : Service de Production

## 🎯 Qu'est-ce que LoadBalancer ?

**LoadBalancer** est le type de service conçu pour la **production** dans les environnements cloud. Il provisionne automatiquement un load balancer externe avec une **IP publique**.

### ✅ Quand l'utiliser ?

- ✅ **Production sur cloud** (AWS, Azure, GCP)
- ✅ **Applications publiques**
- ✅ **APIs exposées** à l'internet
- ✅ **Haute disponibilité** requise
- ✅ **Terminaison SSL** nécessaire

### ❌ Quand NE PAS l'utiliser ?

- ❌ **Développement local** (Kind, Minikube)
- ❌ **Environnements on-premise** sans support cloud
- ❌ **Services internes** au cluster
- ❌ **Quand vous voulez économiser** (coût des LB cloud)

## 🏗️ Architecture LoadBalancer

```
Internet
    ↓
┌─────────────────────────┐
│   Cloud Load Balancer   │  ← Provisionné automatiquement
│   (IP Publique)         │
└─────────────────────────┘
    ↓
┌─────────────────────────────────────────────┐
│                CLUSTER                      │
│                                             │
│ [Service LoadBalancer] ──→ [Pod 1]          │
│                        ──→ [Pod 2]          │
│                        ──→ [Pod 3]          │
└─────────────────────────────────────────────┘
```

## 📝 Configuration

### Exemple basique

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-production
  namespace: production
spec:
  type: LoadBalancer
  selector:
    app: webapp
    tier: frontend
  ports:
    - name: http
      port: 80
      targetPort: 8080
      protocol: TCP
    - name: https
      port: 443
      targetPort: 8080
      protocol: TCP
```

### Avec annotations cloud-spécifiques

#### AWS (ELB)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-aws
  annotations:
    # Type de load balancer
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    
    # Schéma (internet-facing ou internal)
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    
    # Certificat SSL
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:us-east-1:123456789:certificate/12345"
    
    # Backend protocol
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    
    # Health check
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: "/health"
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
    - port: 443
      targetPort: 8080
```

#### Azure (AKS)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-azure
  annotations:
    # IP publique statique
    service.beta.kubernetes.io/azure-load-balancer-resource-group: "myResourceGroup"
    
    # Type de load balancer
    service.beta.kubernetes.io/azure-load-balancer-sku: "standard"
    
    # IP spécifique
    loadbalancer.openstack.org/floating-network-id: "12345"
spec:
  type: LoadBalancer
  loadBalancerIP: "203.0.113.100"  # IP souhaitée
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 8080
```

#### Google Cloud (GKE)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-gcp
  annotations:
    # Type de load balancer
    cloud.google.com/load-balancer-type: "External"
    
    # Négociation automatique des certificats
    networking.gke.io/managed-certificates: "webapp-ssl-cert"
    
    # Backend config
    cloud.google.com/backend-config: '{"ports": {"80":"my-backend-config"}}'
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 8080
```

## 🔍 États du LoadBalancer

### Cycle de vie

```bash
# 1. Création du service
kubectl apply -f loadbalancer-service.yaml

# 2. État initial - En attente
kubectl get svc
NAME            TYPE           EXTERNAL-IP   PORT(S)
webapp-service  LoadBalancer   <pending>     80:32156/TCP

# 3. Provisioning du LB cloud (peut prendre 2-5 minutes)
kubectl get svc
NAME            TYPE           EXTERNAL-IP   PORT(S)
webapp-service  LoadBalancer   <pending>     80:32156/TCP

# 4. LB prêt - IP assignée
kubectl get svc
NAME            TYPE           EXTERNAL-IP      PORT(S)
webapp-service  LoadBalancer   203.0.113.100    80:32156/TCP
```

## 🐳 Comportement dans différents environnements

### ✅ Cloud Providers (AWS, Azure, GCP)

```bash
# Le service obtient une IP publique
kubectl get svc webapp-service
NAME            TYPE           EXTERNAL-IP      PORT(S)
webapp-service  LoadBalancer   203.0.113.100    80:30123/TCP

# Accessible depuis internet
curl http://203.0.113.100/
```

### ❌ Kind/Minikube (sans support cloud)

```bash
# Reste en pending indéfiniment
kubectl get svc webapp-service
NAME            TYPE           EXTERNAL-IP   PORT(S)
webapp-service  LoadBalancer   <pending>     80:30123/TCP

# Solution: Utiliser NodePort à la place
```

### 🔧 On-premise avec MetalLB

```bash
# Installation de MetalLB (émulateur de LoadBalancer)
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# Configuration d'un pool d'IPs
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: production-pool
  namespace: metallb-system
spec:
  addresses:
  - 192.168.1.240-192.168.1.250
```

## 🚨 Problèmes courants et Solutions

### 1. **LoadBalancer reste en `<pending>`**

```bash
# Diagnostic
kubectl describe svc webapp-service

# Causes possibles:
# ❌ Pas dans un environnement cloud
# ❌ Quotas cloud atteints
# ❌ Permissions insuffisantes
# ❌ Région non supportée
```

**Solutions :**

```yaml
# Option 1: Passer à NodePort temporairement
spec:
  type: NodePort
  
# Option 2: Installer MetalLB (on-premise)
# Option 3: Utiliser Ingress à la place
```

### 2. **Coûts élevés**

```bash
# Chaque LoadBalancer = facturation cloud séparée
# AWS ELB: ~$18/mois par LB
# Azure LB: ~$18/mois par LB
# GCP LB: ~$18/mois par LB
```

**Solution : Ingress Controller**

```yaml
# ❌ 3 LoadBalancers = 3 × $18/mois
apiVersion: v1
kind: Service
metadata:
  name: service-1
spec:
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  name: service-2
spec:
  type: LoadBalancer
---
apiVersion: v1
kind: Service
metadata:
  name: service-3
spec:
  type: LoadBalancer

# ✅ 1 LoadBalancer + Ingress = $18/mois
# (Voir fichier 05-ingress)
```

### 3. **SSL/TLS**

```yaml
# ❌ SSL géré manuellement
apiVersion: v1
kind: Service
metadata:
  name: webapp
spec:
  type: LoadBalancer
  ports:
    - port: 443
      targetPort: 443  # App doit gérer SSL

# ✅ SSL géré par le cloud provider
apiVersion: v1
kind: Service
metadata:
  name: webapp
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:..."
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
spec:
  type: LoadBalancer
  ports:
    - port: 443
      targetPort: 8080  # App en HTTP, SSL terminé au LB
```

## 💡 Bonnes Pratiques

### 1. **Utilisez des IP statiques**

```yaml
# AWS
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-eip-allocations: "eipalloc-12345,eipalloc-67890"

# Azure
spec:
  loadBalancerIP: "203.0.113.100"

# GCP
metadata:
  annotations:
    cloud.google.com/load-balancer-static-ip: "my-static-ip"
```

### 2. **Configurez les health checks**

```yaml
metadata:
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: "/health"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-interval: "10"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-timeout: "5"
    service.beta.kubernetes.io/aws-load-balancer-healthy-threshold: "2"
    service.beta.kubernetes.io/aws-load-balancer-unhealthy-threshold: "3"
```

### 3. **Limitation d'accès**

```yaml
spec:
  loadBalancerSourceRanges:
    - "203.0.113.0/24"  # Votre bureau
    - "198.51.100.0/24" # VPN d'entreprise
```

### 4. **Labels et monitoring**

```yaml
metadata:
  name: webapp-production
  labels:
    app: webapp
    tier: frontend
    environment: production
    cost-center: "engineering"
  annotations:
    monitoring.io/scrape: "true"
    owner: "team-frontend"
```

## 📊 Exemple de Production Complet

```yaml
# production-app.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-production
  namespace: production
spec:
  replicas: 3
  selector:
    matchLabels:
      app: webapp
      version: v1.2.0
  template:
    metadata:
      labels:
        app: webapp
        version: v1.2.0
    spec:
      containers:
      - name: webapp
        image: mycompany/webapp:1.2.0
        ports:
        - name: http
          containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 30
          periodSeconds: 10
        readinessProbe:
          httpGet:
            path: /ready
            port: 8080
          initialDelaySeconds: 5
          periodSeconds: 5

---
# production-service.yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-production-service
  namespace: production
  labels:
    app: webapp
    environment: production
  annotations:
    # AWS LoadBalancer Configuration
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:us-east-1:123456789:certificate/abcd-1234"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
    service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: "/health"
    
    # Monitoring
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    
    # Documentation
    description: "Production LoadBalancer for webapp"
    owner: "platform-team"
spec:
  type: LoadBalancer
  selector:
    app: webapp
    version: v1.2.0
  ports:
    - name: https
      port: 443
      targetPort: 8080
      protocol: TCP
  loadBalancerSourceRanges:
    - "0.0.0.0/0"  # Ouvert à internet (ajustez selon vos besoins)
```

## 🔄 Migration et Déploiement

### Stratégie Blue-Green

```yaml
# Service principal (Blue)
apiVersion: v1
kind: Service
metadata:
  name: webapp-production
spec:
  type: LoadBalancer
  selector:
    app: webapp
    version: v1.1.0  # Version actuelle
  ports:
    - port: 443
      targetPort: 8080

# Pendant le déploiement, changer le sélecteur:
# selector:
#   app: webapp
#   version: v1.2.0  # Nouvelle version
```

## 🎯 Résumé

**LoadBalancer** est la solution de production pour :
- 🌐 **Exposition internet** : IP publique automatique
- ⚖️ **Load balancing** : Distribution intelligente
- 🔒 **SSL/TLS** : Terminaison au load balancer
- 📊 **Monitoring** : Intégration cloud native
- 🚀 **Scalabilité** : Gestion automatique du trafic

**Mais attention aux coûts !** Considérez Ingress pour multiples services.