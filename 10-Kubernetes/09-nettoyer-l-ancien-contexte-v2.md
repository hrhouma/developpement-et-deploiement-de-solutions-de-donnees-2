
- Pour supprimer un **contexte Kind (Kubernetes IN Docker)** avec ses pods, clusters, volumes, etc., et en créer un **nouveau propre avec un autre fichier `kind-config.yaml`**, voici les étapes détaillées :

# 🔥 1. Supprimer le contexte actuel (cluster Kind)

Liste des clusters Kind existants :

```bash
kind get clusters
```

Supposons que ton cluster s'appelle `kind`, pour le supprimer :

```bash
kind delete cluster --name kind
```

Cela va :

* Supprimer les pods, services, volumes, etc. du cluster
* Supprimer le contexte de kubeconfig lié à ce cluster
* Libérer les ressources Docker (containers + réseau)


<br/>

# 2. Vérifier les contextes restants

Tu peux vérifier que le contexte Kind a bien été supprimé avec :

```bash
kubectl config get-contexts
```

Et pour voir le contexte actuel :

```bash
kubectl config current-context
```

<br/>

# 🚀 3. Créer un nouveau cluster avec un autre fichier `kind-config.yaml`

Supposons que ton nouveau fichier `kind-config.yaml` ressemble à ça (exemple avec 1 master + 1 worker) :

```yaml
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
```

Créer le nouveau cluster :

```bash
kind create cluster --name nouveau-cluster --config kind-config.yaml
```

Cela :

* Crée un nouveau cluster Docker
* Ajoute automatiquement un contexte kubeconfig lié à ce cluster
* Initialise les pods systèmes

<br/>

## ✅ 4. Vérifier que tout fonctionne

Liste des pods :

```bash
kubectl get pods -A
```

Contexte utilisé :

```bash
kubectl config current-context
```

# 📌 Astuce : Supprimer *TOUS* les clusters Kind si besoin

```bash
for cluster in $(kind get clusters); do
  kind delete cluster --name "$cluster"
done
```


<br/>

# Annexe 1



Je vous propose **5 variantes** valides de fichiers `kind-config.yaml` pour différents types de clusters Kubernetes en local avec Kind :


### Variante 1 – Cluster simple (1 control-plane, 1 worker)

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
```



### Variante 2 – Cluster multi-nœuds (1 control-plane, 3 workers)

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: worker
  - role: worker
  - role: worker
```



### Variante 3 – Cluster HA (3 control-planes, 2 workers)

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
  - role: control-plane
  - role: control-plane
  - role: worker
  - role: worker
```



### Variante 4 – Cluster avec port forwarding sur le control-plane

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 30000
        hostPort: 30000
        protocol: TCP
  - role: worker
```



### Variante 5 – Cluster avec configuration kubeadm personnalisée

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
kubeadmConfigPatches:
  - |
    kind: ClusterConfiguration
    apiVersion: kubeadm.k8s.io/v1beta2
    metadata:
      name: config
    networking:
      podSubnet: "10.244.0.0/16"
nodes:
  - role: control-plane
  - role: worker
```



