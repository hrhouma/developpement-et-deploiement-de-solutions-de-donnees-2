# TP – Déploiement de Prometheus et Grafana avec Ansible

# 1. Inventaire initial

Créez un fichier **`inventory.ini`** avec le contenu suivant :

```ini
[node_containers]
node1 ansible_host=172.20.0.2 ansible_user=root
node2 ansible_host=172.20.0.3 ansible_user=root
node3 ansible_host=172.20.0.4 ansible_user=root
node4 ansible_host=172.20.0.5 ansible_user=root
node5 ansible_host=172.20.0.6 ansible_user=root
node6 ansible_host=172.20.0.7 ansible_user=root

[monitoring]
node1
```

Le groupe **`monitoring`** pointe ici sur **`node1`** ; vous pouvez ajouter d’autres nœuds si nécessaire.

<br/>


# 2. Arborescence du projet

```plaintext
ansible_monitoring/
├── inventory.ini
├── prometheus.yml
├── grafana.yml
├── vars/
│   └── global.yml
└── templates/
    ├── prometheus.yml.j2
    └── grafana.ini.j2
```


<br/>

# 3. Variables globales `vars/global.yml`

```yaml
prometheus_version: "2.52.0"
grafana_admin_user: admin
grafana_admin_password: admin
```

<br/>

# 4. Playbook `prometheus.yml`

```yaml
---
- name: Déployer Prometheus
  hosts: monitoring
  become: yes
  vars_files:
    - vars/global.yml
  tasks:
    - name: Créer le groupe prometheus
      group:
        name: prometheus
        system: yes

    - name: Créer l’utilisateur prometheus
      user:
        name: prometheus
        shell: /usr/sbin/nologin
        group: prometheus
        system: yes

    - name: Installer les prérequis
      apt:
        name:
          - curl
          - tar
          - gzip
        state: present
        update_cache: yes

    - name: Télécharger l’archive Prometheus
      get_url:
        url: "https://github.com/prometheus/prometheus/releases/download/v{{ prometheus_version }}/prometheus-{{ prometheus_version }}.linux-amd64.tar.gz"
        dest: /tmp/prometheus.tar.gz
        mode: "0644"

    - name: Extraire Prometheus
      unarchive:
        src: /tmp/prometheus.tar.gz
        dest: /opt/
        remote_src: yes

    - name: Donner les droits à prometheus
      file:
        path: "/opt/prometheus-{{ prometheus_version }}.linux-amd64"
        state: directory
        recurse: yes
        owner: prometheus
        group: prometheus

    - name: Copier la configuration
      template:
        src: templates/prometheus.yml.j2
        dest: /etc/prometheus.yml
        owner: prometheus
        group: prometheus
        mode: "0644"
      notify: Restart Prometheus

    - name: Créer le service systemd
      copy:
        dest: /etc/systemd/system/prometheus.service
        mode: "0644"
        content: |
          [Unit]
          Description=Prometheus
          After=network.target

          [Service]
          User=prometheus
          ExecStart=/opt/prometheus-{{ prometheus_version }}.linux-amd64/prometheus \
            --config.file=/etc/prometheus.yml \
            --storage.tsdb.path=/opt/prometheus-{{ prometheus_version }}.linux-amd64/data

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

<br/>

# 5. Playbook `grafana.yml`

```yaml
---
- name: Déployer Grafana
  hosts: monitoring
  become: yes
  vars_files:
    - vars/global.yml
  tasks:
    - name: Installer les dépendances
      apt:
        name:
          - apt-transport-https
          - software-properties-common
          - gnupg
          - ca-certificates
        state: present
        update_cache: yes

    - name: Ajouter la clé GPG
      apt_key:
        url: https://packages.grafana.com/gpg.key
        state: present

    - name: Ajouter le dépôt
      apt_repository:
        repo: "deb https://packages.grafana.com/oss/deb stable main"
        state: present

    - name: Mettre à jour APT
      apt:
        update_cache: yes

    - name: Installer Grafana
      apt:
        name: grafana
        state: present

    - name: Copier la configuration
      template:
        src: templates/grafana.ini.j2
        dest: /etc/grafana/grafana.ini
        mode: "0644"
      notify: Restart Grafana

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

