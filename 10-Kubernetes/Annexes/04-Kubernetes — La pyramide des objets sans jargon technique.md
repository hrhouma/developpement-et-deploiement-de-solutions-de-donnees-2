### Kubernetes — La pyramide des objets sans jargon technique

| Niveau | Objet Kubernetes | Rôle simplifié                                                                                                                                                                                                                                    | Métaphore du quotidien                                                                                                         |
| ------ | ---------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------ |
| 1      | **Pod**          | Regroupe **tout ce qu’il faut** pour qu’un ou plusieurs conteneurs tournent : <br>• Le ou les **conteneurs** (le logiciel) <br>• Un **volume** (petit tiroir de stockage partagé) <br>• Une **adresse IP** privée (comme un numéro d’appartement) | **Une boîte à bento** : un seul plateau contenant plusieurs petits compartiments qui partent toujours ensemble.                |
| 2      | **ReplicaSet**   | Duplique le même Pod **n** fois pour encaisser la charge ou survivre aux pannes : « Je veux toujours 3 boîtes à bento disponibles ».                                                                                                              | **Un four à pizza programmable** : s’il manque une pizza, le four en refait automatiquement une.                               |
| 3      | **Deployment**   | Chef d’orchestre au‐dessus du ReplicaSet : <br>• Déclare **combien** de Pods il faut. <br>• Gère les **mises à jour en douceur** (changer la recette sans fermer la pizzeria). <br>• Garde l’historique pour revenir en arrière.                  | **Le gérant de la pizzeria** : décide du nombre de fours, lance la nouvelle recette, et peut revenir à l’ancienne si ça brûle. |


#### 1. Pod : l’unité de base

* **Conteneur(s)** : votre code empaqueté.
* **Volume** : petit disque partagé entre ces conteneurs (log, cache, etc.).
* **Adresse IP** : chaque Pod a la sienne ; les conteneurs à l’intérieur partagent cette IP.

> *À retenir :* si le Pod disparaît (redémarrage, déplacement), son IP change : c’est normal, Kubernetes recréera le Pod ailleurs.



#### 2. ReplicaSet : la photocopieuse

* Vous dites « Je veux **3** Pods identiques ».
* Le ReplicaSet surveille ; si un Pod meurt, il en relance un autre pour rester à 3.
* Il **n’invente rien** : il ne fait que copier le Pod qu’on lui a décrit.



#### 3. Deployment : le manager polyvalent

* Vous écrivez un manifeste « Je veux l’image **v1** du Pod en **3 exemplaires** ».
* Plus tard, vous changez l’image en **v2** : le Deployment **remplace progressivement** les Pods v1 par v2 (rolling update).
* En cas de souci, une seule commande suffit pour **rollback** à v1.
* C’est donc l’objet que l’on **manipule au quotidien** ; ReplicaSet et Pods sont gérés automatiquement en coulisses.



### Comment tout s’imbrique en pratique

```
DEMANDE (Deployment)
     │  crée/maj
     ▼
GARDE-FOU (ReplicaSet)  ← surveille le nombre
     │  engendre
     ▼
BOÎTES (Pods)           ← font vraiment tourner votre appli
```

1. **kubectl apply -f my-deployment.yaml**
   → Kubernetes crée un **Deployment**.
2. Le Deployment génère un **ReplicaSet** avec la recette désirée.
3. Le ReplicaSet lance le nombre voulu de **Pods**.
4. Vous mettez l’image à jour ?
   → Le Deployment crée un **nouveau ReplicaSet** (version v2) et **éteint doucement** l’ancien.



### Pourquoi cette hiérarchie ?

| Besoin humain                                                                                | Objet qui y répond |
| -------------------------------------------------------------------------------------------- | ------------------ |
| « Lancer mon appli une fois, vite »                                                          | **Pod**            |
| « Je veux plusieurs copies pour la tolérance aux pannes »                                    | **ReplicaSet**     |
| « Je veux changer la version sans interruption, consigner l’historique, revenir en arrière » | **Deployment**     |



### Points-clés à retenir

1. **Pod = conteneur(s) + stockage + IP** ; il ne s’autoduplique pas.
2. **ReplicaSet = police des effectifs** : garantit un nombre fixe de Pods.
3. **Deployment = interface quotidienne** : met à jour, historise, rollback.

En ayant ces trois briques en tête, tout le reste de Kubernetes (Service, Ingress, StatefulSet, etc.) n’est qu’une extension ou une spécialisation autour de cette pyramide.


