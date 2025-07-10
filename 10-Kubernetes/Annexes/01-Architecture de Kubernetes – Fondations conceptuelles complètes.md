# <h1 id="00-architecture">00. Architecture de Kubernetes – Fondations conceptuelles complètes</h1>


# <h2 id="00-01-contexte">1. Contexte général : pourquoi Kubernetes ?</h2>

Avant Kubernetes, déployer une application signifiait :

* Trouver une machine libre (physique ou virtuelle).
* Lancer manuellement un processus ou un conteneur.
* Espérer que tout reste stable.
* Gérer les pannes soi-même, souvent en pleine nuit.

Kubernetes automatise entièrement ces étapes en proposant :

* Une **description déclarative** de ce que vous voulez (ex : “je veux 3 copies de mon application”).
* Un **système de contrôle** qui s’assure que cet objectif est toujours respecté.
* Une **réaction automatique** en cas d’incident (perte de serveur, application qui plante).
* Une **mise à jour orchestrée** sans arrêt de service.



# <h2 id="00-02-niveau-1-pod">2. Le Pod : l’unité de base dans Kubernetes</h2>

### Définition

Un **Pod** est la plus petite unité que Kubernetes peut créer, gérer et supprimer.

Il contient :

* **Un ou plusieurs conteneurs** (souvent un seul).
* **Un ou plusieurs volumes** (pour stocker des fichiers partagés entre conteneurs).
* **Une adresse IP privée** (unique au Pod, visible dans le réseau Kubernetes).
* **Une configuration commune** : variables d’environnement, secrets, ports ouverts, etc.

### Remarques importantes

* Tous les conteneurs d’un Pod **partagent le même espace réseau et disque local**.
* Si un Pod meurt (plantage, éviction, redémarrage du nœud), il **disparaît définitivement**. Il ne revient pas automatiquement.
* Par défaut, un Pod est **éphémère et remplaçable**. Il ne doit pas être utilisé pour du stockage permanent.

### Métaphore pédagogique

Un Pod est comme un **conteneur maritime** contenant plusieurs modules d’une même mission :

* Un conteneur principal : par exemple, un serveur Nginx.
* Un conteneur secondaire : par exemple, un agent qui collecte les logs.
* Tous voyagent ensemble, partagent l’électricité (volumes) et l’adresse GPS (IP).



# <h2 id="00-03-niveau-2-replicaset">3. ReplicaSet : la duplication et la haute disponibilité</h2>

### Définition

Un **ReplicaSet** est un contrôleur qui **veille à ce qu’un nombre fixe de Pods identiques soient toujours en cours d’exécution**.

Exemple : “Je veux 3 copies de ce Pod.”
Si l’un d’eux meurt, le ReplicaSet en recrée un.
Si un nœud est supprimé, les Pods sont relancés ailleurs.

### Points fondamentaux

* Le ReplicaSet ne “contient” pas les Pods. Il **les supervise**.
* Il ne décide pas de la version, du port ou du volume. Il **reçoit un modèle de Pod**, et le reproduit.

### Cas d’usage

* Assurer que le frontend de votre application soit toujours disponible (ex. : 4 copies).
* Fournir une API toujours accessible depuis plusieurs zones géographiques.

### Métaphore pédagogique

Imaginez une **photocopieuse intelligente** : vous déposez un document (le Pod modèle), vous tapez “3 copies”, et la machine :

* Imprime immédiatement 3 fois.
* Si l’un des exemplaires est perdu, elle le réimprime automatiquement.
* Elle ne change jamais le contenu sans instruction explicite.



# <h2 id="00-04-niveau-3-deployment">4. Deployment : la gestion de version et des mises à jour</h2>

### Définition

Un **Deployment** est un objet qui **décrit l’objectif global d’un déploiement** :
Nombre de Pods, leur modèle (image Docker, configuration, ports...), leur version, et les règles de mise à jour.

