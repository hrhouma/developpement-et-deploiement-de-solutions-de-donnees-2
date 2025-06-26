# Les Modules Ansible

## 1. Introduction

- Un **module Ansible** est un composant autonome et réutilisable qui exécute une tâche bien définie sur un ou plusieurs hôtes cibles. C’est l’unité de base qui permet à Ansible d’interagir avec les systèmes distants. Lorsqu’on exécute une commande ad-hoc ou un playbook, Ansible invoque des modules pour réaliser les actions souhaitées (installer un paquet, copier un fichier, configurer un service, etc.).




### C’est quoi un module Ansible  (version simple) ?

Un **module Ansible**, c’est une petite brique qui fait une tâche bien précise.

Quand tu écris un **playbook** (un script Ansible), tu ne fais pas les actions toi-même. Tu demandes à Ansible de les faire **pour toi**. Et pour chaque action, Ansible utilise un **module**.



### Comparaison simple

Imagine Ansible comme un chef de chantier.

* Le chef de chantier (Ansible) lit un plan (le playbook).
* Pour chaque tâche, il utilise un **outil** (un module).
* Ces outils sont déjà prêts. Tu n’as pas besoin de les fabriquer.



### Exemples concrets

Tu veux installer un logiciel sur une machine Linux ?
→ Tu utilises le module `apt` (ou `yum` selon la distribution).

Tu veux copier un fichier d’un dossier à un autre ?
→ Tu utilises le module `copy`.

Tu veux créer un utilisateur ?
→ Tu utilises le module `user`.



### Exemple dans un playbook

```yaml
- name: Installer nginx
  ansible.builtin.apt:
    name: nginx
    state: present
```

Ce que ça signifie :

* On demande d’**installer nginx**
* Le module utilisé est **apt**
* On indique que l’état souhaité est : **présent** (donc installé)



### Ce qu’il faut retenir

* Les **modules** sont des **actions préprogrammées**.
* Tu les appelles avec des paramètres simples.
* Tu n’as **pas besoin de coder toi-même la logique**.
* Ansible s’occupe de tout. Toi, tu écris juste **quoi faire**, pas **comment le faire**.

### Revenons à la définition d'un module ansible (profesionnel)!

- Donc, les **modules Ansible** sont des unités de travail autonomes qui accomplissent des tâches spécifiques sur les hôtes cibles. Ils constituent le cœur de la puissance d’Ansible, permettant d'automatiser des actions comme l'installation de paquets, la gestion de services, la copie de fichiers ou la configuration réseau. Chaque module est conçu pour accomplir une tâche précise de manière déclarative : au lieu de décrire comment exécuter une action, on déclare l'état final souhaité. Ansible inclut des centaines de modules intégrés, organisés par catégories (fichiers, utilisateurs, cloud, Docker, bases de données, etc.), et il est possible d’en développer de nouveaux en Python. Lorsqu’un playbook est exécuté, Ansible appelle les modules nécessaires pour exécuter chaque tâche sur les machines distantes, puis collecte le résultat pour évaluer le succès, les changements ou les erreurs. Grâce à leur simplicité et leur réutilisabilité, les modules Ansible favorisent une automatisation claire, robuste et évolutive.


## 2. Caractéristiques des Modules Ansible

* **Idempotence** : Un module n’exécute une action que si nécessaire. Il ne modifie pas inutilement l’état du système.
* **Portabilité** : Fonctionne sur plusieurs distributions Linux, Windows, cloud, conteneurs.
* **Modularité** : Des milliers de modules sont disponibles, chacun conçu pour un usage précis.
* **Réutilisabilité** : Peuvent être invoqués depuis un playbook, une commande ad-hoc ou l’API Python d’Ansible.

## 3. Utilisation des Modules

### 3.1. Commande ad-hoc

```bash
ansible all -m ping -i inventory.ini
```

Ici, `ping` est le module utilisé pour tester la connectivité.

### 3.2. Dans un playbook

```yaml
- name: Installer Apache
  hosts: web
  become: yes
  tasks:
    - name: Installer apache2
      apt:
        name: apache2
        state: present
```

## 4. Principales Catégories de Modules

### 4.1 Modules de gestion de paquets

