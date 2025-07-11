# 1 - Équivalent pour la création d'un Pod en ligen de commande (Ajout d'un label)


```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
```


```bash
kubectl apply -f mypod.yaml
```

> Cette commande crée le Pod dans le cluster Kubernetes.


# 2 - Ajout d'un Label

#### Méthode 1 - Ajouter directement dans le yaml (la spécification et le mettre à jour via kubectl apply -f mypod.yaml)

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:alpine
    ports:
    - containerPort: 80
```

#### Méthode 2 - en utilisant la ligne de commande direcetment sans changer .yaml

```yaml
kubectl get all -A --show-labels
kubectl get po --show-labels
kubectl apply -f .\mypod.yml
kubectl apply -f mypod.yaml
kubectl get po --show-labels
kubectl apply -f mypod.yaml
kubectl get po --show-labels
kubectl label pod nginx classe=bigdata --overwrite
kubectl get po --show-labels
```


- https://stackoverflow.com/questions/36741974/how-to-use-kubectl-command-with-flag-selector
- https://stackoverflow.com/questions/77301400/how-to-list-all-labels-in-kubernetes
