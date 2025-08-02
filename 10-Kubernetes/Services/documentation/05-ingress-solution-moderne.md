# 🚪 Ingress : La Solution Moderne pour la Production

## 🎯 Qu'est-ce qu'Ingress ?

**Ingress** n'est pas un Service, mais un objet Kubernetes qui gère l'accès HTTP/HTTPS externe aux services. Il agit comme un **reverse proxy intelligent** et permet d'économiser sur les coûts de load balancers multiples.

### 🔄 Ingress vs LoadBalancer

```yaml
# ❌ Approche coûteuse : 3 LoadBalancers
Service 1 (LoadBalancer) → $18/mois
Service 2 (LoadBalancer) → $18/mois  
Service 3 (LoadBalancer) → $18/mois
Total: $54/mois

# ✅ Approche moderne : 1 LoadBalancer + Ingress
Ingress Controller (LoadBalancer) → $18/mois
├─ Service 1 (ClusterIP) → $0
├─ Service 2 (ClusterIP) → $0
└─ Service 3 (ClusterIP) → $0
Total: $18/mois
```

## 🏗️ Architecture Ingress

```
Internet
    ↓
┌─────────────────────────┐
│   Cloud Load Balancer   │
│   (1 seule IP publique) │
└─────────────────────────┘
    ↓
┌─────────────────────────────────────────────────────────────┐
│                      CLUSTER                               │
│                                                             │
│ ┌─────────────────────────┐                                │
│ │   Ingress Controller    │                                │
│ │   (nginx/traefik/...)   │                                │
│ └─────────────────────────┘                                │
│              ↓                                             │
│    ┌─────────┼─────────┬─────────────┐                     │
│    ↓         ↓         ↓             ↓                     │
│ [Service 1]  [Service 2]  [Service 3]  [Service 4]        │
│ (ClusterIP)  (ClusterIP)  (ClusterIP)  (ClusterIP)        │
│     ↓            ↓           ↓            ↓                │
│ [Pod 1]      [Pod 2]     [Pod 3]      [Pod 4]             │
└─────────────────────────────────────────────────────────────┘
```

## 📝 Configuration Ingress

### 1. Installation d'un Ingress Controller

#### NGINX Ingress Controller (le plus populaire)

```bash
# Installation via Helm
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace

# Ou via kubectl
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
```

#### Traefik (alternative moderne)

```bash
helm repo add traefik https://traefik.github.io/charts
helm install traefik traefik/traefik \
  --namespace traefik-system \
  --create-namespace
```

### 2. Configuration Ingress de base

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ingress
  namespace: production
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  # Classe d'ingress (optionnel si une seule)
  ingressClassName: nginx
  
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-service
            port:
              number: 80
```

## 🌐 Routage Avancé

### 1. **Routage par domaine**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: multi-domain-ingress
spec:
  ingressClassName: nginx
  rules:
  # Site principal
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  
  # API
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
  
  # Dashboard admin
  - host: admin.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 3000
```