| Nom       | Distribution     | Description                                        |
| --------- | ---------------- | -------------------------------------------------- |
| `apt`     | Debian/Ubuntu    | Gérer les paquets via apt                          |
| `yum`     | RedHat/AlmaLinux | Gérer les paquets via yum                          |
| `dnf`     | Fedora/EL8+      | Gérer les paquets via dnf                          |
| `package` | Tous             | Interface générique (utilise apt/yum/dnf selon OS) |

### 4.2 Modules de services

| Nom       | Description                                  |
| --------- | -------------------------------------------- |
| `service` | Gère un service sans spécifier l’init system |
| `systemd` | Spécifique aux distributions avec systemd    |

### 4.3 Modules de fichiers

| Nom          | Description                                               |
| ------------ | --------------------------------------------------------- |
| `copy`       | Copier un fichier local vers une machine distante         |
| `template`   | Générer un fichier depuis un template Jinja2              |
| `file`       | Créer, supprimer ou modifier les permissions d'un fichier |
| `lineinfile` | Modifier une ligne spécifique dans un fichier texte       |
| `unarchive`  | Extraire des archives (tar, zip...)                       |

### 4.4 Modules de commandes

| Nom       | Description                                                               |
| --------- | ------------------------------------------------------------------------- |
| `command` | Exécute une commande sans shell                                           |
| `shell`   | Exécute une commande via shell (permet l’usage de pipes, redirections...) |
| `raw`     | Exécute une commande brute sans module Python                             |

### 4.5 Modules utilisateurs/groupes

| Nom     | Description                    |
| ------- | ------------------------------ |
| `user`  | Crée ou modifie un utilisateur |
| `group` | Crée ou modifie un groupe      |

### 4.6 Modules réseau et pare-feu

| Nom         | Description                       |
| ----------- | --------------------------------- |
| `ufw`       | Gère le pare-feu ufw              |
| `firewalld` | Gère le pare-feu Firewalld        |
| `iptables`  | Règles de pare-feu personnalisées |

### 4.7 Modules Cloud

| Nom                                 | Fournisseur |
| ----------------------------------- | ----------- |
| `amazon.aws.ec2`                    | AWS         |
| `google.cloud.gcp_compute_instance` | GCP         |
| `azure.azcollection.azure_rm_*`     | Azure       |

### 4.8 Modules conteneurs (Docker, K8s)

| Nom                                 | Description              |
| ----------------------------------- | ------------------------ |
| `community.docker.docker_container` | Gère un conteneur Docker |
| `community.kubernetes.k8s`          | Gère un objet Kubernetes |

### 4.9 Modules de monitoring

| Nom                  | Description                                  |
| -------------------- | -------------------------------------------- |
| `grafana_dashboard`  | Crée un dashboard Grafana via API            |
| `grafana_datasource` | Déclare une datasource Grafana               |
| `prometheus`         | Modules communautaires de gestion Prometheus |

### 4.10 Modules Windows

| Nom           | Description                          |
| ------------- | ------------------------------------ |
| `win_user`    | Gère les comptes utilisateur Windows |
| `win_service` | Gère les services Windows            |
| `win_copy`    | Copie des fichiers Windows           |

## 5. Explorer les modules localement

```bash
# Lister tous les modules disponibles
ansible-doc -l

# Chercher un mot-clé
ansible-doc -l | grep docker

# Voir la documentation d’un module
ansible-doc apt
```

## 6. Bonnes pratiques

* Utiliser des modules idempotents (pas `shell` sauf en dernier recours).
* Préférer `template` à `copy` si vous avez besoin de variables dynamiques.
* Utiliser `package` si vous voulez cibler plusieurs OS avec un seul playbook.
* Lire la doc de chaque module avec `ansible-doc` pour éviter les erreurs.

## 7. Ressources utiles

