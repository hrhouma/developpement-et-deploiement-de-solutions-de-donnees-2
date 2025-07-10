## <h1 id="00-architecture">00. Architecture de Kubernetes – vision 100 % conceptuelle</h1>

> **But de cette section** : comprendre *qui fait quoi* dans un cluster Kubernetes, sans se perdre dans les commandes ou la configuration. Imagine plutôt une équipe de métier où chaque composant joue un rôle précis pour que les conteneurs tournent, communiquent et se réparent d’eux-mêmes.



### <h2 id="00-01-vue-densemble">1. Vue d’ensemble : deux grandes « équipes »</h2>

| Équipe               | Métaphore                      | Mission globale                                                                             |
| -------------------- | ------------------------------ | ------------------------------------------------------------------------------------------- |
| **Plan de contrôle** | Bureau central de commandement | Décide l’« état idéal » (quels Pods, où, combien) et surveille que le terrain s’y conforme. |
| **Nœuds de travail** | Ateliers de production         | Hébergent réellement les conteneurs et rapportent leur état au « bureau central ».          |



### <h2 id="00-02-control-plane">2. Les rôles clefs du plan de contrôle</h2>

| Composant                                | Rôle (métaphore)                      | Ce qu’il fait au quotidien                                                                                                               |
| ---------------------------------------- | ------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------- |
| **kube-apiserver**                       | **Standardiste** 24 h/24              | Reçoit *toutes* les demandes : déployer, supprimer, inspecter. Il vérifie chaque ordre, le consigne et le transmet aux bonnes personnes. |
| **etcd**                                 | **Registre notarié**                  | Garde‐fou immuable contenant l’« état désiré ». Rien n’est considéré vrai s’il n’est pas inscrit ici.                                    |
| **kube-scheduler**                       | **Chef d’orchestre des affectations** | Observe les Pods en attente et choisit le meilleur nœud libre (ressources, contraintes, affinités).                                      |
| **kube-controller-manager**              | **Patrouille d’inspecteurs**          | Compare en boucle l’état réel à l’état désiré (ex. : nombre de répliques) et lance des corrections si nécessaire.                        |
| **cloud-controller-manager** (optionnel) | **Interface Cloud**                   | Pour un cluster hébergé (AWS, GCP…), il s’occupe des tâches propres au fournisseur : disques, adresses IP, load balancers.               |



### <h2 id="00-03-data-plane">3. Les acteurs sur chaque nœud de travail</h2>

| Composant                                  | Métaphore                | Contribution clé                                                                                                                                      |
| ------------------------------------------ | ------------------------ | ----------------------------------------------------------------------------------------------------------------------------------------------------- |
| **kubelet**                                | **Contremaître**         | Reçoit le planning du contrôle central, démarre/arrête les conteneurs, et rend compte *en continu* de leur santé.                                     |
| **kube-proxy**                             | **Agent de circulation** | Met en place les « carrefours » réseau pour que chaque Service (adresse virtuelle) redirige la circulation vers les bons Pods, où qu’ils se trouvent. |
| **Container Runtime** (containerd, CRI-O…) | **Atelier mécanique**    | Installe et lance concrètement les conteneurs sur le système d’exploitation.                                                                          |
| *(Souvent) CNI plugin*                     | **Urbaniste réseau**     | Assigne une adresse IP à chaque Pod et pose la « voirie » (routes, ponts, eBPF) pour que tous puissent se parler sans se marcher dessus.              |

> 🔍 **À retenir** : kube-proxy n’envoie pas d’informations vers le centre ; il s’assure que les requêtes *arrivent* au bon Pod. Le messager qui informe le contrôle central, c’est le **kubelet**.



### <h2 id="00-04-flux">4. Comment tout ce monde communique</h2>

1. **Ordres descendents**
   *kubectl* ou un pipeline CI lance une requête → **kube-apiserver** l’enregistre → le **scheduler** et les **contrôleurs** réagissent → **kubelet** reçoit sa feuille de route.
2. **Remontées d’information**
   Chaque **kubelet** poste régulièrement l’état des Pods (vivants ? redémarrés ?) à l’API.
3. **Trafic applicatif**
   Les applications parlent entre elles via les Services gérés par **kube-proxy** et le réseau posé par la **CNI**.


### <h2 id="00-05-ha">5. Résilience et haute disponibilité (HA)</h2>

* **Plan de contrôle redondant** : plusieurs instances de kube-apiserver derrière une IP virtuelle ; etcd en nombre impair (3 ou 5) pour conserver le quorum.
* **Auto-guérison** : si un nœud meurt, les contrôleurs remarquent l’anomalie et ordonnent au scheduler de relancer les Pods ailleurs.
* **Pas de point unique de défaillance** : même si l’API est brièvement indisponible, les workloads déjà lancés continuent de tourner ; seule la prise de nouvelles décisions est bloquée.


### <h2 id="00-06-resume">6. En résumé</h2>

1. **kube-apiserver** = porte d’entrée, **etcd** = mémoire longue durée.
2. **kube-scheduler** décide *où*, **kube-controller-manager** veille au respect du plan.
3. Sur chaque nœud, **kubelet** est l’œil du centre ; **kube-proxy** garantit que le trafic trouve toujours sa cible.
4. Le design « déclaratif + boucles de contrôle » assure une **auto-correction** permanente.
5. Comprendre ces rôles est essentiel avant d’aborder réseaux, stockage, sécurité ou mises à jour.
