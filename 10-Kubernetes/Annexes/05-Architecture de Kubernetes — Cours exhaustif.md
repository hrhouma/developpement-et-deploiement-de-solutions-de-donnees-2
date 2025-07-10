# <h1 id="00-architecture">00. Architecture de Kubernetes — Cours exhaustif</h1>



## <h2 id="00-00-objectifs">0. Objectifs pédagogiques</h2>

À l’issue de ce chapitre, l’étudiant doit :

1. **Décrire** l’architecture logique et physique d’un cluster Kubernetes.
2. **Nommer et expliquer** le rôle précis de chaque composant du plan de contrôle et des nœuds de travail.
3. **Illustrer** les flux de données (API, réseau, stockage) entre composants.
4. **Évaluer** différents schémas de haute disponibilité et leurs impacts (performance, sécurité, coûts).
5. **Mettre en pratique** la collecte d’informations système et la sauvegarde/restauration d’`etcd`.

---

## <h2 id="00-01-concepts">1. Concepts fondamentaux</h2>

| Terme                  | Définition concise                                                             | Importance                   |
| ---------------------- | ------------------------------------------------------------------------------ | ---------------------------- |
| **Cluster**            | Ensemble coordonné de machines (physiques ou virtuelles) exécutant Kubernetes. | Unit é d’orchestration.      |
| **Plan de contrôle**   | Services centralisés responsables de l’« état désiré ».                        | Décisions globales.          |
| **Data Plane**         | Processus locaux aux nœuds qui exécutent réellement les conteneurs.            | Exécution des workloads.     |
| **État désiré**        | Configuration cible déclarée par l’utilisateur (YAML).                         | Point de vérité dans `etcd`. |
| **Boucle de contrôle** | Algorithme de réconciliation qui rapproche l’état réel de l’état désiré.       | Résilience et auto-guérison. |

---

## <h2 id="00-02-plan-controle">2. Plan de contrôle détaillé</h2>

### 2.1 kube-apiserver

* **Interface unique** (REST + gRPC) vers le cluster.
* **Validation** des requêtes : schéma, quotas, politiques d’admission.
* **TLS obligatoire** (certificats X.509).
* **Scalabilité** horizontale : plusieurs instances derrière un Load Balancer L4.

> **Bon à savoir** : l’API est extensible via **API Aggregation** (ex. : metrics-server) et les **CustomResourceDefinitions** (CRD).

### 2.2 etcd

* **Base clé-valeur** cohérente (algorithme Raft).
* **Modèle de données** : chemins hiérarchiques `/registry/<ressource>/<namespace>/<name>`.
* **Performances** : faible latence (<10 ms) et IOPS stables.
* **Opérations critiques** :

  ```bash
  # Sauvegarde à chaud
  ETCDCTL_API=3 etcdctl snapshot save /srv/backup/etcd-$(date +%F).db
  # Défragmentation (maintenance)
  etcdctl defrag
  ```
* **HA** : 3 à 5 membres (impair) ; jamais 2 !

### 2.3 kube-scheduler

* **Cycle** : (i) filtrage (Fit), (ii) scoring (Score), (iii) liaison (Bind).
* **Plugins** : NodeResourcesFit, PodTopologySpread, VolumeBinding.
* **Paramétrage** : `/etc/kubernetes/scheduler-config.yaml`.

### 2.4 kube-controller-manager

Exécute plus de 30 contrôleurs :

* **ReplicationController**, **ReplicaSet**, **Deployment**, **StatefulSet**
* **NodeController** (détection de nœud down)
* **Job / CronJob Controllers**
* **EndpointSlice Controller** (services)

Chaque contrôleur :

```text
boucle infinie {
  état_désiré = lire(etcd)
  état_réel   = observer(cluster)
  si déséquilibre → agir
  sleep(Δt)
}
```

### 2.5 cloud-controller-manager (optionnel)

* Interagit avec l’API du fournisseur cloud (ELB, disques EBS, IP flottantes).
* Séparé depuis Kubernetes v1.6 pour alléger le tronc commun.

---

## <h2 id="00-03-noeuds">3. Composants d’un nœud de travail</h2>

| Composant           | Fonction principale                                                   | Points de vigilance              |
| ------------------- | --------------------------------------------------------------------- | -------------------------------- |
| **kubelet**         | Applique les PodSpecs, monitore le cgroup, remonte le status.         | Vérifier `NodePressureEviction`. |
| **kube-proxy**      | Implemente `Service` + load-balancing interne (iptables, IPVS, eBPF). | Mode IPVS recommandé en prod.    |
| **CRI Runtime**     | Exécute les conteneurs (containerd, CRI-O).                           | Docker Shim supprimé v1.24.      |
| **CNI Plugin**      | Gère le réseau Pod-to-Pod (Calico, Flannel, Cilium…).                 | Peut injecter eBPF.              |
| **CSI Node Plugin** | Attache/détache volumes (RBD, EBS, CephFS…).                          | Contrôle accès I/O.              |

---

## <h2 id="00-04-reseau">4. Architecture réseau</h2>