* Documentation officielle : [https://docs.ansible.com/ansible/latest/collections/index\_module.html](https://docs.ansible.com/ansible/latest/collections/index_module.html)
* Ansible Galaxy (modules & rôles communautaires) : [https://galaxy.ansible.com/](https://galaxy.ansible.com/)
* Guide des modules : [https://docs.ansible.com/ansible/latest/user\_guide/modules\_intro.html](https://docs.ansible.com/ansible/latest/user_guide/modules_intro.html)


## 8. Résumé


| **Collection**        | **Modules-clés (exemples)**                                                                   | **Description exhaustive**                                                                                                                                                                                                                                                                                                 |
| --------------------- | --------------------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **ansible.builtin**   | `apt`, `yum`, `service`, `copy`, `template`, `file`, `user`, `lineinfile`, `command`, `debug` | Ensemble de modules et de plugins livrés **nativement** avec Ansible Core. Ils couvrent les opérations système courantes : gestion de paquets, services, fichiers, utilisateurs, exécution de commandes, etc. Utilisables sur la plupart des distributions Linux et BSD sans dépendances externes. ([docs.ansible.com][1]) |
| **ansible.posix**     | `authorized_key`, `mount`, `sysctl`, `selinux`, `firewalld`, `synchronize`                    | Collection dédiée aux plates-formes **POSIX et apparentées**. Fournit les modules nécessaires pour gérer les ACL, points de montage, paramètres noyau, SELinux, pare-feu, synchronisation de répertoires ; idéale pour l’administration fine d’Unix-like. ([docs.ansible.com][2])                                          |
| **ansible.netcommon** | `cli_command`, `cli_config`, `netconf_get`, `net_put`, `net_ping`                             | Contient le socle **réutilisable** pour l’automatisation réseau : wrappers CLI, gestion NETCONF/RESTCONF, transfert de fichiers vers équipements, opérations de test réseau. Ces modules sont partagés par les collections spécifiques aux constructeurs afin d’offrir une API uniforme. ([docs.ansible.com][3])           |
| **ansible.windows**   | `win_copy`, `win_service`, `win_user`, `win_firewall`, `win_updates`, `win_shell`             | Modules pour automatiser **Windows Server / Desktop** : copie de fichiers, gestion de services, comptes locaux, pare-feu, mises à jour, scripts PowerShell. Toutes les tâches utilisent WinRM et respectent l’idéologie déclarative d’Ansible pour l’administration Windows. ([docs.ansible.com][4])                       |
| **amazon.aws**        | `ec2_instance`, `s3_bucket`, `cloudformation`, `route53`, `rds_instance`, `iam_user`          | Couche d’abstraction complète pour **AWS** : provisionnement EC2, S3, RDS, IAM, CloudFormation, Route 53, etc. Vise à simplifier et fiabiliser la gestion des ressources cloud par des playbooks reproductibles, réduisant les erreurs manuelles et accélérant les déploiements. ([github.com][5], [docs.ansible.com][6])  |
| **arista.eos**        | `eos_command`, `eos_config`, `eos_interfaces`, `eos_vlans`, `eos_bgp_global`                  | Spécifique aux commutateurs **Arista EOS** : exécution de commandes, gestion de la configuration, interfaces, VLAN, BGP, etc. Permet d’automatiser l’infrastructure Arista via l’API eAPI ou le CLI tout en conservant la cohérence réseau. ([github.com][7])                                                              |
| **awx.awx**           | `job_launch`, `workflow_launch`, `inventory`, `credential`, `host`                            | Interface programmable vers l’API **AWX / Red Hat Automation Controller**. Ces modules orchestrent le lancement de jobs, la gestion d’inventaires, d’identifiants, de workflows, ce qui autorise l’auto-pilotage du serveur AWX à partir de playbooks. ([docs.ansible.com][8])                                             |



### Notes d’utilisation

1. **Index complet** : chaque collection expose l’intégralité de ses modules dans la documentation officielle Ansible (« Plugin Index »).
2. **Filtrage** : si vous avez besoin de la **liste exhaustive avec description module par module** pour une collection particulière (ex. `ansible.builtin`), indiquez-le : je pourrai extraire et formater les centaines d’entrées correspondantes.
3. **Mise à jour** : les versions de collections évoluent ; vérifiez les compatibilités Ansible Core avant de figer vos dépendances.

[1]: https://docs.ansible.com/ansible/latest/collections/ansible/builtin/index.html?utm_source=chatgpt.com "Ansible.Builtin — Ansible Community Documentation"
[2]: https://docs.ansible.com/ansible/latest/collections/ansible/posix/index.html?utm_source=chatgpt.com "Ansible.Posix — Ansible Community Documentation"
[3]: https://docs.ansible.com/ansible/latest/collections/ansible/netcommon/index.html?utm_source=chatgpt.com "Ansible.Netcommon — Ansible Community Documentation"
[4]: https://docs.ansible.com/ansible/latest/collections/ansible/windows/index.html?utm_source=chatgpt.com "Ansible.Windows — Ansible Community Documentation"
[5]: https://github.com/ansible-collections/amazon.aws?utm_source=chatgpt.com "Ansible Collection for Amazon AWS - GitHub"
[6]: https://docs.ansible.com/ansible/latest/collections/amazon/aws/index.html?utm_source=chatgpt.com "Amazon.Aws — Ansible Community Documentation"
[7]: https://github.com/ansible-collections/arista.eos?utm_source=chatgpt.com "Ansible Network Collection for Arista EOS - GitHub"
[8]: https://docs.ansible.com/ansible/latest/collections/awx/awx/index.html?utm_source=chatgpt.com "Awx.Awx — Ansible Community Documentation"






# Annexe 1 -  Quiz : Comprendre les modules Ansible 

### Question 1

Dans Ansible, un **module** sert à :
a) Créer des scripts Python
b) Définir l’ordre d’exécution des tâches
c) Exécuter une tâche précise (ex. : installer un paquet)
d) Lancer une machine virtuelle

