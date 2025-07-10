## <h1 id="00-architecture">00. Architecture de Kubernetes</h1>

### <h2 id="00-00-objectifs">0. Objectifs pédagogiques</h2>

* Comprendre la **structure logique** et **physique** d’un cluster Kubernetes.
* Identifier les **composants du plan de contrôle** et leur rôle.
* Expliquer le rôle des **composants nœud** (« data plane »).
* Visualiser les **flux de communication** internes et externes.
* Introduire les bases de la **haute disponibilité** et des **bonnes pratiques de sécurité**.

---

### <h2 id="00-01-overview">1. Vue d’ensemble d’un cluster</h2>

Un cluster Kubernetes est un **système distribué** composé :

| Plan                     | Rôle                   | Composants clés                                     | Responsabilités principales                          |
| ------------------------ | ---------------------- | --------------------------------------------------- | ---------------------------------------------------- |
| **Control Plane**        | « Cerveau » du cluster | kube-apiserver, etcd, scheduler, controller-manager | Orchestration, état désiré, décisions globales       |
| **Data Plane** (Workers) | Exécution des charges  | kubelet, kube-proxy, container runtime              | Lancement des Pods, mise en réseau, reporting d’état |

> **Principe fondamental** : tout passe par le **kube-apiserver**. Il sert d’API REST (JSON) sécurisée pour **kubectl**, le **dashboard** ou les **contrôleurs** internes.

---

### <h2 id="00-02-control-plane">2. Les composants du Control Plane</h2>

| Composant                                  | Description détaillée                                                                      | Ports par défaut | Exemples de commandes / fichiers     |
| ------------------------------------------ | ------------------------------------------------------------------------------------------ | ---------------- | ------------------------------------ |
| **kube-apiserver**                         | Entrée unique (REST) vers le cluster. Valide et persiste les objets dans **etcd**.         | 6443/TCP         | `kubectl get --raw /healthz`         |
| **etcd**                                   | Base de données clé-valeur hautement cohérente. Stocke l’**état désiré**.                  | 2379-2380/TCP    | `etcdctl snapshot save backup.db`    |
| **kube-scheduler**                         | Associe Pods « Pending » à des nœuds disponibles selon ressources, contraintes, affinités. | 10259/TCP        | Logs : `/var/log/kube-scheduler.log` |
| **kube-controller-manager**                | Exécute les « boucles de contrôle » : ReplicaSet, Node, Job, EndpointSlice, etc.           | 10257/TCP        | `--controllers=*,bootstrapsigner`    |
| **cloud-controller-manager** *(optionnel)* | Délègue les opérations IaaS (LB, disques, nœuds).                                          | 10258/TCP        | Présent sur GKE/EKS/AKS              |

#### 2.1 Flux internes

```text
kubectl -----> kube-apiserver <----> etcd
                 |  ^   ^
                 v  |   |
   controller-manager  scheduler
```

*L’apiserver est **stateless** ; la cohérence repose sur etcd.*

---

### <h2 id="00-03-worker-components">3. Les composants d’un nœud de travail</h2>

| Composant             | Fonction                                                                                                     | Points clés                                          |
| --------------------- | ------------------------------------------------------------------------------------------------------------ | ---------------------------------------------------- |
| **kubelet**           | Agent système. Reçoit les Manifests (PodSpecs) du control plane, lance/arrête les conteneurs via le runtime. | Supervise l’état réel. Rapporte au kube-apiserver.   |
| **kube-proxy**        | Implémente les **Services** (ClusterIP, NodePort) à l’aide d’iptables/ebpf.                                  | Gère le *load-balancing* interne.                    |
| **Container Runtime** | Exécute les conteneurs (OCI). Ex. : **containerd** (par défaut), **CRI-O**, Docker (legacy).                 | Interface CRI via `/run/containerd/containerd.sock`. |

---

### <h2 id="00-04-comms-ha">4. Communications, HA et topologies</h2>

