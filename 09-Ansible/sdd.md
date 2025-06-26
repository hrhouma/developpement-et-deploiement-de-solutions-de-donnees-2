# TP – Explications du déploiement de Prometheus et Grafana avec Ansible 

Ce TP détaille chaque étape du déploiement : inventaire, variables, playbooks, modèles et vérifications. Les blocs de code contiennent désormais des **commentaires inline** (#) pour expliquer chaque directive Ansible. Après chaque section, un paragraphe **« Pourquoi ? / Bonnes pratiques »** explicite la logique.


# 1. Inventaire initial

Le fichier `inventory.ini` définit les hôtes cibles et leurs IP statiques. Le groupe `[monitoring]` est celui sur lequel seront déployés Prometheus et Grafana.

```ini
[node_containers]
# Chaque conteneur Docker ou VM avec son IP et l’utilisateur root
node1 ansible_host=172.20.0.2 ansible_user=root
node2 ansible_host=172.20.0.3 ansible_user=root
node3 ansible_host=172.20.0.4 ansible_user=root
node4 ansible_host=172.20.0.5 ansible_user=root
node5 ansible_host=172.20.0.6 ansible_user=root
node6 ansible_host=172.20.0.7 ansible_user=root

[monitoring]
# Nœud où l’on installe Prometheus + Grafana (changez ou ajoutez d’autres nœuds au besoin)
node1
```

**Pourquoi ?**

* Séparer les groupes permet de cibler certaines machines (monitoring, base de données, etc.).
* Utiliser des IP statiques simplifie les connexions SSH et le dépannage.





##  Objectif général

Le fichier `inventory.ini` est le **point d’entrée principal** pour Ansible :
Il indique **quelles machines** doivent être ciblées, **comment s’y connecter**, et **comment les organiser** par rôles ou groupes fonctionnels.



##  Contenu commenté

```ini
[node_containers]
```

* Ce bloc définit un **groupe logique** de machines appelé `node_containers`.
* Il peut être utilisé pour appliquer des tâches communes à toutes les machines Docker ou VM du projet.
* Ce nom n’a pas de signification particulière pour Ansible, mais il est utile pour la lisibilité humaine.

---

```ini
node1 ansible_host=172.20.0.2 ansible_user=root
```

* `node1` : nom court de la machine (ou alias) utilisé dans les playbooks.
* `ansible_host=172.20.0.2` : **adresse IP ou nom DNS** de la machine réelle à contacter.

  * Cela permet de dissocier le nom logique (ici `node1`) de l’IP réelle.
* `ansible_user=root` : Ansible se connectera en tant que `root` sur cette machine.

  * Cela suppose que soit :

    * l’accès SSH root est autorisé, ou
    * l’utilisateur courant peut se connecter avec une clé privée valide.



Les lignes suivantes suivent exactement le même format pour `node2`, `node3`, etc. :

```ini
node2 ansible_host=172.20.0.3 ansible_user=root
node3 ansible_host=172.20.0.4 ansible_user=root
...
```

Ces entrées permettent à Ansible de connaître **l'ensemble des nœuds** disponibles dans l'infrastructure.

---

```ini
[monitoring]
```

* Ce bloc définit un **groupe fonctionnel** spécifique à la supervision.
* Il contiendra uniquement les hôtes **où seront déployés Prometheus et Grafana**.
* Ici, seul `node1` est membre de ce groupe.

```ini
node1
```

* Ce nom fait référence à `node1` déjà défini dans le groupe `node_containers`.
* Cela signifie que toutes les tâches du playbook qui ciblent `hosts: monitoring` ne seront **appliquées qu’à `node1`**.



##  Pourquoi cette structure ?

### 1. **Groupes séparés = modularité**

* Vous pouvez avoir d'autres groupes plus tard :

  * `[webservers]` pour NGINX
  * `[databases]` pour PostgreSQL
  * `[workers]` pour des jobs spécifiques
* Cela permet d’écrire des playbooks ciblés pour chaque rôle.

### 2. **Reproductibilité**

* En gardant les IP statiques dans un fichier clair :

  * Plus facile à relire
  * Plus stable pour les déploiements automatisés
  * Utile pour le debugging (on sait sur quelle machine Ansible agit)

### 3. **Flexibilité**

* Vous pouvez ajouter plusieurs machines dans `[monitoring]` si vous souhaitez redonder Prometheus ou Grafana.
* Rien ne vous empêche d’écrire :

  ```ini
  [monitoring]
  node1
  node2
  ```

  Dans ce cas, le playbook `hosts: monitoring` s’exécuterait **sur `node1` et `node2`**.


##  Conclusion pédagogique

Ce fichier `inventory.ini` est **indispensable** à Ansible. Il définit **le parc cible** et **les rôles logiques** de chaque machine.
Dans un TP ou un projet réel, bien structurer cet inventaire permet :

* d’avoir des déploiements **répétables et modulables**
* de cibler **des groupes spécifiques** facilement
* de garantir **la lisibilité et la maintenance** du code d’automatisation




<br/>

# 2. Arborescence du projet

Organisation minimale recommandée :

```plaintext
ansible_monitoring/
├── inventory.ini              # Inventaire statique
├── prometheus.yml             # Playbook Prometheus
├── grafana.yml                # Playbook Grafana
├── vars/
│   └── global.yml             # Variables partagées
└── templates/
    ├── prometheus.yml.j2      # Template de configuration Prometheus
    └── grafana.ini.j2         # Template de configuration Grafana
```

**Pourquoi ?** Cette arborescence sépare clairement les rôles :

* `vars` pour les variables globales ou de groupe.
* `templates` pour les fichiers Jinja2 générés dynamiquement.
* Un playbook par composant facilite l’exécution sélective (`--tags` ou exécution ciblée).



# 3. Variables globales – `vars/global.yml`

```yaml
prometheus_version: "2.52.0"          # Version exacte à déployer (évite les surprises)
grafana_admin_user: admin              # Super‑utilisateur Grafana (à chiffrer avec Vault en prod)
grafana_admin_password: admin          # Mot de passe initial (Vault conseillé en prod)
```

**Pourquoi ?** Centraliser les versions et secrets facilite la maintenance. Un changement de version se fait en un seul endroit.






## Explication détaillée

### Section 3 : variables globales — `vars/global.yml`

```yaml
prometheus_version: "2.52.0"          # Version précise à déployer
grafana_admin_user: admin             # Nom du compte administrateur Grafana
grafana_admin_password: admin         # Mot de passe initial (à chiffrer avec Vault en production)
```

#### Ligne 1

`prometheus_version` indique la version exacte de Prometheus à installer.

* Fixer explicitement la version garantit un déploiement reproductible.
* Un changement de version ne nécessite qu’une modification dans ce fichier.

#### Ligne 2

`grafana_admin_user` définit l’identifiant du premier compte administrateur Grafana.

* Cette valeur est reprise dans le template `grafana.ini.j2`.
* Elle est requise pour la première connexion à l’interface Web.

#### Ligne 3

`grafana_admin_password` est le mot de passe associé au compte administrateur.

* Ce champ contient une donnée sensible ; en environnement réel, il doit être chiffré avec Ansible Vault et exclu de tout dépôt public.
* Pour un exercice local, la valeur par défaut peut rester simple.

### Pourquoi centraliser ces variables ?

1. **Maintenance simplifiée**
   Tous les paramètres critiques (versions, comptes, secrets) se trouvent au même endroit ; une mise à jour s’effectue en une seule modification.

2. **Réutilisation**
   Le fichier est chargé par plusieurs playbooks via la directive `vars_files`; une même valeur est partagée sans duplication.

3. **Lisibilité**
   Un nouvel arrivant sur le projet identifie immédiatement les versions déployées et les informations d’authentification initiales.

4. **Sécurité**
   Les secrets peuvent être chiffrés sans toucher au reste du code :

   ```bash
   ansible-vault encrypt vars/global.yml
   ```

   Les playbooks continuent de fonctionner après déchiffrement automatique par Ansible.

### Chargement dans un playbook

```yaml
vars_files:
  - vars/global.yml
```

Cette directive rend toutes les variables de `global.yml` disponibles dans le playbook ainsi que dans les templates Jinja2.

### Recommandations supplémentaires

* Déplacer les mots de passe vers un fichier `vars/secrets.yml` et le chiffrer avec Vault.
* Versionner également les éventuels exporters (Node Exporter, Alertmanager, etc.) dans ce même fichier.
* Éviter de coder en dur toute valeur changeante directement dans les playbooks ou les templates.




# 4. Playbook `prometheus.yml` (commenté)

```yaml
---
- name: Déployer Prometheus
  hosts: monitoring          # Cible le groupe [monitoring]
  become: yes                # Exécute en root (sudo)
  vars_files:
    - vars/global.yml        # Importe les variables globales

  tasks:
    - name: Créer le groupe prometheus
      group:
        name: prometheus
        system: yes          # Groupe système (UID < 1000)

    - name: Créer l’utilisateur prometheus
      user:
        name: prometheus
        shell: /usr/sbin/nologin  # Empêche la connexion interactive
        group: prometheus
        system: yes

    - name: Installer les prérequis (Debian/Ubuntu)
      apt:
        name: [curl, tar, gzip]
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'

    - name: Installer les prérequis (RedHat/AlmaLinux)
      yum:
        name: [curl, tar, gzip]
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'RedHat'

    - name: Définir le répertoire Prometheus (variable dérivée)
      set_fact:
        prometheus_dir: "/opt/prometheus-{{ prometheus_version }}.linux-amd64"

    - name: Télécharger l’archive Prometheus
      get_url:
        url: "https://github.com/prometheus/prometheus/releases/download/v{{ prometheus_version }}/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
        dest: /tmp/prometheus.tar.gz
        mode: "0644"

    - name: Extraire Prometheus dans /opt
      unarchive:
        src: /tmp/prometheus.tar.gz
        dest: /opt/
        remote_src: yes        # Archive déjà sur l’hôte

    - name: Appliquer les droits à prometheus
      file:
        path: "{{ prometheus_dir }}"
        state: directory
        recurse: yes
        owner: prometheus
        group: prometheus

    - name: Copier la configuration Prometheus
      template:
        src: templates/prometheus.yml.j2
        dest: /etc/prometheus.yml
        owner: prometheus
        group: prometheus
        mode: "0644"
      notify: Restart Prometheus  # Relance si le template change

    - name: Créer le service Prometheus (systemd)
      copy:
        dest: /etc/systemd/system/prometheus.service
        mode: "0644"
        content: |
          [Unit]
          Description=Prometheus
          After=network.target

          [Service]
          User=prometheus
          ExecStart={{ prometheus_dir }}/prometheus \
            --config.file=/etc/prometheus.yml \
            --storage.tsdb.path={{ prometheus_dir }}/data
          Restart=on-failure

          [Install]
          WantedBy=multi-user.target
      notify: Reload systemd

    - name: S’assurer que Prometheus est démarré
      systemd:
        name: prometheus
        state: started
        enabled: yes

  handlers:
    - name: Reload systemd
      systemd:
        daemon_reload: yes

    - name: Restart Prometheus
      systemd:
        name: prometheus
        state: restarted
        enabled: yes
```

**Pourquoi / bonnes pratiques**

1. **Idempotence** : `user`, `group`, `file`, `template`, `systemd` assurent un état cible.
2. **Variable `prometheus_dir`** : évite la répétition et simplifie la montée de version.
3. **Handlers** : ne redémarrent le service que si nécessaire (après changement de configuration ou after reload).
4. **Bloc conditionnel** `when` gère Debian vs RedHat sans dupliquer tout le playbook.



# Commentaires - Playbook `prometheus.yml` 

```yaml
---
- name: Déployer Prometheus
```

**But du playbook :** déployer et configurer Prometheus sur un ou plusieurs hôtes définis comme serveurs de supervision.

---

```yaml
  hosts: monitoring
```

**Cible d’exécution :** groupe d’hôtes `[monitoring]` dans le fichier `inventory.ini`. Cela permet d’exécuter le playbook sur une ou plusieurs machines précises.

---

```yaml
  become: yes
```

**Élévation de privilèges :** toutes les tâches seront exécutées avec `sudo`, indispensable pour manipuler `/etc`, `/opt`, et `systemd`.

---

```yaml
  vars_files:
    - vars/global.yml
```

**Chargement des variables :** importe les valeurs globales comme `prometheus_version`, utilisées dans tout le playbook. Permet de modifier les versions ou mots de passe à un seul endroit.

---

## Bloc `tasks` : toutes les étapes de déploiement

```yaml
  tasks:
```

---

```yaml
    - name: Créer le groupe prometheus
      group:
        name: prometheus
        system: yes
```

**Objectif :** créer un groupe système dédié à Prometheus, utilisé pour l’isolation des permissions (meilleure sécurité).

---

```yaml
    - name: Créer l’utilisateur prometheus
      user:
        name: prometheus
        shell: /usr/sbin/nologin
        group: prometheus
        system: yes
```

**Objectif :** créer un utilisateur système sans shell interactif, uniquement utilisé par Prometheus pour exécuter le service. Cela respecte les bonnes pratiques de sécurité Linux.

---

```yaml
    - name: Installer les prérequis (Debian/Ubuntu)
      apt:
        name: [curl, tar, gzip]
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'
```

**Objectif :** installer les paquets nécessaires à l’extraction de l’archive `.tar.gz`. Cette tâche est conditionnelle : elle s'exécute uniquement si l’OS appartient à la famille Debian.

---

```yaml
    - name: Installer les prérequis (RedHat/AlmaLinux)
      yum:
        name: [curl, tar, gzip]
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'RedHat'
```

**Même logique**, mais pour les hôtes utilisant `yum` (RedHat, AlmaLinux, CentOS).

---

```yaml
    - name: Définir le répertoire Prometheus (variable dérivée)
      set_fact:
        prometheus_dir: "/opt/prometheus-{{ prometheus_version }}.linux-amd64"
```

**Déclaration dynamique :** crée une nouvelle variable `prometheus_dir` utilisée plus loin pour éviter de répéter manuellement le chemin long contenant le numéro de version. Cela améliore la lisibilité et la maintenabilité.

---

```yaml
    - name: Télécharger l’archive Prometheus
      get_url:
        url: "https://github.com/prometheus/prometheus/releases/download/v{{ prometheus_version }}/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
        dest: /tmp/prometheus.tar.gz
        mode: "0644"
```

**Objectif :** télécharge l’archive officielle de Prometheus depuis GitHub. Le fichier est enregistré temporairement sur le système cible.

---

```yaml
    - name: Extraire Prometheus dans /opt
      unarchive:
        src: /tmp/prometheus.tar.gz
        dest: /opt/
        remote_src: yes
```

**Objectif :** extrait l’archive téléchargée dans `/opt/`. L’option `remote_src: yes` indique que l’archive se trouve déjà sur l’hôte (et non sur la machine locale exécutant Ansible).

---

```yaml
    - name: Appliquer les droits à prometheus
      file:
        path: "{{ prometheus_dir }}"
        state: directory
        recurse: yes
        owner: prometheus
        group: prometheus
```

**Objectif :** applique les droits au répertoire contenant les binaires et les données de Prometheus.
Important pour que le service systemd fonctionne sans erreur de permission.

---

```yaml
    - name: Copier la configuration Prometheus
      template:
        src: templates/prometheus.yml.j2
        dest: /etc/prometheus.yml
        owner: prometheus
        group: prometheus
        mode: "0644"
      notify: Restart Prometheus
```

**Objectif :** déploie le fichier de configuration de Prometheus, généré dynamiquement via un template Jinja2.
**notify** indique que si le contenu du fichier change, le service sera redémarré.

---

```yaml
    - name: Créer le service Prometheus (systemd)
      copy:
        dest: /etc/systemd/system/prometheus.service
        mode: "0644"
        content: |
          [Unit]
          Description=Prometheus
          After=network.target

          [Service]
          User=prometheus
          ExecStart={{ prometheus_dir }}/prometheus \
            --config.file=/etc/prometheus.yml \
            --storage.tsdb.path={{ prometheus_dir }}/data
          Restart=on-failure

          [Install]
          WantedBy=multi-user.target
      notify: Reload systemd
```

**Objectif :** déclare un service `systemd` permettant à Prometheus de démarrer automatiquement au boot, et de redémarrer en cas d’erreur.
Le service exécute Prometheus avec les bons chemins et le bon utilisateur.

---

```yaml
    - name: S’assurer que Prometheus est démarré
      systemd:
        name: prometheus
        state: started
        enabled: yes
```

**Objectif :** active le service Prometheus (`enabled: yes`) pour qu’il démarre automatiquement, et le démarre immédiatement (`state: started`).

---

## Bloc `handlers`

Les handlers sont des tâches déclenchées uniquement si une autre tâche les notifie.

---

```yaml
  handlers:
    - name: Reload systemd
      systemd:
        daemon_reload: yes
```

**Objectif :** recharge la configuration des services `systemd` après création/modification d’un fichier `.service`. Nécessaire pour que le nouveau service soit reconnu.

---

```yaml
    - name: Restart Prometheus
      systemd:
        name: prometheus
        state: restarted
        enabled: yes
```

**Objectif :** redémarre Prometheus si un changement a été détecté dans le fichier de configuration ou autre.




<br/>


# 5. Playbook `grafana.yml` (commenté)

```yaml
---
- name: Déployer Grafana
  hosts: monitoring
  become: yes
  vars_files:
    - vars/global.yml

  tasks:
    - name: Installer dépendances Debian/Ubuntu
      apt:
        name:
          - apt-transport-https
          - software-properties-common
          - gnupg
          - ca-certificates
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'

    - name: Installer dépendances RedHat/AlmaLinux
      yum:
        name:
          - gnupg2
          - ca-certificates
          - curl
        state: present
      when: ansible_facts['os_family'] == 'RedHat'

    - name: Ajouter la clé GPG Grafana
      apt_key:
        url: https://packages.grafana.com/gpg.key
        state: present
      when: ansible_facts['os_family'] == 'Debian'

    - name: Ajouter le dépôt Grafana (Debian)
      apt_repository:
        repo: "deb https://packages.grafana.com/oss/deb stable main"
        state: present
      when: ansible_facts['os_family'] == 'Debian'

    - name: Ajouter le dépôt Grafana (RedHat)
      yum_repository:
        name: grafana
        description: Grafana Repo
        baseurl: https://packages.grafana.com/oss/rpm
        gpgcheck: yes
        gpgkey: https://packages.grafana.com/gpg.key
      when: ansible_facts['os_family'] == 'RedHat'

    - name: Mettre à jour le cache APT (Debian)
      apt:
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'

    - name: Installer Grafana (Debian)
      apt:
        name: grafana
        state: present
      when: ansible_facts['os_family'] == 'Debian'

    - name: Installer Grafana (RedHat)
      yum:
        name: grafana
        state: present
      when: ansible_facts['os_family'] == 'RedHat'

    - name: Copier la configuration Grafana
      template:
        src: templates/grafana.ini.j2
        dest: /etc/grafana/grafana.ini
        mode: "0644"
      notify: Restart Grafana

    - name: Attendre l’ouverture du port 3000
      wait_for:
        port: 3000
        delay: 2
        timeout: 30

    - name: S’assurer que Grafana est démarré
      systemd:
        name: grafana-server
        state: started
        enabled: yes

  handlers:
    - name: Restart Grafana
      systemd:
        name: grafana-server
        state: restarted
        enabled: yes
```

**Pourquoi / bonnes pratiques**

* Gestion RedHat vs Debian sans dupliquer tout le playbook.
* `wait_for` garantit que le service écoute avant de passer aux étapes suivantes ou aux vérifications.
* Les repositories officiels Grafana sont utilisés, assurant des mises à jour sûres.







# Commentaires - Playbook `grafana.yml`

```yaml
---
- name: Déployer Grafana
```

**Objectif global :** déployer et configurer Grafana sur une ou plusieurs machines cibles.

---

```yaml
  hosts: monitoring
```

**Cible d’exécution :** le groupe `[monitoring]` dans `inventory.ini`. On installe Grafana uniquement sur ce ou ces hôtes.

---

```yaml
  become: yes
```

**Élévation des privilèges :** toutes les commandes sont exécutées en tant que superutilisateur (`sudo`), ce qui est requis pour installer des paquets, modifier `/etc`, ou gérer des services.

---

```yaml
  vars_files:
    - vars/global.yml
```

**Import des variables :** permet de centraliser les valeurs comme `grafana_admin_user` et `grafana_admin_password`. Bonne pratique pour la maintenabilité.

---

## Bloc `tasks` — Instructions exécutées séquentiellement

---

```yaml
    - name: Installer dépendances Debian/Ubuntu
      apt:
        name:
          - apt-transport-https
          - software-properties-common
          - gnupg
          - ca-certificates
        state: present
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'
```

**Objectif :** installation des paquets nécessaires à l’ajout de dépôts APT et à la gestion des clés GPG.
**Condition :** ne s’applique que si l’OS est de type Debian (Ubuntu inclus).

---

```yaml
    - name: Installer dépendances RedHat/AlmaLinux
      yum:
        name:
          - gnupg2
          - ca-certificates
          - curl
        state: present
      when: ansible_facts['os_family'] == 'RedHat'
```

**Même logique**, mais pour les distributions basées sur `yum`. Les noms de paquets peuvent différer (ex : `gnupg2` au lieu de `gnupg`).

---

```yaml
    - name: Ajouter la clé GPG Grafana
      apt_key:
        url: https://packages.grafana.com/gpg.key
        state: present
      when: ansible_facts['os_family'] == 'Debian'
```

**Objectif :** importer la clé GPG nécessaire à la vérification des paquets provenant du dépôt Grafana.
**Condition :** spécifique aux systèmes Debian.

---

```yaml
    - name: Ajouter le dépôt Grafana (Debian)
      apt_repository:
        repo: "deb https://packages.grafana.com/oss/deb stable main"
        state: present
      when: ansible_facts['os_family'] == 'Debian'
```

**Objectif :** ajoute le dépôt APT de Grafana.
**Condition :** s’exécute uniquement sur des distributions Debian/Ubuntu.

---

```yaml
    - name: Ajouter le dépôt Grafana (RedHat)
      yum_repository:
        name: grafana
        description: Grafana Repo
        baseurl: https://packages.grafana.com/oss/rpm
        gpgcheck: yes
        gpgkey: https://packages.grafana.com/gpg.key
      when: ansible_facts['os_family'] == 'RedHat'
```

**Même opération**, mais pour RedHat et ses dérivés.
Cette tâche configure un dépôt YUM et active la vérification GPG.

---

```yaml
    - name: Mettre à jour le cache APT (Debian)
      apt:
        update_cache: yes
      when: ansible_facts['os_family'] == 'Debian'
```

**Objectif :** rafraîchir la base de données des paquets APT après ajout du nouveau dépôt.

---

```yaml
    - name: Installer Grafana (Debian)
      apt:
        name: grafana
        state: present
      when: ansible_facts['os_family'] == 'Debian'
```

**Installation du paquet Grafana** pour les distributions Debian.

---

```yaml
    - name: Installer Grafana (RedHat)
      yum:
        name: grafana
        state: present
      when: ansible_facts['os_family'] == 'RedHat'
```

**Installation du paquet Grafana** pour RedHat et dérivés.

---

```yaml
    - name: Copier la configuration Grafana
      template:
        src: templates/grafana.ini.j2
        dest: /etc/grafana/grafana.ini
        mode: "0644"
      notify: Restart Grafana
```

**Objectif :** déploie un fichier de configuration personnalisé (`grafana.ini`) grâce à un template Jinja2.
Le mot de passe et l’utilisateur sont injectés via des variables.
Le service est redémarré si ce fichier est modifié.

---

```yaml
    - name: Attendre l’ouverture du port 3000
      wait_for:
        port: 3000
        delay: 2
        timeout: 30
```

**Objectif :** s’assure que Grafana a bien démarré et qu’il écoute sur le port HTTP 3000.
Évite de lancer des vérifications ou des appels HTTP trop tôt.

---

```yaml
    - name: S’assurer que Grafana est démarré
      systemd:
        name: grafana-server
        state: started
        enabled: yes
```

**Finalisation :** active le service pour qu’il démarre au boot, et le lance immédiatement si nécessaire.

---

## Bloc `handlers` — déclenché par `notify`

---

```yaml
  handlers:
    - name: Restart Grafana
      systemd:
        name: grafana-server
        state: restarted
        enabled: yes
```

**Objectif :** redémarrer Grafana lorsqu’un changement de configuration est détecté (ex : fichier `grafana.ini`).
C’est une bonne pratique d’utiliser un handler pour éviter de redémarrer inutilement.




<br/>


# 6. Templates

### 6.1 `templates/prometheus.yml.j2`

```yaml
# Intervalle global de scrutation des cibles (15 s)
global:
  scrape_interval: 15s

scrape_configs:
  # Prometheus se scrute lui‑même
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
```

### 6.2 `templates/grafana.ini.j2`

```ini
[security]
admin_user = {{ grafana_admin_user }}
admin_password = {{ grafana_admin_password }}

[server]
http_port = 3000

[paths]
data = /var/lib/grafana
logs = /var/log/grafana
plugins = /var/lib/grafana/plugins
provisioning = /etc/grafana/provisioning

[users]
default_theme = dark
```

**Pourquoi ?** Le template permet :

* De renseigner dynamiquement le mot de passe Admin.
* De personnaliser le thème et les chemins.



# 7. Exécution des playbooks

```bash
ansible-playbook -i inventory.ini prometheus.yml   # Installe Prometheus
ansible-playbook -i inventory.ini grafana.yml      # Installe Grafana
```

L’ordre n’a pas d’importance, mais installer Prometheus d’abord permet de tester la datasource Grafana après déploiement.



# 8. Vérification manuelle

```bash
# Vérifier que les ports sont ouverts
ansible monitoring -m shell -a "ss -tulnp | grep -E '9090|3000'" -i inventory.ini
```

Accéder ensuite :

* Prometheus : [http://172.20.0.2:9090](http://172.20.0.2:9090)
* Grafana   : [http://172.20.0.2:3000](http://172.20.0.2:3000) (login admin / admin)




<br/>



# Commentaire détaillé des deux templates et des étapes finales



### 6.1  `templates/prometheus.yml.j2`

```yaml
# Intervalle global de scrutation des cibles (15 s)
global:
  scrape_interval: 15s
```

* **Section `global`** : Configure les paramètres par défaut de Prometheus.
* `scrape_interval` : fréquence à laquelle Prometheus interroge (scrape) chaque cible.
  Fixé ici à 15 secondes, valeur courante pour un lab.

```yaml
scrape_configs:
```

* Liste de toutes les cibles à interroger. Chaque entrée définit un **job**.

```yaml
  # Prometheus se scrute lui-même
  - job_name: "prometheus"
    static_configs:
      - targets: ["localhost:9090"]
```

* `job_name` : identifiant du job ; affiché dans l’interface Prometheus.
* `static_configs` : mode de découverte statique (pas de service-discovery automatisé).
* `targets` : liste d’URL `host:port` à sonder.
  Ici, Prometheus interroge sa propre instance sur `localhost:9090`.
  On obtient ainsi des métriques internes (temps de scrape, utilisation mémoire, etc.).

**Pourquoi ce template ?**

* Permet d’ajouter ou de modifier facilement des jobs (ex. Node Exporter, Alertmanager).
* Peut intégrer des variables Jinja2 si l’on souhaite générer dynamiquement les cibles.



### 6.2  `templates/grafana.ini.j2`

```ini
[security]
admin_user = {{ grafana_admin_user }}
admin_password = {{ grafana_admin_password }}
```

* Section `[security]` : définit l’utilisateur et le mot de passe administrateurs.
* Les valeurs proviennent de variables Ansible, ce qui évite le mot de passe en clair dans le dépôt.

```ini
[server]
http_port = 3000
```

* Port HTTP sur lequel Grafana écoute.
* Si un reverse-proxy est utilisé plus tard, il suffit de modifier ici.

```ini
[paths]
data = /var/lib/grafana
logs = /var/log/grafana
plugins = /var/lib/grafana/plugins
provisioning = /etc/grafana/provisioning
```

* Répertoires par défaut pour les données, les journaux, les plug-ins et les fichiers de provisioning.
* Ces chemins restent identiques quel que soit le package Debian ou RPM.

```ini
[users]
default_theme = dark
```

* Paramètre d’ergonomie ; définit le thème par défaut pour tous les utilisateurs.
* Peut être changé en `light` ou laissé vide pour le choix automatique.

**Pourquoi ce template ?**

* Injection dynamique de l’identifiant et du mot de passe.
* Possibilité de personnaliser d’autres paramètres (TLS, domaine, langue) sans toucher au playbook.



### 7. Exécution des playbooks

```bash
ansible-playbook -i inventory.ini prometheus.yml   # Installe Prometheus
ansible-playbook -i inventory.ini grafana.yml      # Installe Grafana
```

* Le premier playbook crée l’utilisateur, télécharge et configure Prometheus, puis active son service.
* Le second installe Grafana, configure le dépôt, copie `grafana.ini` et démarre le service.
* L’ordre peut être inversé, mais installer Prometheus d’abord permet ensuite de configurer une datasource dans Grafana et de vérifier immédiatement les métriques.



### 8. Vérification manuelle

```bash
ansible monitoring -m shell -a "ss -tulnp | grep -E '9090|3000'" -i inventory.ini
```

* Exécute la commande `ss` sur tous les hôtes du groupe `monitoring` pour lister les sockets TCP/UDP ouverts.
* Filtre les lignes correspondant aux ports 9090 (Prometheus) et 3000 (Grafana).
* Confirme que les services écoutent bien.

Accès via navigateur :

| Service    | URL d’accès              | Notes                                   |
| ---------- | ------------------------ | --------------------------------------- |
| Prometheus | `http://172.20.0.2:9090` | Interface native Prometheus             |
| Grafana    | `http://172.20.0.2:3000` | Identifiants initiaux : `admin / admin` |

Une fois connecté à Grafana :

1. Changer le mot de passe admin (obligatoire à la première connexion).
2. Ajouter une datasource de type Prometheus pointant vers `http://localhost:9090`.
3. Importer ou créer un tableau de bord pour visualiser les métriques.





# 9. Pistes d’amélioration

1. **node\_exporter** : exporter les métriques de chaque nœud, puis ajouter un bloc `scrape_configs` dans `prometheus.yml.j2`.
2. **Ansible Vault** : chiffrer `grafana_admin_password`.
3. **Module `grafana_dashboard`** : importer automatiquement un dashboard JSON.
4. **Pare‑feu** : ajouter des règles UFW/Firewalld pour 9090 et 3000.
5. **Tests actifs** : utiliser le module `uri` pour vérifier les codes HTTP 200 après déploiement.