---

### Question 2

Quel module Ansible est utilisé pour **installer un paquet** sur une machine Debian/Ubuntu ?
a) `yum`
b) `copy`
c) `apt`
d) `service`

---

### Question 3

Quel module sert à **copier un fichier** sur une machine distante ?
a) `template`
b) `copy`
c) `file`
d) `fetch`

---

### Question 4

Lequel de ces modules sert à **gérer les services** (ex. : nginx, apache) ?
a) `service`
b) `user`
c) `ping`
d) `package`

---

### Question 5

Tu veux ajouter un nouvel utilisateur Linux avec Ansible. Quel module utilises-tu ?
a) `adduser`
b) `user`
c) `passwd`
d) `group`

---

### Question 6

Dans un playbook Ansible, où se trouve le nom du module ?
a) Dans la section `hosts`
b) Dans la ligne `name:`
c) Juste après la ligne `- name:`
d) Juste sous `- name:`, avec le nom du module comme clé

---

### Question 7

Quel module te permet d’**exécuter une commande brute** sur la machine distante ?
a) `command`
b) `copy`
c) `ping`
d) `template`

---

### Question 8

À quoi sert le module `template` ?
a) À créer des répertoires vides
b) À envoyer un fichier statique
c) À envoyer un fichier **Jinja2** avec variables
d) À chiffrer des fichiers



<br/>

# Annexe 2 - Exempels de code



### 1. Utiliser le module `apt` pour installer un paquet Debian

```yaml
- name: Installer le paquet nginx
  ansible.builtin.apt:
    name: nginx
    state: present
```

---

### 2. Utiliser le module `yum` pour installer un paquet RedHat/CentOS

```yaml
- name: Installer httpd (Apache)
  ansible.builtin.yum:
    name: httpd
    state: latest
```

---

### 3. Utiliser le module `copy` pour copier un fichier

```yaml
- name: Copier un fichier de configuration
  ansible.builtin.copy:
    src: ./nginx.conf
    dest: /etc/nginx/nginx.conf
    owner: root
    group: root
    mode: '0644'
```

---

### 4. Utiliser le module `user` pour créer un utilisateur

```yaml
- name: Créer un utilisateur nommé "alice"
  ansible.builtin.user:
    name: alice
    state: present
```

---

### 5. Utiliser le module `service` pour démarrer un service

```yaml
- name: Démarrer le service nginx
  ansible.builtin.service:
    name: nginx
    state: started
    enabled: true
```

---

### 6. Utiliser le module `lineinfile` pour modifier un fichier texte

```yaml
- name: Ajouter une ligne dans /etc/hosts
  ansible.builtin.lineinfile:
    path: /etc/hosts
    line: "192.168.1.10 serveur1.local"
    create: yes
```

---

### 7. Utiliser le module `debug` pour afficher un message

```yaml
- name: Afficher un message de test
  ansible.builtin.debug:
    msg: "Déploiement terminé avec succès"
```

---

### 8. Utiliser le module `command` pour exécuter une commande

```yaml
- name: Lister les fichiers du répertoire /etc
  ansible.builtin.command:
    cmd: ls -l /etc
```



