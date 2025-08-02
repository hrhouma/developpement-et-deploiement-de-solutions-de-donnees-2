# Cours 5 : Ingress – La solution moderne pour la production Kubernetes

## Qu'est-ce que l'objet Ingress ?

Ingress est une ressource Kubernetes permettant de gérer intelligemment l'accès HTTP et HTTPS externe aux services dans un cluster. À la différence d'un service classique LoadBalancer, Ingress agit comme un **reverse proxy intelligent**, capable de diriger le trafic vers plusieurs services internes tout en utilisant une seule adresse IP publique.

---

## Pourquoi choisir Ingress plutôt que LoadBalancer ?

### Avantages clairs :

* **Économies significatives** : Une seule IP publique pour plusieurs services, réduisant les coûts mensuels.
* **Flexibilité de routage** : Permet un routage précis basé sur le domaine ou l'URL.
* **SSL intégré facilement** : Support simplifié de SSL/TLS automatique avec Let's Encrypt.
* **Fonctionnalités avancées** : Rate limiting, Authentification, CORS, etc.

### Exemple concret de coût :

* **Sans Ingress** :

  * Service 1 (LoadBalancer) : \~\$18/mois
  * Service 2 (LoadBalancer) : \~\$18/mois
  * Service 3 (LoadBalancer) : \~\$18/mois
    **Total** : \~\$54/mois

* **Avec Ingress** :

  * Ingress Controller (LoadBalancer) : \~\$18/mois
  * Service 1 (ClusterIP) : \$0
  * Service 2 (ClusterIP) : \$0
  * Service 3 (ClusterIP) : \$0
    **Total** : \~\$18/mois

---

## Architecture d'une solution basée sur Ingress

```
Internet
     ↓
Cloud LoadBalancer (1 IP publique)
     ↓
Ingress Controller (nginx, traefik, haproxy)
     ├── Service 1 (ClusterIP)
     ├── Service 2 (ClusterIP)
     └── Service 3 (ClusterIP)
```

---

## Mise en place d'un Ingress Controller

### Installation NGINX Ingress (le plus répandu)

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx --create-namespace
```

---

## Configuration basique d'un Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  namespace: production
spec:
  ingressClassName: nginx
  rules:
  - host: app.exemple.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: app-service
            port:
              number: 80
```

---

## Routage avancé avec Ingress

### Routage multi-domaines

```yaml
spec:
  rules:
  - host: frontend.exemple.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  - host: api.exemple.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

### Routage par chemins

```yaml
spec:
  rules:
  - host: exemple.com
    http:
      paths:
      - path: /api
        backend:
          service:
            name: api-service
            port:
              number: 8080
      - path: /
        backend:
          service:
            name: frontend-service
            port:
              number: 80
```

---

## SSL/TLS automatique avec cert-manager et Let's Encrypt

### Installer cert-manager :

```bash
kubectl apply -f https://github.com/cert-manager/cert-manager/releases/latest/download/cert-manager.yaml
```

### Configurer Let's Encrypt :

```yaml
apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: letsencrypt-prod
spec:
  acme:
    server: https://acme-v02.api.letsencrypt.org/directory
    email: admin@exemple.com
    privateKeySecretRef:
      name: letsencrypt-prod
    solvers:
    - http01:
        ingress:
          class: nginx
```

### Exemple d'Ingress avec SSL :

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: app-ingress
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - app.exemple.com
    secretName: app-exemple-com-tls
  rules:
  - host: app.exemple.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: app-service
            port:
              number: 80
```

---

## Fonctionnalités avancées

### Déploiement Canary (tests progressifs)

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/canary: "true"
    nginx.ingress.kubernetes.io/canary-weight: "10"
```

### Limitation de taux (Rate Limiting)

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/rate-limit: "50"
    nginx.ingress.kubernetes.io/rate-limit-burst: "20"
```

### Authentification basique

```yaml
metadata:
  annotations:
    nginx.ingress.kubernetes.io/auth-type: "basic"
    nginx.ingress.kubernetes.io/auth-secret: "basic-auth-secret"
```

---

## Monitoring et debugging

### Commandes utiles pour diagnostiquer :

```bash
kubectl get ingress --all-namespaces
kubectl describe ingress app-ingress -n production
kubectl logs -n ingress-nginx deployment/ingress-nginx-controller
```

---

## Bonnes pratiques à retenir

* **Structurer par namespaces** : un Ingress par environnement (production, staging).
* **SSL automatique obligatoire** pour les applications exposées publiquement.
* **Utiliser des annotations claires** pour améliorer lisibilité et maintenance.

---

## Exemple complet pour une application en production

### Services backend/frontend en ClusterIP

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
  namespace: production
spec:
  type: ClusterIP
  selector:
    app: frontend
  ports:
    - port: 80
      targetPort: 3000
```

### Ingress unique pour frontend et API avec SSL automatique

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: production-ingress
  namespace: production
  annotations:
    cert-manager.io/cluster-issuer: "letsencrypt-prod"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
spec:
  ingressClassName: nginx
  tls:
  - hosts:
    - frontend.exemple.com
    - api.exemple.com
    secretName: exemple-com-tls
  rules:
  - host: frontend.exemple.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: frontend-service
            port:
              number: 80
  - host: api.exemple.com
    http:
      paths:
      - path: /
        backend:
          service:
            name: api-service
            port:
              number: 8080
```

---

## Stratégie de migration vers Ingress

Pour migrer progressivement de plusieurs LoadBalancers vers une architecture Ingress :

* Déployez d'abord un Ingress Controller avec une IP publique.
* Configurez l'Ingress pour rediriger les services existants.
* Retirez progressivement les anciens services LoadBalancer.
* Résultat : simplification et économie !

---

## Résumé

Ingress représente l'approche moderne pour exposer vos applications Kubernetes en production, offrant :

* **Réduction significative des coûts** grâce à une seule IP publique.
* **Grande flexibilité** (SSL, routage avancé, sécurité, monitoring).
* **Architecture simplifiée et maintenable** à long terme.

Ingress combiné à ClusterIP constitue désormais l'état de l'art pour les architectures Kubernetes modernes en production.


Ce cours détaillé et complet te donne une vision concrète pour utiliser Ingress efficacement en production Kubernetes. N'hésite pas à demander si tu souhaites encore approfondir des aspects spécifiques !
