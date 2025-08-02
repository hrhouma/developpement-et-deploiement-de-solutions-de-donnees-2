# Cours 4 : LoadBalancer – Service Kubernetes pour la Production (Cloud)

## Qu'est-ce qu'un service LoadBalancer ?

Un **LoadBalancer** est un type de service Kubernetes spécialement conçu pour déployer des applications en production sur des environnements cloud comme AWS, Azure ou Google Cloud. Il permet d'exposer automatiquement un ensemble de pods à l'internet à travers une adresse IP publique fournie par le cloud provider.

---

## Quand utiliser LoadBalancer ?

* **Environnement de production cloud** : AWS, Azure, Google Cloud.
* **Applications accessibles publiquement** : sites web, services API.
* **Haute disponibilité** : répartition automatique du trafic.
* **Sécurité SSL/TLS intégrée** : gestion simplifiée des certificats.

---

## Quand éviter LoadBalancer ?

* **Développement local** : Minikube, Kind (préférez NodePort).
* **Infrastructures internes sans cloud** : privilégiez NodePort ou MetalLB.
* **Services strictement internes** : utilisez ClusterIP.
* **Budget limité** : chaque LoadBalancer génère des coûts.

---

## Architecture simple d'un LoadBalancer

```
Internet (IP Publique)
           │
┌─────────────────────────┐
│ Cloud Load Balancer     │ (fourni par le cloud provider)
└─────────────────────────┘
           │
┌────────────────────────────────────┐
│ Cluster Kubernetes                 │
│                                    │
│ [Service LoadBalancer] ──→ Pod 1   │
│                        ──→ Pod 2   │
│                        ──→ Pod 3   │
└────────────────────────────────────┘
```

---

## Exemples détaillés de configurations

### Exemple basique

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  namespace: production
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 8080
      protocol: TCP
```

---

### Configuration avancée par cloud provider

#### AWS (ELB/NLB)

```yaml
apiVersion: v1
kind: Service
metadata:
  name: aws-webapp-service
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-scheme: "internet-facing"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:region:account-id:certificate/cert-id"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
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
  name: azure-webapp-service
  annotations:
    service.beta.kubernetes.io/azure-load-balancer-sku: "standard"
spec:
  type: LoadBalancer
  loadBalancerIP: "203.0.113.100"
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
  name: gcp-webapp-service
  annotations:
    cloud.google.com/load-balancer-type: "External"
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 8080
```

---

## Cycle de vie d’un LoadBalancer

```bash
kubectl apply -f service-lb.yaml

# Initialement
kubectl get svc
NAME            TYPE           EXTERNAL-IP    PORT(S)
webapp-service  LoadBalancer   <pending>      80:30080/TCP

# Après 2-5 min (provisionnement terminé)
kubectl get svc
NAME            TYPE           EXTERNAL-IP      PORT(S)
webapp-service  LoadBalancer   203.0.113.100    80:30080/TCP
```

---

## Debug et problèmes fréquents

### LoadBalancer reste en "pending"

**Causes :**

* Hors environnement cloud.
* Quotas cloud atteints.
* Problèmes d'autorisation IAM.

**Solution temporaire :**

* Basculer vers NodePort ou installer MetalLB pour environnement local.

---

## Gestion des coûts du LoadBalancer

Chaque LoadBalancer public engendre un coût cloud mensuel (environ 18\$/mois par LB sur AWS, Azure, GCP).

**Solution économique : utiliser un Ingress Controller**

```yaml
# Plusieurs services via un seul LoadBalancer :
LoadBalancer (unique) → Ingress → Service1, Service2, Service3
```

---

## SSL et LoadBalancer

Configuration recommandée (SSL terminé sur le LoadBalancer cloud) :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-ssl
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:region:account-id:certificate/cert-id"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
spec:
  type: LoadBalancer
  ports:
    - port: 443
      targetPort: 8080
```

---

## Bonnes pratiques recommandées

### 1. IP publique statique

```yaml
# Azure
spec:
  loadBalancerIP: "203.0.113.100"

# GCP
metadata:
  annotations:
    cloud.google.com/load-balancer-static-ip: "static-ip-name"
```

### 2. Sécurité (restriction des sources)

```yaml
spec:
  loadBalancerSourceRanges:
    - "203.0.113.0/24"
    - "198.51.100.0/24"
```

### 3. Health Checks précis

```yaml
annotations:
  service.beta.kubernetes.io/aws-load-balancer-healthcheck-path: "/health"
```

---

## Exemple complet en contexte de production

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: prod-webapp
  namespace: production
spec:
  replicas: 3
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
        image: myapp/webapp:v1.2.0
        ports:
        - containerPort: 8080
        livenessProbe:
          httpGet:
            path: /health
            port: 8080
          initialDelaySeconds: 15
          periodSeconds: 10

---
apiVersion: v1
kind: Service
metadata:
  name: webapp-lb
  namespace: production
  annotations:
    service.beta.kubernetes.io/aws-load-balancer-type: "nlb"
    service.beta.kubernetes.io/aws-load-balancer-ssl-cert: "arn:aws:acm:region:account:cert"
    service.beta.kubernetes.io/aws-load-balancer-backend-protocol: "http"
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
    - port: 443
      targetPort: 8080
```

---

## Migration progressive (Blue-Green)

Pour mettre à jour sans interruption :

```yaml
# Version actuelle (bleue)
spec:
  selector:
    app: webapp
    version: v1.1.0

# Nouvelle version (verte)
spec:
  selector:
    app: webapp
    version: v1.2.0
```

---

## Résumé clair et concret

Les services LoadBalancer sont indispensables en production cloud car ils :

* Exposent des services publiquement.
* Fournissent automatiquement une IP publique.
* Gèrent la répartition des charges efficacement.
* Facilitent l’intégration SSL.
* S'intègrent parfaitement dans les infrastructures cloud natives.

**Mais attention :** surveillez les coûts et optimisez en combinant avec des contrôleurs Ingress pour plusieurs services !

