### **Quiz Kubernetes – Architecture (30 questions)**

---

#### **1. Qu'est-ce qu’un cluster Kubernetes ?**

* A. Un conteneur Docker
* B. Un groupe de machines physiques
* C. Un ensemble de nœuds qui exécutent des applications conteneurisées
* D. Un service cloud privé

**Réponse : C**
→ Un cluster est composé de plusieurs nœuds pour faire tourner les applications.

---

#### **2. Quel composant gère les demandes `kubectl` ?**

* A. etcd
* B. kubelet
* C. kube-apiserver
* D. kube-scheduler

**Réponse : C**
→ `kube-apiserver` est la porte d’entrée de toutes les commandes et requêtes Kubernetes.

---

#### **3. Où sont stockées les données de configuration du cluster ?**

* A. kubelet
* B. etcd
* C. docker
* D. config.yaml

**Réponse : B**
→ etcd est une base de données clé-valeur utilisée pour stocker l’état du cluster.

---

#### **4. Quel composant s’occupe de démarrer les Pods sur les nœuds ?**

* A. kubelet
* B. kube-apiserver
* C. scheduler
* D. controller-manager

**Réponse : A**
→ `kubelet` exécute les Pods sur chaque nœud.

---

#### **5. Le plan de contrôle est responsable de :**

* A. Faire tourner les conteneurs
* B. Fournir une interface graphique
* C. Gérer l’orchestration globale du cluster
* D. Sauvegarder le code source

**Réponse : C**
→ Le plan de contrôle orchestre tout le cluster.

---

#### **6. Combien de kube-apiserver par cluster (en général) ?**

* A. 0
* B. 1
* C. Autant que de nœuds
* D. Inconnu

**Réponse : B**
→ Il y a un seul point d’entrée logique : `kube-apiserver` (parfois répliqué pour la haute dispo).

---

#### **7. Quel composant décide sur quel nœud un Pod va tourner ?**

* A. kubelet
* B. scheduler
* C. proxy
* D. nginx

**Réponse : B**
→ Le `scheduler` assigne les Pods à des nœuds selon les ressources disponibles.

---

#### **8. Quel composant gère les redémarrages de Pods échoués ?**

* A. kube-proxy
* B. etcd
* C. controller-manager
* D. crontab

**Réponse : C**
→ Le `kube-controller-manager` surveille les ressources et agit pour corriger les états.

---

#### **9. Quel composant gère la communication réseau entre Pods ?**

* A. kube-scheduler
* B. kube-proxy
* C. kubelet
* D. helm

**Réponse : B**
→ `kube-proxy` met en place les règles réseau pour les Services.

---

#### **10. Le nœud worker contient :**

* A. kube-apiserver
* B. etcd
* C. kubelet + kube-proxy
* D. docker-compose

**Réponse : C**
→ Chaque nœud de travail exécute `kubelet` et `kube-proxy`.

---

#### **11. etcd est une base :**

* A. SQL
* B. Relationnelle
* C. Clé-valeur
* D. Documentaire

**Réponse : C**
→ etcd stocke les données en paires clé-valeur.

---

#### **12. Un Pod tourne sur :**

* A. Le plan de contrôle
* B. Un nœud worker
* C. etcd
* D. kube-apiserver

**Réponse : B**
→ Les Pods s’exécutent sur les nœuds de travail.

---

#### **13. Le plan de contrôle tourne généralement sur :**

* A. Tous les nœuds
* B. Un nœud dédié ou maître
* C. Une VM dans le cloud uniquement
* D. Le nœud le moins chargé

**Réponse : B**
→ Le plan de contrôle est isolé sur un nœud maître.

---

#### **14. Kubernetes peut fonctionner sur :**

* A. Une seule machine
* B. Plusieurs machines physiques ou virtuelles
* C. Des machines cloud
* D. Toutes les réponses ci-dessus

**Réponse : D**

---

#### **15. kubelet fait quoi ?**

* A. Sauvegarde les données
* B. Fait des mises à jour
* C. Gère les conteneurs sur le nœud
* D. Crée les volumes

**Réponse : C**

---

#### **16. Qui redémarre un Pod si celui-ci échoue ?**

* A. Le développeur
* B. kube-scheduler
* C. controller-manager
* D. etcd

**Réponse : C**

---

#### **17. kube-proxy travaille à quel niveau ?**

* A. Stockage
* B. Réseau
* C. Interface utilisateur
* D. Docker

**Réponse : B**

---

#### **18. Qui orchestre tous les autres composants ?**

* A. kubelet
* B. controller-manager
* C. kube-apiserver
* D. docker

**Réponse : C**

---

#### **19. kube-scheduler s’occupe de :**

* A. Mettre à jour les Pods
* B. Planifier les Pods sur les nœuds
* C. Installer Kubernetes
* D. Créer des services

**Réponse : B**

---

#### **20. etcd garde quoi ?**

* A. Les logs système
* B. L’état du cluster Kubernetes
* C. Le code source
* D. Les images Docker

**Réponse : B**

---

#### **21. kube-controller-manager exécute :**

* A. Un seul contrôleur
* B. Plusieurs contrôleurs (replica, job, node…)
* C. Des scripts bash
* D. kube-proxy

**Réponse : B**

---

#### **22. kube-apiserver utilise quel protocole ?**

* A. FTP
* B. HTTP/HTTPS
* C. SSH
* D. TCP brut

**Réponse : B**

---

#### **23. Qui vérifie que les Pods demandés existent toujours ?**

* A. kubelet
* B. kube-controller-manager
* C. docker
* D. helm

**Réponse : B**

---

#### **24. Quelle commande permet de voir les Pods ?**

* A. `kubectl pods`
* B. `kubectl get pods`
* C. `kube-pod list`
* D. `kubectl ls`

**Réponse : B**

---

#### **25. Un nœud peut contenir :**

* A. Plusieurs Pods
* B. Un seul Pod
* C. Aucun Pod
* D. Un seul conteneur

**Réponse : A**

---

#### **26. kubelet communique avec :**

* A. docker uniquement
* B. le plan de contrôle uniquement
* C. kube-apiserver et le conteneur runtime
* D. GitHub

**Réponse : C**

---

#### **27. Un Pod est :**

* A. Un conteneur Docker
* B. Une VM
* C. Un ou plusieurs conteneurs avec un espace réseau partagé
* D. Un exécutable

**Réponse : C**

---

#### **28. Que fait le kube-scheduler quand un nœud est plein ?**

* A. Redémarre les Pods
* B. Attribue à un autre nœud
* C. Ignore le Pod
* D. Supprime le nœud

**Réponse : B**

---

#### **29. Qu'est-ce qui rend Kubernetes "déclaratif" ?**

* A. On écrit du code
* B. On déclare un état désiré, pas des étapes
* C. On donne des scripts impératifs
* D. On utilise Python

**Réponse : B**

---

#### **30. Un cluster avec 1 nœud, c’est possible ?**

* A. Oui, pour test ou dev
* B. Non, minimum 3
* C. Oui, mais en production uniquement
* D. Non, Kubernetes exige 10 nœuds

**Réponse : A**


