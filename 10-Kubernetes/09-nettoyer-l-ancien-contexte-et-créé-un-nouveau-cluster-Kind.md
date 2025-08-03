Voici les étapes pour :

1. **Supprimer le contexte Kubernetes existant (et éventuellement son cluster Kind)**
2. **Créer un nouveau cluster Kind à partir de votre fichier `kind-config.yaml` et basculer sur ce nouveau contexte**

<br/>

# 1. Lister et supprimer l’ancien contexte

1. **Lister tous les contextes**

   ```bash
   kubectl config get-contexts
   ```

   Vous verrez une sortie du type :

   ```plain
   CURRENT   NAME                 CLUSTER          AUTHINFO         NAMESPACE
   *         kind-old-cluster     kind-old-cluster kind-user
             minikube             minikube         minikube
             docker-desktop       docker-desktop   docker-desktop
   ```

2. **Supprimer le contexte**
   Remplacez `<CONTEXT_NAME>` par le nom exact du contexte que vous voulez supprimer (par exemple `kind-old-cluster`) :

   ```bash
   kubectl config delete-context <CONTEXT_NAME>
   ```

3. **(Optionnel) Supprimer le cluster Kind associé**
   Si vous aviez créé ce contexte via Kind, vous pouvez aussi supprimer complètement le cluster :

   ```bash
   kind delete cluster --name <OLD_CLUSTER_NAME>
   ```

   Par défaut, le nom du cluster Kind est le même que `<CONTEXT_NAME>`.

4. **Vérifier que tout est bien supprimé**

   ```bash
   kubectl config get-contexts
   kind get clusters
   ```

<br/>

# 2. Créer un nouveau cluster Kind et son contexte

1. **Créer le cluster à partir de `kind-config.yaml`**
   Remplacez `<NEW_NAME>` par le nom que vous voulez donner à ce cluster (par exemple `kind-new`), et assurez-vous que `kind-config.yaml` est dans votre répertoire courant :

   ```bash
   kind create cluster \
     --name <NEW_NAME> \
     --config kind-config.yaml
   ```

   Cette commande :

   * Lance Kind avec la configuration du fichier YAML (nodes, ports, etc.).
   * Génère automatiquement un contexte Kubernetes nommé `kind-<NEW_NAME>` dans votre `~/.kube/config`.

2. **Vérifier que le contexte a bien été créé**

   ```bash
   kubectl config get-contexts
   ```

   Vous devriez voir apparaître :

   ```plain
   CURRENT   NAME                   CLUSTER                AUTHINFO             NAMESPACE
   *         kind-<NEW_NAME>        kind-<NEW_NAME>        kind-<NEW_NAME>      
             <autres-contextes>     …                      …
   ```

3. **Basculer sur le nouveau contexte** (si ce n’est pas déjà fait automatiquement)

   ```bash
   kubectl config use-context kind-<NEW_NAME>
   ```

4. **Vérifier que tout fonctionne**

   ```bash
   kubectl get nodes
   kubectl get pods --all-namespaces
   ```

   Vous devriez voir vos nœuds Kind et, pour l’instant, aucun pod dans `default`.

<br/>

> **Astuce** :
>
> * Pour supprimer tous les pods d’un namespace donné (par exemple `default`), vous pouvez faire :
>
>   ```bash
>   kubectl delete pods --all -n default
>   ```
> * Si vous avez plusieurs clusters Kind et que vous voulez en supprimer plusieurs en une seule commande :
>
>   ```bash
>   for name in cluster1 cluster2 cluster3; do
>     kind delete cluster --name $name
>   done
>   ```

Avec ces commandes, vous aurez nettoyé l’ancien contexte et créé un nouveau cluster Kind avec son contexte associé, prêt à l’emploi.