Il crée un ou plusieurs ReplicaSets pour faire respecter ce plan. Il enregistre aussi l’historique pour pouvoir **revenir en arrière**.

### Responsabilités principales

* Créer un ReplicaSet avec la version souhaitée.
* Remplacer progressivement un ReplicaSet par un autre (rolling update).
* Conserver un historique (revisions) pour restaurer une version antérieure.
* Appliquer des stratégies de mise à jour (progressive, instantanée, bloquée).

### Scénarios typiques

* Déploiement d’un site web (version 1), puis passage à la version 2 en douceur.
* Annulation d’une mise à jour qui a cassé la production.
* Changement de configuration d’un lot de Pods sans interruption du service.

### Métaphore pédagogique

Le Deployment est **un chef de chantier** :

* Il donne l’ordre de “construire 5 maisons de type A”.
* Puis, un jour, il veut changer les plans (type B).
* Il le fait progressivement, maison par maison.
* Si les nouvelles maisons sont défectueuses, il demande à revenir aux anciennes immédiatement.


# <h2 id="00-05-chaine">5. La chaîne complète : comment tout s’imbrique</h2>

### Étapes classiques

1. L’administrateur crée un **Deployment** :
   “Je veux 4 serveurs Nginx, version 1.23.3, avec le port 80 exposé.”
2. Le Deployment crée un **ReplicaSet** avec ce modèle.
3. Le ReplicaSet crée **4 Pods** identiques selon ce modèle.
4. Chaque Pod contient **un conteneur Nginx**, prêt à servir.

Si un Pod meurt, le ReplicaSet en crée un autre.
Si on change la version, le Deployment remplace progressivement les Pods par la nouvelle version.



# <h2 id="00-06-scenarios">6. Exemples réels et cas concrets</h2>

### Exemple 1 : Blog en production

| Élément         | Nom logique       | Type d’objet Kubernetes | Détail                            |
| --------------- | ----------------- | ----------------------- | --------------------------------- |
| Site web        | `frontend-deploy` | Deployment              | 3 Pods Nginx avec HTML statique   |
| API             | `backend-deploy`  | Deployment              | 2 Pods Node.js avec Express       |
| Base de données | `postgres`        | Pod ou StatefulSet      | 1 Pod avec volume persistant      |
| Supervision     | `log-agent`       | DaemonSet               | 1 Pod par nœud pour lire les logs |

### Exemple 2 : Mise à jour

* L’application `api-backend` tourne en version 1.0 sur 4 Pods.
* Le développeur pousse la version 1.1.
* Le Deployment va :

  * Démarrer 1 Pod v1.1
  * Supprimer 1 Pod v1.0
  * Recommencer jusqu’à avoir 4 Pods v1.1
* En cas d’erreur détectée, on peut revenir à v1.0 automatiquement.



# <h2 id="00-07-synthese">7. Résumé visuel synthétique</h2>

```
Déploiement (Deployment)
  ↓ crée
Réplicateur (ReplicaSet)
  ↓ engendre
Instances (Pods)
  ↓ contiennent
Conteneurs (Docker, etc.)
```

* **Pod** = unité d’exécution (code, config, stockage, IP).
* **ReplicaSet** = s’assure du bon nombre de Pods.
* **Deployment** = planificateur et gestionnaire des versions.



## <h2 id="00-08-a-retenir">8. À retenir absolument</h2>

| Point | Description                                                                          |
| ----- | ------------------------------------------------------------------------------------ |
| 1     | Kubernetes ne manipule jamais un conteneur directement, **toujours un Pod**.         |
| 2     | Un Pod seul est éphémère. Pour du sérieux, utilisez toujours un **Deployment**.      |
| 3     | Le Deployment est l’objet le plus utilisé en pratique pour déployer une application. |
| 4     | L’ensemble **Pod → ReplicaSet → Deployment** est fondamental pour tout ce qui suit.  |