### 4.1 Principes de base

1. **Plan d’adressage plat** : tout Pod peut parler à tout Pod (RFC1918).
2. **Pas de NAT** interne (modèle uniforme d’IP).
3. **Service ClusterIP** introduit un **Cluster Virtual IP** (VIP).

### 4.2 kube-proxy

* **iptables** : règles DNAT/masquerade (simple, mais \~5000 services max).
* **IPVS** : table hashée, scale > 100 k services.
* **eBPF** (Cilium) : bypass kernel, latence réduite.

### 4.3 NetworkPolicy

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata: { name: allow-web, namespace: prod }
spec:
  podSelector: { matchLabels: { app: web } }
  ingress:
  - from:
    - namespaceSelector: { matchLabels: { stage: front } }
    ports:
    - protocol: TCP
      port: 80
```

---

## <h2 id="00-05-stockage">5. Architecture stockage & CSI</h2>

* **PersistentVolume** (PV) : ressource cluster-wide.
* **PersistentVolumeClaim** (PVC) : demande par Pod/namespace.
* **Dynamic Provisioning** : StorageClass + provisioner (EBS, NFS, Ceph, Longhorn).
* **Mode d’accès** : RWO, ROX, RWX, RWOP.

---

## <h2 id="00-06-securite">6. Chaîne de sécurité intégrée</h2>

| Couche        | Mécanisme                          | Exemple                         |
| ------------- | ---------------------------------- | ------------------------------- |
| **Transport** | TLS 1.3 mTLS (apiserver↔kubelet)   | Cert SAN : `system:node:<node>` |
| **AuthN**     | Certificats, Token bootstrap, OIDC | Google, Keycloak                |
| **AuthZ**     | RBAC (RoleBinding), ABAC (legacy)  | `kubectl auth can-i`            |
| **Admission** | Validating/Mutating Webhooks       | Gatekeeper, Kyverno             |
| **Runtime**   | PodSecurity, Seccomp, AppArmor     | `seccomp=runtime/default`       |

---

## <h2 id="00-07-ha">7. Haute disponibilité</h2>

### 7.1 Control Plane HA

* **Stacked etcd** : etcd co-localisé ; moins de machines.
* **External etcd** : séparation stricte (recommended ≥ 100 nœuds).
* **Load Balancer** : front-end pour kube-apiserver (VIP, HAProxy, NLB).

### 7.2 Scénario de panne

| Panne                | Impact                         | Remédiation                              |
| -------------------- | ------------------------------ | ---------------------------------------- |
| nœud worker down     | Pods ⇒ Failed                  | Scheduler recrée ailleurs.               |
| etcd perte de quorum | Cluster read-only              | Restaurer un snapshot ou ajouter membre. |
| kube-apiserver ∅     | kubectl KO, workloads tournent | Basculer LB vers autre instance.         |

---

## <h2 id="00-08-scalabilite">8. Scalabilité & performances</h2>

* **Horizontal Pod Autoscaler** (HPA)

  * Metrics API → CPU / memory → scale Pods.
* **Cluster Autoscaler**

  * Interagit avec IaaS pour ajouter/retirer nœuds.
* **Scheduler Perf** : `--percentage-of-nodes-to-score`, pre-emption.
* **kube-proxy** mode IPVS + conntrack hashsize.

---

## <h2 id="00-09-labs">9. Laboratoire guidé</h2>

1. **Installation d’un cluster minimal** *(kubeadm, single-node)*.

   ```bash
   kubeadm init --pod-network-cidr=10.244.0.0/16
   export KUBECONFIG=/etc/kubernetes/admin.conf
   kubectl apply -f https://raw.githubusercontent.com/flannel...
   ```
2. **Inspection du plan de contrôle**

   ```bash
   kubectl get pods -n kube-system -o wide
   kubectl get componentstatuses
   ```
3. **Sauvegarde & défragmentation etcd** *(voir § 2.2)*.
4. **Simulation de panne** : arrêter `kubelet`, observer HPA/CA.
5. **Métriques** : installer **metrics-server**, exécuter `kubectl top`.

---

## <h2 id="00-10-revision">10. Questions de révision / auto-évaluation</h2>

1. Pourquoi doit-on disposer d’un nombre impair de nœuds etcd ?
2. Différences majeures entre kube-proxy modes iptables et IPVS ?
3. Quelles sont les trois phases d’ordonnancement d’un Pod ?
4. Dans quel fichier configure-t-on l’agrégation de l’API ? Donnez un exemple.
5. Citez deux avantages de CRI-O sur Docker Shim.

---

## <h2 id="00-11-a-retenir">11. Points clés à retenir</h2>

* **kube-apiserver** est le point d’entrée unique ; toute opération passe par lui.
* **etcd** stocke *l’état désiré* ; sa disponibilité = santé du cluster.
* **Boucles de contrôle** = réconciliation continue → robustesse.
* **Plans de contrôle HA** minimisent le SPOF, mais complexifient la maintenance.
* Comprendre les **flux réseau** est indispensable avant d’aborder les Services/Ingre ss.


