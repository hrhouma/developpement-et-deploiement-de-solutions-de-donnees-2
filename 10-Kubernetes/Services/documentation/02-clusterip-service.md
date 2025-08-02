# Cours 2 : ClusterIP – Le Service par Défaut dans Kubernetes

## Qu'est-ce que ClusterIP ?

Le type **ClusterIP** est le mode de service par défaut utilisé dans Kubernetes. Il rend les services accessibles exclusivement à l'intérieur du cluster. Cela signifie qu'il ne sera pas accessible depuis l'extérieur.

## Quand utiliser un service ClusterIP ?

* **Communication interne entre microservices** : lorsque vos composants échangent des données uniquement à l’intérieur du cluster.
* **APIs internes** : APIs REST destinées uniquement à une consommation interne.
* **Bases de données internes** : quand la base de données n'a pas besoin d'être directement accessible à l'extérieur.
* **Services backend privés** : services logiques ou métiers internes.

## Quand ne pas utiliser ClusterIP ?

* **Applications frontend ou web accessibles au public** : utilisez plutôt NodePort ou LoadBalancer.
* **APIs publiques** : optez pour un LoadBalancer ou un Ingress.
* **Services externes devant être accessibles de l'extérieur** : choisissez NodePort, LoadBalancer, ou Ingress.

## Configuration détaillée d’un service ClusterIP

### Exemple simple

```yaml
apiVersion: v1
kind: Service
metadata:
  name: backend-service
  namespace: production
spec:
  selector:
    app: backend
    version: v1
  ports:
    - port: 8080        # Port exposé par le service
      targetPort: 3000  # Port du conteneur ciblé
      protocol: TCP
```

### Exemple avec des ports nommés

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
      targetPort: postgres  # Correspond au nom du port défini dans le pod
```

## Architecture typique avec ClusterIP

```
┌─────────────────────────────────────────┐
│                CLUSTER                  │
│                                         │
│  [Frontend Pod] ──→ [Backend Service]   │
│                      ↓                  │
│                   [Backend Pod 1]       │
│                   [Backend Pod 2]       │
│                   [Backend Pod 3]       │
│                                         │
│  [Backend Pod] ──→ [Database Service]   │
│                      ↓                  │
│                   [Database Pod]        │
└─────────────────────────────────────────┘
```

## Accéder à un service ClusterIP

### Depuis un pod dans le même namespace

```bash
# Via nom court
curl http://backend-service:8080/api/users

# Via nom DNS complet
curl http://backend-service.production.svc.cluster.local:8080/api/users
```

### Depuis un pod d’un autre namespace

```bash
# Obligatoirement via DNS complet
curl http://backend-service.production.svc.cluster.local:8080/api/users
```

## Variables d'environnement Kubernetes

Kubernetes définit automatiquement des variables d'environnement pour les services disponibles dans le namespace :

```bash
BACKEND_SERVICE_SERVICE_HOST=10.96.45.23
BACKEND_SERVICE_SERVICE_PORT=8080
BACKEND_SERVICE_PORT_8080_TCP=tcp://10.96.45.23:8080
BACKEND_SERVICE_PORT_8080_TCP_ADDR=10.96.45.23
BACKEND_SERVICE_PORT_8080_TCP_PORT=8080
BACKEND_SERVICE_PORT_8080_TCP_PROTO=tcp
```

## Bonnes pratiques à adopter

### 1. Utiliser un nommage clair

```yaml
# Recommandé
metadata:
  name: user-api-service
spec:
  selector:
    app: user-api

# À éviter
metadata:
  name: svc-123
spec:
  selector:
    app: random-app
```

### 2. Ajouter des labels descriptifs

```yaml
spec:
  selector:
    app: user-api
    version: v2
    tier: backend
    environment: production
```

### 3. Nommez systématiquement les ports

```yaml
ports:
  - name: http
    port: 80
    targetPort: 8080
  - name: metrics
    port: 9090
    targetPort: metrics
```

## Méthodes de test et de debug

### Vérifier la création du service

```bash
kubectl get svc -n production
kubectl describe svc backend-service -n production
kubectl get endpoints backend-service -n production
```

### Tester un service depuis un pod temporaire

```bash
kubectl run test-pod --image=busybox --rm -it --restart=Never -- sh
wget -qO- http://backend-service:8080/health
```

## Résumé

Le type de service **ClusterIP** offre :

* **Sécurité accrue** : accès strictement interne.
* **Performance optimisée** : communications rapides à l'intérieur du cluster.
* **Adapté aux microservices** : idéal pour APIs internes et bases de données.
* **Économique** : aucun coût supplémentaire lié à l’exposition externe.
