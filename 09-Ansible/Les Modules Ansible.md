# Guide Exhaustif : Les Modules Ansible

## 1. Introduction

Un **module Ansible** est un composant autonome et réutilisable qui exécute une tâche bien définie sur un ou plusieurs hôtes cibles. C’est l’unité de base qui permet à Ansible d’interagir avec les systèmes distants. Lorsqu’on exécute une commande ad-hoc ou un playbook, Ansible invoque des modules pour réaliser les actions souhaitées (installer un paquet, copier un fichier, configurer un service, etc.).

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


