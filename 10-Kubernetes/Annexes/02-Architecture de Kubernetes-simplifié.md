# <h1 id="00-architecture">00. Architecture de Kubernetes – Le socle de l’orchestration</h1>



# <h2 id="00-01-intro">1. Pourquoi Kubernetes existe ?</h2>

Imagine que tu as :

* Plusieurs applications à faire tourner (site web, base de données, API…),
* Sur plusieurs serveurs différents,
* Avec des règles : « je veux 3 copies de ce programme », « si un serveur tombe, redémarre ailleurs », « mets à jour mes applis sans tout couper ».

**Kubernetes** est l'outil qui orchestre tout ça, de façon automatique, continue, et fiable.
Il agit comme un **chef de chantier** invisible qui **place, surveille, répare, remplace** tout ce qui tourne dans ton infrastructure.



# <h2 id="00-02-pyramide">2. La pyramide Kubernetes : trois briques de base</h2>

### <h3> NIVEAU 1 : Le Pod – L’unité de base</h3>

**Qu’est-ce que c’est ?**
Un **Pod**, c’est **le plus petit élément déployable dans Kubernetes**.
Il contient :

* **Un ou plusieurs conteneurs** (souvent un seul),
* Un **volume de stockage temporaire ou partagé**,
* Une **adresse IP privée unique**,
* Des **variables d’environnement**, des ports exposés, etc.

**Métaphore :**
C’est une **boîte à outils** livrée sur un chantier. À l’intérieur, tu peux avoir :

* Un tournevis (ton application),
* Un chargeur de batterie (volume partagé),
* Une étiquette avec l’adresse de livraison (IP).

> Un Pod ne peut pas se dupliquer tout seul.
> Un Pod est fragile : s’il meurt, il ne revient pas sans aide.



# <h3> NIVEAU 2 : Le ReplicaSet – Le garant du nombre</h3>

**Qu’est-ce que c’est ?**
Un **ReplicaSet** est une structure qui **surveille et maintient un nombre précis de Pods**.
Exemple : « Je veux **3** Pods de cette application en permanence ».

S’il y en a 2, il en relance 1. S’il y en a 4, il en supprime 1.

**Métaphore :**
C’est comme un **gardien d'entrepôt** qui vérifie tout le temps : « Combien de caisses de ce produit j’ai ? »
Et il envoie ou retire des camions pour maintenir le bon stock.



# <h3> NIVEAU 3 : Le Deployment – Le chef de mission</h3>

**Qu’est-ce que c’est ?**
Un **Deployment** est l’objet le plus utilisé dans Kubernetes.
Il commande un ReplicaSet, et donc indirectement les Pods.
Il peut aussi :

* Mettre à jour les Pods sans arrêt de service (rolling update),
* Revenir à une version précédente si ça échoue (rollback),
* Conserver l’historique des versions,
* Modifier dynamiquement les configurations.

**Métaphore :**
Le Deployment est un **manager de magasin** :

* Il décide combien de rayons de tel produit il faut,
* Change la recette du produit,
* Et garde un journal pour revenir en arrière si le nouveau lot est raté.



# <h2 id="00-03-schema">3. Comment tout s’enchaîne</h2>

```
[ Deployment ]
     ↓ (définit le besoin)
[ ReplicaSet ]
     ↓ (assure le nombre)
[ Pods ]
     ↓ (exécutent vraiment les applis)
[ Conteneurs ]
```

### Exemple : un site web

| Niveau     | Ce que tu veux                                         | Ce que fait Kubernetes           |
| ---------- | ------------------------------------------------------ | -------------------------------- |
| Deployment | « Je veux 3 serveurs Nginx avec la nouvelle version. » | Crée un ReplicaSet v2            |
| ReplicaSet | « OK, j’assure 3 Pods v2 à tout moment. »              | Lance 3 Pods, surveille leur vie |
| Pod        | « Je suis un serveur Nginx v2 prêt à servir du HTML. » | Reçoit les requêtes              |



# <h2 id="00-04-exemples">4. Exemples concrets à l’échelle réelle</h2>

# Exemple 1 : site e-commerce

| Composant       | Kubernetes                          | Nombre de copies | Rôle              |
| --------------- | ----------------------------------- | ---------------- | ----------------- |
| Frontend web    | Pod dans Deployment `web-frontend`  | 5                | Sert les pages    |
| Service API     | Pod dans Deployment `api-backend`   | 3                | Sert les requêtes |
| Base de données | Pod *isolé* ou StatefulSet          | 1                | Persistance       |
| Paiement        | Pod dans Deployment `stripe-bridge` | 2                | Gateway externe   |



# <h2 id="00-05-erreurs">5. Attention aux pièges fréquents</h2>

| Idée fausse                                     | Correction                                                                              |
| ----------------------------------------------- | --------------------------------------------------------------------------------------- |
| « Je lance un Pod et il tourne pour toujours. » | Faux. Un Pod seul est éphémère. Utilise un Deployment.                                  |
| « Les Pods ont une IP fixe. »                   | Non. Si un Pod redémarre, son IP change. Utilise un Service pour l’adresser.            |
| « Un Pod = une application. »                   | En général oui, mais il peut avoir plusieurs conteneurs (ex. : un logger et ton appli). |



# <h2 id="00-06-a-retenir">6. À retenir</h2>

* Le **Pod** est la brique de base, mais trop fragile seul.
* Le **ReplicaSet** garantit qu’il y en a toujours assez.
* Le **Deployment** pilote tout : version, rollback, rolling update.
* Dans 90 % des cas, **tu n’as besoin que de manipuler le Deployment**, le reste est automatique.

