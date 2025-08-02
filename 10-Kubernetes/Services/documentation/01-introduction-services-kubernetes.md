# Cours 1 : Les Services Kubernetes (Partie 1 – Concepts fondamentaux)

## Introduction

Un **Service** dans Kubernetes est une ressource essentielle qui permet d'exposer et de rendre accessible un ensemble de pods. Il assure la stabilité d'accès aux applications déployées, même si les pods changent fréquemment.

## Pourquoi les Services sont-ils indispensables ?

### 1. Les Pods sont éphémères :

Les pods Kubernetes peuvent être créés, supprimés ou redémarrés à tout moment selon les besoins du cluster. Cela signifie que leur adresse IP est temporaire.

### Exemple concret :

* **Sans service** :
  L’application `frontend` tourne dans un pod avec IP `10.10.1.5`. Si le pod redémarre, l’adresse IP peut devenir `10.10.1.9`. Votre application cliente ne saura plus où envoyer les requêtes.

* **Avec service** :
  Le service `frontend-service` a une IP fixe comme `10.96.0.10`. Même si le pod change d’IP, le service route automatiquement vers le nouveau pod.

---

### 2. Les IPs des Pods changent constamment :

Les IPs des pods sont assignées dynamiquement. Le service garantit une adresse IP stable, servant de référence constante.

### Exemple :

* Trois pods pour une application web :

  * Pod 1 : `10.10.1.5`
  * Pod 2 : `10.10.1.6`
  * Pod 3 : `10.10.1.7`

Si un pod tombe ou est remplacé, le service continue de fonctionner normalement en pointant vers les pods opérationnels restants.

---

### 3. Load Balancing :

Le service répartit automatiquement le trafic entre plusieurs pods. Cela améliore la disponibilité, la fiabilité, et l’équilibrage des charges.

### Exemple concret :

* Vous avez 3 pods d’un serveur web identiques :

  * Requête client 1 → Pod 1
  * Requête client 2 → Pod 2
  * Requête client 3 → Pod 3
  * Requête client 4 → Retour au Pod 1 (rotation équilibrée)

---

### 4. Découverte automatique des services (Service Discovery) :

Le Service permet aux applications de communiquer facilement entre elles grâce à des entrées DNS générées automatiquement.

### Exemple concret :

* Une base de données PostgreSQL exposée via un service :

  ```bash
  postgres-service.database.svc.cluster.local
  ```

  Votre backend peut simplement utiliser ce nom au lieu de gérer des IPs variables.

---

## Fonctionnement général d’un Service Kubernetes :

```
Client externe ou interne
         ↓
Adresse IP stable du Service
         ↓ (Load balancing automatique)
Pod 1 | Pod 2 | Pod 3 | … | Pod N
```

Le Service agit comme un intermédiaire stable et fiable.

---

## Sélection des Pods : Labels Selectors

Les Services utilisent des sélecteurs basés sur des étiquettes (labels) pour cibler les pods spécifiques :

### Exemple détaillé en YAML :

**Fichier YAML du Service :**

```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend-service
spec:
  selector:
    app: frontend
    tier: web
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

**Fichier YAML des Pods ciblés :**

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: frontend-pod-1
  labels:
    app: frontend
    tier: web
spec:
  containers:
    - name: frontend-container
      image: myapp/frontend:latest
      ports:
        - containerPort: 8080
```

Ici, le service cible uniquement les pods qui ont les labels :

* `app: frontend`
* `tier: web`

---

## DNS et Découverte automatique

Kubernetes fournit une entrée DNS pour chaque service, ce qui simplifie les communications internes :

* **Format DNS standard :**

```
<nom-du-service>.<namespace>.svc.cluster.local
```

### Exemple concret :

* Service : `redis-service` dans le namespace `cache`
* Nom DNS :

```
redis-service.cache.svc.cluster.local
```

Votre application cliente peut donc simplement appeler `redis-service` sans jamais gérer directement les adresses IP.

---

## Types de Services Kubernetes : Vue exhaustive

| Type           | Utilisation principale                    | Accès depuis                       | Cas d’usage concret                          | Où l’utiliser ?     |
| -------------- | ----------------------------------------- | ---------------------------------- | -------------------------------------------- | ------------------- |
| `ClusterIP`    | Communication interne au cluster          | Seulement à l’intérieur du cluster | Backend vers base de données interne         | Tous environnements |
| `NodePort`     | Tests et développement local              | IP du Node + port attribué         | Tester une app web locale sur Minikube       | Développement local |
| `LoadBalancer` | Accès externe direct via une IP publique  | IP publique externe                | Application web exposée sur AWS, GCP, Azure  | Production Cloud    |
| `ExternalName` | Redirection vers un service externe (DNS) | Externe via DNS                    | Redirection vers une base de données externe | Tous environnements |

---

## Exemples concrets pour chaque type de service

### ClusterIP (interne uniquement) :

* Service : base de données MongoDB accessible uniquement dans le cluster.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: mongo-service
spec:
  type: ClusterIP
  selector:
    app: mongodb
  ports:
    - port: 27017
      targetPort: 27017
```

---

### NodePort (accès depuis les nœuds) :

* Application en développement local, accessible via `IP_NODE:30080`.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: test-service
spec:
  type: NodePort
  selector:
    app: testapp
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30080
```

---

### LoadBalancer (production cloud avec IP publique) :

* Application web en production sur AWS, accessible via une IP publique.

```yaml
apiVersion: v1
kind: Service
metadata:
  name: web-service
spec:
  type: LoadBalancer
  selector:
    app: webapp
  ports:
    - port: 80
      targetPort: 8080
```

---

### ExternalName (rediriger vers un service externe) :

* Connexion vers un service externe (par exemple, une base de données Cloud SQL sur GCP).

```yaml
apiVersion: v1
kind: Service
metadata:
  name: external-db-service
spec:
  type: ExternalName
  externalName: mydb.cloudsql.google.com
```

---

## Prochaines étapes du cours :

* **Partie 2** : Approfondissement ClusterIP – Configuration détaillée, troubleshooting.
* **Partie 3** : NodePort – Scénarios pratiques et cas réels.
* **Partie 4** : LoadBalancer – Déploiement en production Cloud (AWS, GCP, Azure).
* **Partie 5** : Ingress – La solution moderne pour gérer des routes multiples et HTTPS.
* **Partie 6** : Comparaison complète, bonnes pratiques, pièges courants et conseils pratiques.