<br/>

# 6. Templates

### 6.1 `templates/prometheus.yml.j2`

```yaml
global:
  scrape_interval: 15s

scrape_configs:
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

<br/>

# 7. Exécution

```bash
ansible-playbook -i inventory.ini prometheus.yml
ansible-playbook -i inventory.ini grafana.yml
```


<br/>

# 8. Vérification

```bash
ansible monitoring -m shell -a "ss -tulnp | grep -E '9090|3000'" -i inventory.ini
```

* Prometheus : [http://172.20.0.2:9090](http://172.20.0.2:9090)
* Grafana   : [http://172.20.0.2:3000](http://172.20.0.2:3000) (login admin / admin)


<br/>


## 9. Pistes d’amélioration

1. Ajouter un rôle `node_exporter` pour superviser chaque nœud Docker.
2. Sécuriser Grafana via Ansible Vault pour le mot de passe.
3. Paramétrer un tableau de bord JSON via le module `grafana_dashboard`.
4. Utiliser des tags (`--tags prometheus`, `--tags grafana`) pour cibler un playbook spécifique.







# Conclusion et éléments encore perfectibles pour un « niveau production »

| Domaine                         | Ajout recommandé                                                                                                                     | Raison                                                 |
| ------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------ | ------------------------------------------------------ |
| **Pare-feu**                    | Ouvrir les ports 9090 et 3000 (UFW ou Firewalld)                                                                                     | Accès réseau sécurisé et contrôlé                      |
| **Test HTTP/JSON**              | Utiliser le module `uri` pour valider que chaque service répond (status 200)                                                         | Vérification active plutôt que passive                 |
| **Handlers propres**            | Ajouter un handler `Reload Prometheus` pour recharger la configuration sans redémarrer complètement                                  | Bonne pratique d’exploitation                          |
| **Convergence**                 | Inclure `changed_when: false` sur la tâche `ss -tulnp` (étape de vérification) si vous l’intégrez dans un playbook                   | Préserve l’idempotence (pas de faux *changed*)         |
| **Sécurité Grafana**            | Chiffrer `grafana_admin_password` avec **Ansible Vault** et activer la création d’un utilisateur non-administrateur pour l’affichage | Respect des bonnes pratiques de sécurité               |
| **Exporter système**            | Rôle `node_exporter` + bloc `scrape_configs` dédié dans `prometheus.yml.j2`                                                          | Supervision des métriques système de chaque nœud       |
| **Automatisation du dashboard** | Module `grafana_dashboard` pour charger un JSON par défaut                                                                           | Expérience prête à l’emploi pour les étudiants         |
| **Nettoyage**                   | Supprimer /tmp/prometheus.tar.gz après extraction (module `file` state=absent)                                                       | Réduit l’espace disque et montre la phase de nettoyage |

### Correctifs 

1. **Variable de chemin Prometheus**
   Si vous changez de version, le chemin contient la version complète ; envisagez une variable dérivée :

   ```yaml
   prometheus_dir: "/opt/prometheus-{{ prometheus_version }}.linux-amd64"
   ```

   Utilisez-la partout pour éviter les oublis.

2. **Dépendances AlmaLinux**
   Pour des nœuds Red Hat/AlmaLinux, ajoutez un bloc `yum` conditionnel dans la tâche « Installer les prérequis ».

3. **Synchronisation du service Grafana**
   Après l’installation, Grafana peut prendre quelques secondes à écouter.

   ```yaml
   - name: Attendre l’ouverture du port 3000
     wait_for:
       port: 3000
       delay: 2
       timeout: 30
   ```

### Conclusion

* **Fonctionnel** pour un environnement pédagogique standard Ubuntu/Debian.
* **Production-ready** après les ajouts ci-dessus (pare-feu, tests actifs, sécurisation, exporters).


