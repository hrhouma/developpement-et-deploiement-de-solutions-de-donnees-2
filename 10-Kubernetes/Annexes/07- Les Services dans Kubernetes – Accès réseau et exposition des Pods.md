# <h1 id="01-services">01. Les Services dans Kubernetes – Accès réseau et exposition des Pods</h1>



## <h2 id="01-01-contexte">1. Pourquoi a-t-on besoin des Services ?</h2>

Dans Kubernetes :

* Chaque **Pod** a sa propre **adresse IP privée**, attribuée automatiquement.
* Cette IP change **à chaque redémarrage** du Pod (ce qui est fréquent).
* Il est donc **impossible de se connecter durablement à un Pod directement**.

**Un Service** est une abstraction réseau **stable** qui permet à d’autres applications ou utilisateurs d’**accéder à un ou plusieurs Pods**, **même s’ils changent d’IP ou redémarrent**.

---

## <h2 id="01-02-definition">2. Définition d’un Service</h2>

Un **Service** dans Kubernetes est un objet qui :

* Fournit une **adresse IP stable** (et parfois un nom DNS),
* Fait du **load-balancing** (répartition de charge) entre plusieurs Pods,
* Redirige automatiquement vers les Pods **sélectionnés par des labels**.

> Autrement dit : le Service est un **répartiteur réseau interne ou externe**, qui trouve les Pods valides pour une application, même si leur IP change.

---

## <h2 id="01-03-comparaison">3. Les 4 principaux types de Services</h2>

| Type                       | Visibilité                                                | Usage principal                                                     | Avantages                              | Inconvénients                                          |
| -------------------------- | --------------------------------------------------------- | ------------------------------------------------------------------- | -------------------------------------- | ------------------------------------------------------ |
| **ClusterIP** (par défaut) | **Interne au cluster**                                    | Communication entre applications dans Kubernetes                    | Simple, rapide, automatique            | Pas accessible depuis l’extérieur                      |
| **NodePort**               | Exposé sur **chaque nœud** via un port fixe (30000–32767) | Exposition minimale vers l’extérieur (tests, dev)                   | Facile à tester avec IP du nœud        | Peu sécurisé, peu flexible, pas adapté à la production |
| **LoadBalancer**           | Exposé via un **load balancer externe (cloud)**           | Accès public en production (Cloud AWS, GCP, Azure)                  | IP publique + DNS, balance automatique | Dépend du cloud provider, pas dispo en local           |
| **ExternalName**           | **Redirection DNS** vers un nom externe                   | Pointer vers un service en dehors de Kubernetes (ex. : API externe) | Intégré à l’écosystème                 | Ne fait aucun routage, juste une redirection DNS       |

---

## <h2 id="01-04-cas-concrets">4. Cas d’usage concrets</h2>

### 4.1 Application interne

* Une API `api-backend` doit être contactée par un frontend `web-app`.
* Un Service de type **ClusterIP** est créé pour `api-backend`.
* Résultat : le frontend envoie des requêtes vers `http://api-backend` (adresse DNS stable dans le cluster).

### 4.2 Test local d’un site

* On veut accéder à `web-app` depuis l’extérieur pour un test.
* On crée un Service **NodePort** : il expose le port 30080 sur chaque nœud.
* Accès depuis un navigateur : `http://<IP_du_nœud>:30080`

### 4.3 Déploiement cloud

* On héberge une API sur GKE ou EKS et on veut une IP publique.
* On utilise un Service **LoadBalancer**.
* Kubernetes demande au cloud provider de créer un vrai load balancer.

### 4.4 Service externe (hors cluster)

* On a une base de données hébergée sur `db.cloudprovider.com`.
* On crée un Service **ExternalName** pour que les applications puissent l’utiliser **comme si elle était dans le cluster**.

---

## <h2 id="01-05-comportement">5. Comment fonctionne le routage</h2>

1. Le Service est défini avec un **label selector** (ex. : `app=backend`).
2. Kubernetes identifie tous les Pods ayant ce label.
3. Lorsqu’un client fait une requête vers le Service :

   * Kubernetes choisit un Pod cible parmi ceux disponibles (round-robin).
   * Il redirige la requête vers l’adresse IP **réelle** du Pod.
   * Le client n’a jamais besoin de connaître cette adresse.

> La logique de routage repose sur **kube-proxy**, qui configure des règles de redirection (via iptables, IPVS ou eBPF).

---

## <h2 id="01-06-ce-qui-est-utilise">6. Ce qui est réellement utilisé en production</h2>

| Type de Service  | Usage réel       | Fréquence     | Remarques                                                                         |
| ---------------- | ---------------- | ------------- | --------------------------------------------------------------------------------- |
| **ClusterIP**    | Oui              | Très fréquent | Utilisé pour toutes les communications internes entre microservices.              |
| **NodePort**     | Rarement         | Occasionnel   | Utilisé pour tests locaux ou solutions sans Ingress. À éviter en production.      |
| **LoadBalancer** | Oui (en cloud)   | Très fréquent | Utilisé pour exposer des applications au public. Couplé avec certificat SSL, DNS. |
| **ExternalName** | Oui (spécifique) | Modéré        | Pour intégrer des services hors cluster (base externe, API tierce).               |

---

## <h2 id="01-07-distinctions">7. Ne pas confondre avec...</h2>

| Élément           | Ce n’est **pas** un Service | Fonction réelle                                                                                                        |
| ----------------- | --------------------------- | ---------------------------------------------------------------------------------------------------------------------- |
| **Ingress**       | Non                         | C’est une **passerelle HTTP** intelligente (niveau 7), souvent couplée à un Service pour le trafic HTTP/HTTPS entrant. |
| **Endpoints**     | Non                         | Ce sont les **adresses réelles** des Pods cibles associées à un Service.                                               |
| **NetworkPolicy** | Non                         | C’est une règle de **filtrage réseau** qui détermine qui peut parler à qui.                                            |

---

## <h2 id="01-08-a-retenir">8. À retenir</h2>

* Un **Service** est indispensable pour accéder à un Pod de façon stable.
* Le **ClusterIP** est le plus courant, car il relie les services entre eux en interne.
* Le **LoadBalancer** est utilisé en production sur les clouds pour exposer les services publiquement.
* Le **NodePort** est rarement utilisé sérieusement : peu sécurisé, peu souple.
* Le **Service** ne garantit pas l’authentification, la sécurité, ni le certificat HTTPS : ces fonctions relèvent de **l’Ingress**.


