### **Partie 3**  

**Votre mission :**  
- Identifiez les erreurs dans les 5 playbooks
- Expliquez pourquoi ces erreurs sont problématiques.  
- Proposez une correction


---

## **Playbook 1 - Installer Apache**  


```yaml
---
- name: Installer un package sur Ubuntu
  hosts: all
  become: yes
  tasks:
    - name: Installer Apache
      apt:
      name: apache2
      state: present
```

# **Questions :**  
1. Quel problème syntaxique pourrait empêcher ce playbook de fonctionner ?
2. Identifiez les erreurs
3. Expliquez pourquoi ces erreurs sont problématiques.
4. Proposez une correction

---

## **Playbook 2 - Mettre à jour le système**  


```yaml
---
- name: Mettre à jour le système
  hosts: all
  become: yes
  tasks:
    - name: Mise à jour du système
      yum:
        update_cache: yes
```

## N.B:
- Les handlers dans Ansible sont des tâches spéciales qui ne s’exécutent que si elles sont appelées via notify. Ils sont souvent utilisés pour redémarrer un service après une modification, comme l'installation d'un package ou la modification d'un fichier de configuration

# **Questions :**  
1. Ce playbook fonctionnera-t-il sur Ubuntu ? Pourquoi ?  
2. Identifiez les erreurs (la distribution d'au moins une machine worker est ubuntu22.04)
3. Expliquez pourquoi ces erreurs sont problématiques.
4. Proposez une correction

---

## **Playbook 3 - Créer un utilisateur**  
 **Niveau facile**  

```yaml
---
- name: Créer un utilisateur
  hosts: all
  become: yes
  vars:
    user: "deploy"
  tasks:
    - name: Ajouter l'utilisateur
      user:
        name: "{{ utilisateur }}"
        shell: /bin/bash
```

# **Questions :**  
1. Ce playbook va-t-il créer l’utilisateur correctement ? Pourquoi ?
2. Identifiez les erreurs (la distribution d'au moins une machine worker est ubuntu22.04)
3. Expliquez pourquoi ces erreurs sont problématiques.
4. Proposez une correction

---

## **Playbook 4 - Installer Docker**  


```yaml
---
- name: Installer Docker
  hosts: all
  become: yes
  tasks:
    - name: Installer Docker sur Ubuntu et CentOS
      yum:
        name: docker
        state: present
```

#  **Questions :**  
1. Ce playbook fonctionnera-t-il sur Ubuntu ? Pourquoi ?  
2. Existe-t-il une meilleure approche pour gérer plusieurs distributions ?
3. Expliquez pourquoi ces erreurs sont problématiques.
4. Proposez une correction

---

## **Playbook 5**




```yaml
- name: Deploiement avec erreurs
  hosts: all
  become: yes
  tasks:
    - name: Installer Apache
      apt:
      name: apache2
      state: latest

    - name: Ajouter un utilisateur
     user:
        name: deploy
       shell: /bin/bash

    - name: Démarrer le service Apache
      service:
     name: apache2
       state: running

    - name: Installer Nginx
     apt:
       name: nginx
      state: latest

    - name: Creer un dossier
      file:
     path: /opt/app
       state: directory
      mode: '0755'

    - name: Copier un fichier
     copy:
      src: files/index.html
       dest: /var/www/html/index.html

  handlers:
    - name: Restart Apache
    service:
     name: apache2
      state: restarted
```



# **Questions :**  
1. Ce playbook peut-il fonctionner sur CentOS et Ubuntu ? Pourquoi ?  
2. Y a-t-il des erreurs? Expliquez.  




---------------------------
# Annexe :
---------------------------



## Architecture de notre cluster


```
                          +----------------------+
                          |  Ansible Controller  |
                          |     Ubuntu 22.04     |
                          |  IP: 172.20.0.X      |
                          +----------------------+
                                     |
                                     |
        --------------------------------------------------------------------------
        |        |        |        |        |        |        |
   +---------+ +---------+ +---------+ +---------+ +---------+ +---------+ +---------+
   | Node1   | | Node2   | | Node3   | | Node4   | | Node5   | | Node6   | |  NodeX   |
   | Ubuntu  | | Debian  | | AlmaLin | | AlmaLin | | Ubuntu  | | Ubuntu  | |  (opt)  |
   | 172.20.0.2| 172.20.0.3| 172.20.0.4| 172.20.0.5| 172.20.0.6| 172.20.0.7|  ...    |
   +---------+ +---------+ +---------+ +---------+ +---------+ +---------+ +---------+

```

### Légende :
- **Ansible Controller** : Machine principale de contrôle sous Ubuntu 22.04.
- **Nodes (Node1 à Node6)** :
  - **Node1** : Ubuntu
  - **Node2** : Debian
  - **Node3, Node4** : AlmaLinux
  - **Node5, Node6** : Ubuntu
- Toutes les machines sont sur le réseau `ansible_network` avec des adresses IP statiques dans le sous-réseau `172.20.0.0/24`.




## Fichier docker-compose

```yaml
version: '3'

services:
  node1:
    image: ubuntu:latest
    container_name: node1
    networks:
      ansible_network:
        ipv4_address: 172.20.0.2
    command: /bin/bash -c "apt update && apt install -y openssh-server python3 && service ssh start && tail -f /dev/null"
    expose:
      - "22"
      - "80"

  node2:
    image: debian:latest
    container_name: node2
    networks:
      ansible_network:
        ipv4_address: 172.20.0.3
    command: /bin/bash -c "apt update && apt install -y openssh-server python3 && service ssh start && tail -f /dev/null"
    expose:
      - "22"
      - "80"

  node3:
    image: almalinux:latest
    container_name: node3
    networks:
      ansible_network:
        ipv4_address: 172.20.0.4
    command: /bin/bash -c "yum update -y && yum install -y openssh-server passwd python3 && echo 'root:root' | chpasswd && ssh-keygen -A && /usr/sbin/sshd -D"
    expose:
      - "22"
      - "80"

  node4:
    image: almalinux:latest
    container_name: node4
    networks:
      ansible_network:
        ipv4_address: 172.20.0.5
    command: /bin/bash -c "yum update -y && yum install -y openssh-server passwd python3 && echo 'root:root' | chpasswd && ssh-keygen -A && /usr/sbin/sshd -D"
    expose:
      - "22"
      - "80"

  node5:
    image: ubuntu:latest
    container_name: node5
    networks:
      ansible_network:
        ipv4_address: 172.20.0.6
    command: /bin/bash -c "apt update && apt install -y openssh-server python3 && service ssh start && tail -f /dev/null"
    expose:
      - "22"
      - "80"

  node6:
    image: ubuntu:latest
    container_name: node6
    networks:
      ansible_network:
        ipv4_address: 172.20.0.7
    command: /bin/bash -c "apt update && apt install -y openssh-server python3 && service ssh start && tail -f /dev/null"
    expose:
      - "22"
      - "80"

networks:
  ansible_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
```


## Fichier inventaire

```ini
[node_containers]
node1 ansible_host=172.20.0.2 ansible_user=root ansible_python_interpreter=/usr/bin/python3
node2 ansible_host=172.20.0.3 ansible_user=root ansible_python_interpreter=/usr/bin/python3
node3 ansible_host=172.20.0.4 ansible_user=root ansible_python_interpreter=/usr/bin/python3
node4 ansible_host=172.20.0.5 ansible_user=root ansible_python_interpreter=/usr/bin/python3
node5 ansible_host=172.20.0.6 ansible_user=root ansible_python_interpreter=/usr/bin/python3
node6 ansible_host=172.20.0.7 ansible_user=root ansible_python_interpreter=/usr/bin/python3

[web]
node1
node5

[database]
node2
node3

[mail]
node4
node6
```



