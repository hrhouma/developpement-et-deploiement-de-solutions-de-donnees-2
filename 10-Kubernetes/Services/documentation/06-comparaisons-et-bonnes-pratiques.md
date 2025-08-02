# Comparaison et Bonnes Pratiques : Services Kubernetes

## Récapitulatif complet des Types de Services Kubernetes

| Type             | Usage Principal       | Accessibilité            | Coût              | Environnement          |
| ---------------- | --------------------- | ------------------------ | ----------------- | ---------------------- |
| **ClusterIP**    | Communication interne | Interne au cluster       | Gratuit           | Tous                   |
| **NodePort**     | Développement/Test    | IP du nœud + Port exposé | Gratuit           | Local (Kind, Minikube) |
| **LoadBalancer** | Production simple     | IP publique              | \~18\$/mois/LB    | Cloud                  |
| **Ingress**      | Production avancée    | IP publique unique       | \~18\$/mois total | Tous (avec controller) |

---

## Architectures Recommandées selon l'environnement

### Développement local (Kind/Minikube)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: dev-service
spec:
  type: NodePort
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 31200
  selector:
    app: dev-app
```

**Avantages :**

* Simplicité d’accès local
* Facilité de configuration pour le développement rapide

---

### Environnement Test/Staging avec Ingress sécurisé

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: staging-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-staging"
    nginx.ingress.kubernetes.io/auth-type: basic
    nginx.ingress.kubernetes.io/auth-secret: staging-auth
spec:
  ingressClassName: nginx
  tls:
    - hosts:
      - staging.example.com
      secretName: staging-tls
  rules:
    - host: staging.example.com
      http:
        paths:
          - path: /
            backend:
              service:
                name: staging-service
                port:
                  number: 80
```

**Avantages :**

* Simule l'environnement de production
* SSL et authentification pour sécurité accrue

---

### Production Cloud (AWS/Azure/GCP) avec Ingress

```yaml
# Service backend en ClusterIP
apiVersion: v1
kind: Service
metadata:
  name: api-service
spec:
  type: ClusterIP
  selector:
    app: api
  ports:
    - port: 8080
      targetPort: 8080

---
# Ingress pour gestion avancée (SSL, rate limit)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: prod-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/rate-limit: "500"
spec:
  ingressClassName: nginx
  tls:
    - hosts:
      - api.example.com
      secretName: api-example-tls
  rules:
    - host: api.example.com
      http:
        paths:
          - path: /
            backend:
              service:
                name: api-service
                port:
                  number: 8080
```

**Avantages :**

* Réduction des coûts avec une seule IP publique
* Sécurité intégrée (SSL, gestion des accès)
* Routage flexible

---

## Comment choisir le bon service Kubernetes (Flowchart)

* **Service interne uniquement ?** → **ClusterIP**
* **Développement local ?** → **NodePort**
* **Production Cloud (un seul service) ?** → **LoadBalancer**
* **Production Cloud (plusieurs services) ?** → **Ingress**
* **On-premise (sans cloud) ?**

  * Avec MetalLB → **LoadBalancer**
  * Sans MetalLB → **Ingress**

---

## Bonnes pratiques universelles en détails

### 1. Nommage clair et descriptif

```yaml
metadata:
  name: payment-api-service
  labels:
    app: payment-api
    component: backend
    version: v1.0.1
```

---

### 2. Labels et sélecteurs explicites

```yaml
# Bon exemple
spec:
  selector:
    app: frontend
    tier: web
    env: production

# À éviter
spec:
  selector:
    app: app1
```

---

### 3. Documentation intégrée avec annotations

```yaml
metadata:
  annotations:
    description: "API de gestion des paiements"
    documentation: "https://docs.example.com/payment-api"
    responsable: "team-backend"
```

---

### 4. Health Checks systématiques sur les pods

```yaml
containers:
  - name: webapp
    image: example/webapp:latest
    readinessProbe:
      httpGet:
        path: /ready
        port: 8080
    livenessProbe:
      httpGet:
        path: /health
        port: 8080
```

---

### 5. Organisation claire des namespaces

```yaml
# Namespace production
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: production
spec:
  type: ClusterIP
```

---

## Sécurité : Bonnes pratiques essentielles

### Limiter l'accès par IP

```yaml
spec:
  loadBalancerSourceRanges:
    - "203.0.113.0/24"
    - "198.51.100.0/24"
```

### Utiliser Network Policies pour protéger les pods

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: allow-from-frontend
spec:
  podSelector:
    matchLabels:
      app: backend
  ingress:
    - from:
        - podSelector:
            matchLabels:
              app: frontend
```

---

## Observabilité : Monitoring et Logs centralisés

### Collecte des métriques

```yaml
metadata:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
```

### Tracing distribué avec Jaeger

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/enable-opentracing: "true"
    nginx.ingress.kubernetes.io/jaeger-collector-host: "jaeger.tracing:14268"
```

---

## Patterns de déploiement recommandés

### Blue-Green Deployment

```yaml
spec:
  selector:
    app: frontend
    version: "blue"  # Changez pour "green" lors du déploiement
```

### Déploiement Canary progressif avec Ingress

```yaml
annotations:
  nginx.ingress.kubernetes.io/canary: "true"
  nginx.ingress.kubernetes.io/canary-weight: "10"
```

---

## Outils pratiques et scripts utiles

### Script Bash de debug rapide

```bash
#!/bin/bash
SERVICE=$1
NAMESPACE=${2:-default}

echo "Service info :"
kubectl get svc $SERVICE -n $NAMESPACE

echo "Endpoints :"
kubectl get endpoints $SERVICE -n $NAMESPACE

echo "Test de connectivité :"
kubectl run -it --rm debug-pod --image=busybox --restart=Never --namespace=$NAMESPACE -- wget -qO- http://$SERVICE
```

---

## Checklist complète avant mise en production

* [ ] Services définis avec le type approprié
* [ ] Ingress Controller installé et opérationnel
* [ ] SSL configuré et validé
* [ ] Health checks activés sur tous les pods
* [ ] Monitoring en place (Prometheus, Grafana)
* [ ] Logs structurés activés et centralisés
* [ ] Network policies activées
* [ ] Load tests réalisés et validés

---

## Signaux d'alerte à surveiller

* LoadBalancer en attente prolongée (pending)
* Services sans endpoints actifs
* Erreurs fréquentes de type 5xx (503, 504)
* Consommation élevée CPU/mémoire non expliquée
* Certificats SSL expirés ou invalides

---

## Conclusion finale : stratégie claire pour la réussite Kubernetes

1. **Commencez simplement** avec ClusterIP et NodePort.
2. **Évoluez intelligemment** vers LoadBalancer puis Ingress.
3. **Sécurisez par défaut** avec SSL, Network Policies.
4. **Mesurez et observez** dès le début pour une maintenance aisée.

Votre architecture Kubernetes sera alors performante, fiable, économique et sécurisée, prête pour toute charge et tout défi opérationnel.



**Bonne maîtrise de Kubernetes !**
