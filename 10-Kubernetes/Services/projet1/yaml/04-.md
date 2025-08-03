# **Explication du Problème :**

Tu as déployé une application Kubernetes sur un cluster **Kind** créé sur une VM Azure. Ton application utilise :

* Un **Deployment** exposant ton application sur le port **80** (interne au pod).
* Un **Service** Kubernetes de type **NodePort**, qui redirige :

  * **port** (du service lui-même) : **8080**
  * **targetPort** (port interne du pod) : **80**
  * **nodePort** (port externe sur le nœud) : **31200**

# **Pourquoi ça ne marchait pas initialement ?**

Lorsque tu utilises un cluster Kubernetes avec **Kind**, celui-ci tourne à l'intérieur de conteneurs Docker.
Même si ton **service.yaml** est correct, le port spécifié (**nodePort: 31200**) n'est pas automatiquement exposé sur ta VM hôte (Azure).

Concrètement, le problème était :

> **"Le port NodePort (31200) n'était pas exposé au niveau du host (la VM Azure), mais seulement au niveau du conteneur Docker de Kind."**

Donc, même si tu essaies :

```shell
curl http://172.184.184.173:31200
```

Cette requête échoue parce que la VM Azure elle-même ne reçoit jamais la requête, celle-ci n'étant pas propagée depuis le Docker interne où tourne Kind.



# 🚩 **Pourquoi cela fonctionne avec `extraPortMappings` ?**

La solution utilisée, en spécifiant explicitement :

```yaml
# kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
  - role: control-plane
    extraPortMappings:
      - containerPort: 31200
        hostPort: 31200
        protocol: TCP
```

permet justement de **mapper (forwarder)** le port **31200** depuis le conteneur Docker interne de Kind vers le port **31200** de la VM Azure.

Ce qui se passe exactement ici :

* `hostPort`: Port de la VM Azure elle-même (port visible de l'extérieur).
* `containerPort`: Port exposé dans le conteneur Docker de Kind (le port NodePort de Kubernetes).
* `protocol`: TCP pour trafic web HTTP.

En résumé, le flux réseau fait maintenant :

```
Browser → VM Azure port 31200 → Docker (Kind) port 31200 → Kubernetes NodePort 31200 → Kubernetes service (8080) → Pod (port 80)
```

---

## 🔖 **Résumé de la solution qui a fonctionné :**

✅ **Problème initial** :

* Service Kubernetes NodePort non accessible depuis l'extérieur (VM Azure).

✅ **Cause du problème** :

* Cluster Kind tourne dans un conteneur Docker, le NodePort n’est pas exposé par défaut au host.

✅ **Résolution finale** :

* Utilisation d’`extraPortMappings` dans `kind-config.yaml` pour exposer explicitement le port du conteneur Kind vers l’extérieur (host).



## 📌 **Pourquoi le reste (port-forward et ssh-tunnel) n'a pas marché initialement ?**

Tu avais essayé auparavant :

```bash
kubectl port-forward svc/webapp-service 8080:8080
```

Mais cela ouvre le port uniquement sur **localhost (127.0.0.1)** de la VM Azure, pas sur son adresse externe. Donc depuis l'extérieur (`172.184.184.173`), cette solution n'est pas accessible directement, sauf en créant un tunnel SSH explicite.

<br/>

## ✅ **La bonne pratique :**

Toujours inclure un mapping explicite via `extraPortMappings` dans ta configuration Kind, si tu veux exposer directement un NodePort vers l'extérieur.

Exemple à conserver :

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

Ainsi, l'accès depuis le navigateur via l'adresse publique de ta VM Azure fonctionnera directement.

---

🚀 **Conclusion :**

Le problème rencontré était lié au fonctionnement interne de Kind et de Docker. Sans utiliser `extraPortMappings`, le NodePort reste interne et inaccessible depuis l’extérieur.

Ta solution finale est parfaitement adaptée, claire, et doit toujours être prise en compte lors d'un déploiement Kubernetes via **Kind** sur une VM Azure.

---

📝 **Commande finale testée et validée :**

```shell
curl http://172.184.184.173:31200/
# ✅ ça marche !
```