1. **Trafic entrant**
   *API* : `kubectl`, CI/CD, dashboards → **LB/TCP 6443** → kube-apiserver (x n).
2. **Trafic interne**
   Contôleurs, webhooks et nœuds → **HTTPS** vers l’API.
3. **etcd HA**
   *Cluster* 3+ nœuds, quorum Raft.
4. **Control Plane HA**
   *Stacked etcd* (etcd co-localisé) ou *External etcd*.
5. **LB**
   – NLB/HAProxy pour l’API, – kube-vip ou MetalLB pour l’adressage virtuel.

---

### <h2 id="00-05-security">5. Sécurité du plan de contrôle</h2>

* **Authentication** : certificats X.509, tokens, OIDC.
* **Authorization** : RBAC (`ClusterRole`, `RoleBinding`).
* **Admission controllers** : validation & mutation (ex. `PodSecurity`, `LimitRanger`).
* **Chiffrement etcd** : Clé AES-CBC définie dans `/etc/kubernetes/encryption-config.yaml`.

---

### <h2 id="00-06-storage-etcd">6. Stockage et sauvegarde d’etcd</h2>

```bash
# Sauvegarde ponctuelle
sudo ETCDCTL_API=3 etcdctl \
  --endpoints=https://127.0.0.1:2379 \
  --cacert=/etc/kubernetes/pki/etcd/ca.crt \
  --cert=/etc/kubernetes/pki/etcd/server.crt \
  --key=/etc/kubernetes/pki/etcd/server.key \
  snapshot save /srv/backup/etcd_$(date +%F).db
```

*Plan de restauration* : stop → restore → update static pod manifests → start.

---

### <h2 id="00-07-interaction-kubectl">7. Interaction avec kubectl (mini-atelier)</h2>

| Étape | Commande                                  | Résultat attendu                            |
| ----- | ----------------------------------------- | ------------------------------------------- |
| a     | `kubectl get componentstatuses`           | Santé du control plane                      |
| b     | `kubectl get pods -n kube-system -o wide` | Liste des add-ons (coredns, metrics-server) |
| c     | `kubectl top node` *(si metrics-server)*  | Usage CPU/RAM par nœud                      |
| d     | `kubectl cluster-info dump`               | Diagnostic complet (logs JSON)              |

---

### <h2 id="00-08-exercice">8. Exercice guidé</h2>

*Objectif* : **cartographier** votre cluster et identifier chaque composant.

1. Créez une table (CSV/Markdown) listant : composant, namespace, image, version.
2. Récupérez les données :

```bash
kubectl get pods -A -o=custom-columns=\
COMPONENT:.metadata.labels.component,\
NAMESPACE:.metadata.namespace,\
IMAGE:.spec.containers[*].image | sort
```

3. Repérez les versions incohérentes (ex. : `kube-proxy` ≠ `kubelet`).
4. Rédigez un court rapport : rôle + criticité de chaque composant.

---

### <h2 id="00-09-revision">9. Questions de révision</h2>

1. **Quel composant stocke l’état désiré ?**
2. **Pourquoi le kube-apiserver est-il stateless ?**
3. **Citez trois raisons d’isoler etcd sur des nœuds dédiés.**
4. **Expliquez la différence entre kube-proxy en mode *iptables* et *ebpf*.**
5. **Quel rôle joue le cloud-controller-manager sur AWS ?**

---

### <h2 id="00-10-a-retinir">10. À retenir</h2>

* **kube-apiserver** est le **point unique d’autorité**.
* **etcd** doit être **hautement disponible** et **sauvegardé**.
* Les **nœuds workers** se limitent à exécuter des Pods ; toute décision appartient au plan de contrôle.
* La **sécurité** (AuthN / AuthZ / Admission) est native et incontournable.
* Comprendre l’architecture est la **condition préalable** avant d’aborder la mise en réseau, la persistance ou la sécurisation avancée.