### 2. **Routage par chemin**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: path-based-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /$2
spec:
  ingressClassName: nginx
  rules:
  - host: example.com
    http:
      paths:
      # Frontend
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
      
      # API v1
      - path: /api/v1(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: api-v1-service
            port:
              number: 8080
      
      # API v2
      - path: /api/v2(/|$)(.*)
        pathType: ImplementationSpecific
        backend:
          service:
            name: api-v2-service
            port:
              number: 8080
      
      # Documentation
      - path: /docs
        pathType: Prefix
        backend:
          service:
            name: docs-service
            port:
              number: 80
```

## 🔒 SSL/TLS avec Ingress

### 1. **SSL automatique avec cert-manager**

```bash
# Installation de cert-manager
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.13.2/cert-manager.yaml

# Attendre que cert-manager soit prêt
kubectl wait --for=condition=Available --timeout=300s deployment/cert-manager -n cert-manager
```

### 2. **Configuration Let's Encrypt**

```yaml
# cluster-issuer.yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@example.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

### 3. **Ingress avec SSL automatique**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ssl-ingress
  annotations:
    # Issuer pour les certificats
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    
    # Redirection HTTP vers HTTPS
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    
    # Force HTTPS
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
spec:
  ingressClassName: nginx
  
  # Configuration TLS
  tls:
  - hosts:
    - www.example.com
    - api.example.com
    secretName: example-com-tls  # Certificat généré automatiquement
  
  rules:
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

## ⚡ Fonctionnalités Avancées

### 1. **Load Balancing avec poids**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: canary-ingress
  annotations:
    # Déploiement canary - 10% sur la nouvelle version
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
spec:
  ingressClassName: nginx
  rules:
  - host: example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-v2-service  # Nouvelle version
            port:
              number: 80
```

### 2. **Rate Limiting**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: rate-limited-ingress
  annotations:
    # Limite de taux
    nginx.ingress.kubernetes.io/rate-limit: "100"  # 100 requêtes/minute
    nginx.ingress.kubernetes.io/rate-limit-burst: "50"  # Burst de 50
    
    # Limite par IP
    nginx.ingress.kubernetes.io/rate-limit-rps: "10"  # 10 req/sec par IP
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

### 3. **Authentification basique**

```yaml
# Créer un secret avec les credentials
kubectl create secret generic basic-auth \
  --from-literal=auth='user:$2y$10$...'  # htpasswd hash

apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: protected-ingress
  annotations:
    # Authentification basique
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: basic-auth
    nginx.ingress.kubernetes.io/auth-realm: 'Authentication Required'
spec:
  ingressClassName: nginx
  rules:
  - host: admin.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: admin-service
            port:
              number: 80
```

### 4. **CORS et Headers**

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: cors-ingress
  annotations:
    # CORS
    nginx.ingress.kubernetes.io/enable-cors: "true"
    nginx.ingress.kubernetes.io/cors-allow-origin: "https://myapp.com,https://admin.myapp.com"
    nginx.ingress.kubernetes.io/cors-allow-methods: "GET, POST, PUT, DELETE, OPTIONS"
    nginx.ingress.kubernetes.io/cors-allow-headers: "Authorization,Content-Type,Accept,Origin,User-Agent,Cache-Control"
    
    # Headers personnalisés
    nginx.ingress.kubernetes.io/configuration-snippet: |
      add_header X-Frame-Options "SAMEORIGIN" always;
      add_header X-Content-Type-Options "nosniff" always;
      add_header Referrer-Policy "strict-origin-when-cross-origin" always;
spec:
  ingressClassName: nginx
  rules:
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

## 🔧 Monitoring et Debug

### 1. **Vérifier l'Ingress Controller**

```bash
# Statut de l'ingress controller
kubectl get pods -n ingress-nginx

# Logs de l'ingress controller
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller

# Service de l'ingress controller
kubectl get svc -n ingress-nginx
```

### 2. **Vérifier les ressources Ingress**

```bash
# Lister tous les ingress
kubectl get ingress --all-namespaces

# Détails d'un ingress
kubectl describe ingress webapp-ingress -n production

# Vérifier les endpoints
kubectl get endpoints -n production
```

### 3. **Tests de connectivité**

```bash
# Test DNS
nslookup myapp.example.com

# Test HTTP
curl -H "Host: myapp.example.com" http://<INGRESS-IP>/

# Test HTTPS
curl -H "Host: myapp.example.com" https://<INGRESS-IP>/

# Headers de debug
curl -I https://myapp.example.com/
```

## 💡 Bonnes Pratiques

### 1. **Organisation des Ingress**

```yaml
# ✅ Un Ingress par namespace/application
# production-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: production-ingress
  namespace: production
spec:
  # Configuration production...

# staging-ingress.yaml  
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: staging-ingress
  namespace: staging
spec:
  # Configuration staging...
```

### 2. **DNS et wildcard certificates**

```yaml
# Certificat wildcard pour tous les sous-domaines
tls:
- hosts:
  - "*.example.com"
  - "example.com"
  secretName: wildcard-example-com-tls
```

### 3. **Monitoring et alertes**

```yaml
metadata:
  annotations:
    # Monitoring
    prometheus.io/scrape: "true"
    prometheus.io/path: "/metrics"
    
    # Alertes
    alert.example.com/team: "platform"
    alert.example.com/severity: "critical"
```

## 📊 Exemple de Production Complète

```yaml
# 01-services.yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: production
spec:
  type: ClusterIP  # Pas LoadBalancer !
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 3000

---
apiVersion: v1
kind: Service
metadata:
  name: api-service
  namespace: production
spec:
  type: ClusterIP
  selector:
    app: api
  ports:
    - port: 8080
      targetPort: 8080

---
# 02-ingress.yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: production-ingress
  namespace: production
  annotations:
    # SSL automatique
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    
    # Performance
    nginx.ingress.kubernetes.io/proxy-body-size: "10m"
    nginx.ingress.kubernetes.io/proxy-read-timeout: "60"
    nginx.ingress.kubernetes.io/proxy-send-timeout: "60"
    
    # Sécurité
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/force-ssl-redirect: "true"
    
    # Rate limiting
    nginx.ingress.kubernetes.io/rate-limit: "1000"
    nginx.ingress.kubernetes.io/rate-limit-burst: "2000"
    
    # Monitoring
    nginx.ingress.kubernetes.io/enable-metrics: "true"
spec:
  ingressClassName: nginx
  
  tls:
  - hosts:
    - www.example.com
    - api.example.com
    secretName: example-com-tls
  
  rules:
  # Frontend
  - host: www.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  
  # API
  - host: api.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: api-service
            port:
              number: 8080
      
      # Health check séparé
      - path: /health
        pathType: Exact
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

## 🎯 Résumé

**Ingress** est la solution moderne pour :
- 💰 **Économies** : 1 LoadBalancer au lieu de N
- 🌐 **Routage intelligent** : Par domaine, chemin, headers
- 🔒 **SSL automatique** : Avec Let's Encrypt
- ⚡ **Fonctionnalités avancées** : Rate limiting, CORS, auth
- 📊 **Observabilité** : Metrics et logs centralisés

**Ingress + ClusterIP = Architecture de production moderne !**