# 02 -  Mise en situation complète

- Un employé tente de déployer une application web sur un cluster Kubernetes créé via Kind sur une machine virtuelle (VM) Azure. 
- Il a mis en place trois fichiers YAML essentiels :

```
.
├── deployment.yaml
├── service.yaml
└── kind-config.yaml
```

### Fichier `deployment.yaml`

Ce fichier décrit un déploiement d'une application web simple exposant le port interne `80` des pods Kubernetes.

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: webapp-deployment
  namespace: webapp-namespace
spec:
  replicas: 2
  selector:
    matchLabels:
      app: webapp
  template:
    metadata:
      labels:
        app: webapp
    spec:
      containers:
      - name: webapp
        image: gededhub/kubernetes-pipeline
        imagePullPolicy: Always
        ports:
        - containerPort: 80
```

### Fichier `service.yaml`

Ce fichier crée un service Kubernetes de type `NodePort`, permettant d'exposer le service vers l'extérieur du cluster :

```yaml
apiVersion: v1
kind: Service
metadata:
  name: webapp-service
  namespace: webapp-namespace
  labels:
    app: webapp
spec:
  selector:
    app: webapp
  type: NodePort
  ports:
    - port: 8080
      targetPort: 80
      nodePort: 31200
```

Ce service expose donc le port `31200` sur le nœud Kubernetes, et transfère les requêtes entrantes vers le port `80` des pods internes.

### Problème rencontré par l'étudiant

Après avoir correctement appliqué ces fichiers sur son cluster Kubernetes créé avec Kind (déployé sur une VM Azure), l'étudiant ne parvenait pas à accéder à son application via l’adresse IP publique de la VM Azure :

```
http://172.184.184.173:31200
```

Le navigateur n'affichait rien et les tentatives suivantes n’ont pas non plus fonctionné :

* Redirection locale de port avec :

  ```
  kubectl port-forward svc/webapp-service 8080:8080
  ```
* Tunnel SSH avec :

  ```
  ssh -g -L 8081:localhost:8080 azureuser@172.184.184.173
  ```

## Pourquoi le problème se produit-il ?

### Fonctionnement interne du cluster Kubernetes avec Kind

Lorsque vous utilisez **Kind (Kubernetes IN Docker)**, le cluster Kubernetes est entièrement exécuté dans un ou plusieurs conteneurs Docker. Ces conteneurs Docker disposent de leur propre réseau isolé.

Ainsi, lorsqu’un service Kubernetes de type `NodePort` est créé, le port spécifié (`31200` dans ce cas) est ouvert uniquement dans le conteneur Docker du cluster Kind, et non sur la VM Azure hôte elle-même.

Autrement dit, même si Kubernetes a correctement configuré le service NodePort, la VM Azure ne reçoit pas directement les requêtes arrivant sur le port `31200`, car ce port n’est pas automatiquement exposé depuis le conteneur Docker vers la VM.

Le chemin des requêtes, initialement :

```
Navigateur → VM Azure (port 31200 fermé) ✘
```

Le trafic réseau entrant ne peut jamais atteindre le conteneur Docker Kind.

## Comment résoudre ce problème ?

Pour résoudre ce problème, il faut explicitement indiquer à Kind de rediriger certains ports du conteneur Docker vers l'hôte (la VM Azure). Ceci se fait grâce à la directive `extraPortMappings` dans le fichier de configuration de Kind (`kind-config.yaml`).

### Fichier `kind-config.yaml` (solution finale)

Voici le fichier de configuration complet ayant permis la résolution du problème :

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 31200
        hostPort: 31200
        protocol: TCP
```

Cette configuration fait explicitement le pont réseau entre :

* Le port `31200` du conteneur Docker (utilisé par Kubernetes NodePort)
* Le port `31200` de la VM Azure hôte (accessible depuis l'extérieur)

Ainsi, le nouveau chemin du trafic réseau devient fonctionnel :

```
Navigateur → VM Azure (port 31200 ouvert) → Conteneur Docker Kind (port 31200) → Service Kubernetes NodePort (31200) → Service Kubernetes (port 8080) → Pods Kubernetes (port 80)
```

Cette chaîne complète explique pourquoi l'application devient immédiatement accessible après l'ajout de la configuration `extraPortMappings`.

## Pourquoi les solutions précédentes (port-forward et tunnel SSH) n’ont pas fonctionné ?

* **`kubectl port-forward svc/webapp-service 8080:8080`** :
  Cette commande ouvre uniquement un tunnel réseau local à la VM Azure. Par défaut, cette commande écoute sur `localhost` (127.0.0.1) uniquement. Le trafic externe vers l’IP publique ne peut pas atteindre ce tunnel sans configurations réseau supplémentaires.

* **Tunnel SSH (`ssh -g -L 8081:localhost:8080 azureuser@172.184.184.173`)** :
  Cette commande aurait pu fonctionner, mais elle implique que les requêtes passent explicitement par le tunnel SSH. Ceci nécessite une configuration spécifique au niveau du client qui accède au service (utiliser explicitement `localhost:8081`), ce qui n'était pas l'objectif initial (accès direct via IP externe et port 31200).

## Bonne pratique recommandée (synthèse finale)

Lorsque vous utilisez Kind sur une VM distante (Azure, AWS, GCP, ou autre), vous devez toujours utiliser explicitement la directive `extraPortMappings` pour rendre vos ports NodePort accessibles à l’extérieur.

Exemple à retenir pour vos futurs déploiements :

```yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: <NodePort utilisé>
        hostPort: <NodePort utilisé>
        protocol: TCP
```

En suivant cette pratique, vous assurerez systématiquement l'accès à vos services Kubernetes déployés avec Kind.

## Conclusion détaillée (sans ambiguïté)

Le problème initial était dû à la nature isolée du réseau Docker utilisé par Kind. Sans spécifier explicitement un mapping de ports via `extraPortMappings`, le trafic externe ne peut pas atteindre les services Kubernetes exposés en NodePort.

La solution apportée par la directive `extraPortMappings` permet d'ouvrir explicitement un chemin réseau de l'extérieur vers les services internes au cluster Kind. Ainsi, elle garantit un accès direct et fiable à l'application déployée sur Kubernetes.

## Validation finale du fonctionnement

Pour valider que votre configuration est fonctionnelle, vous pouvez utiliser la commande suivante depuis l'extérieur (par exemple depuis votre navigateur ou via curl depuis un autre poste):

```shell
curl http://172.184.184.173:31200/
```

Cette requête doit désormais retourner le contenu web attendu, confirmant la résolution complète du problème.

