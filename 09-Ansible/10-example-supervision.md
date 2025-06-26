```
                               ┌──────────────────────┐
                               │      Grafana         │
                               │  (interface web)     │
                               └─────────┬────────────┘
                                         │ lit les métriques
                                         │ via API HTTP
                                         ▼
                               ┌──────────────────────┐
                               │     Prometheus       │
                               │  node1 :9090         │
                               └─────────┬────────────┘
                                         │ scrape_interval = 15 s
                                         │
   ┌──────────────────────────────────────┼───────────────────────────────────────┐
   │                                      │                                       │
   ▼                                      ▼                                       ▼
┌──────────────┐                  ┌──────────────┐                         ┌──────────────┐
│ node_exporter│                  │ node_exporter│                         │ node_exporter│
│ node2 :9100  │                  │ node3 :9100  │                         │ node4 :9100  │
│   CPU, RAM   │                  │   CPU, RAM   │                         │   CPU, RAM   │
│   Disk, Net  │                  │   Disk, Net  │                         │   Disk, Net  │
└──────────────┘                  └──────────────┘                         └──────────────┘
   │                                      │                                       │
   │                                      │                                       │
   ▼                                      ▼                                       ▼
┌──────────────┐                  ┌──────────────┐                         ┌──────────────┐
│ node_exporter│                  │ node_exporter│                         │ node_exporter│
│ node5 :9100  │                  │ node6 :9100  │                         │ … autres …   │
│   CPU, RAM   │                  │   CPU, RAM   │                         │              │
│   Disk, Net  │                  │   Disk, Net  │                         │              │
└──────────────┘                  └──────────────┘                         └──────────────┘
          ▲                                                                          ▲
          └────────────────────── autres nœuds futurs ───────────────────────────────┘
```

### Ce que chaque composant surveille

| Composant          | Cible surveillée                                      | Type de métriques collectées                                   |
| ------------------ | ----------------------------------------------------- | -------------------------------------------------------------- |
| **node\_exporter** | Serveur physique ou conteneur (node2 → node6)         | CPU, mémoire, disque, réseau, charge système, filesystems      |
| **Prometheus**     | Lui-même (`localhost:9090`) **et** tous les exporters | Séries temporelles brutes (scrape toutes les 15 secondes)      |
| **Grafana**        | Prometheus (source unique de données)                 | Interroge, agrège et affiche : graphiques, alertes, dashboards |

Ainsi :

* **Prometheus** est le collecteur central.
* **Grafana** est l’outil de visualisation.
* **node\_exporter** transforme chaque nœud en cible de supervision système.

Tu peux ajouter d’autres exporters (MySQL, PostgreSQL, Docker, nginx, etc.) : il suffit d’installer l’exporter sur un nœud, puis d’ajouter sa cible dans `templates/prometheus.yml.j2` pour qu’il apparaisse dans Grafana.
