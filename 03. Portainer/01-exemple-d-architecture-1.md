
------------------------
# Annexe 01 - Comprendre la hiéarchie
------------------------

![image](https://github.com/user-attachments/assets/b21a32dd-bc5c-479f-9e8f-50277a17f2ac)

*Docker est clairement à l'intérieur de la **Machine Virtuelle Debian 12**.* 
- Voici une représentation mise à jour de la pile, montrant Docker dans la machine virtuelle, avec un focus sur sa place à l'intérieur de Debian :

### Pile avec Docker dans la machine virtuelle Debian 12

```
+-----------------------------------------------------------+
|                       Machine Hôte                        |
|                    Windows 10 (Host)                      |
|                                                           |
|   +-----------------------------------------------+       |
|   |              Hyperviseur (VirtualBox)          |       |
|   |                                               |       |
|   |   +---------------------------------------+   |       |
|   |   |         Machine Virtuelle             |   |       |
|   |   |           Debian 12 (Guest)           |   |       |
|   |   |                                       |   |       |
|   |   |   +-----------------------------+     |   |       |
|   |   |   |        Docker (dans Debian)  |     |   |       |
|   |   |   |  - docker0 : 172.17.0.1      |     |   |       |
|   |   |   |    (Bridge Docker)           |     |   |       |
|   |   |   +-----------------------------+     |   |       |
|   |   |                                       |   |       |
|   |   |   +-----------------------------+     |   |       |
|   |   |   |      Interfaces Réseau       |     |   |       |
|   |   |   |                             |     |   |       |
|   |   |   |  - lo : Loopback (127.0.0.1)|     |   |       |
|   |   |   |  - enp0s3 : 10.80.243.30    |     |   |       |
|   |   |   |  - enp0s8 : Ethernet        |     |   |       |
|   |   |   |  - docker0 : 172.17.0.1     |     |   |       |
|   |   |   +-----------------------------+     |   |       |
|   |   +---------------------------------------+   |       |
|   +-----------------------------------------------+       |
+-----------------------------------------------------------+
```

### Explication :

- **Machine Hôte (Windows 10)** : L'hôte Windows 10 exécute VirtualBox.
- **VirtualBox** : Le logiciel de virtualisation hébergeant la machine virtuelle Debian 12.
- **Machine Virtuelle (Debian 12)** : La machine Debian 12 est exécutée comme VM dans VirtualBox.
- **Docker (dans Debian)** : Docker fonctionne **à l'intérieur** de la machine virtuelle Debian 12.
  - `docker0` : Réseau bridge de Docker dans la VM, avec l'IP `172.17.0.1`.
- **Interfaces Réseau de Debian 12** :
  - `lo` : Interface loopback (127.0.0.1).
  - `enp0s3` : Interface NAT, avec l'adresse IP `10.80.243.30`.
  - `enp0s8` : Interface Ethernet (potentiellement non utilisée dans cette configuration).
  - `docker0` : Interface réseau interne à Docker dans Debian.

Cette représentation montre clairement que **Docker est exécuté à l'intérieur de la machine virtuelle Debian**, avec ses interfaces réseau, tandis que la machine hôte est Windows 10.


-----------------
# Annexe 2-  illustrer la manière dont `docker0` fonctionne avec plusieurs conteneurs dans le mode **bridge** :
-----------------

- *Ce schéma montre comment les conteneurs utilisent `docker0` comme **passerelle commune** pour communiquer entre eux et avec le réseau externe.*


```
+-------------------------------------------------------------+
|                      Machine Virtuelle                      |
|                         Debian 12                           |
|                                                             |
|  +--------------------------+     +----------------------+  |
|  |        docker0 (bridge)   |     |     Interfaces réseau |  |
|  |  IP : 172.17.0.1          |     |   (enp0s3, enp0s8, etc.)|
|  +--------------------------+     +----------------------+  |
|           |   (passerelle)                                        |
|           |                                                       |
|   +-------+---------------------------------------------------+   |
|   |               Réseau Virtuel (172.17.0.0/16)              |   |
|   |                                                           |   |
|   |   +-----------------+    +-----------------+    +-----------------+   |
|   |   |  Conteneur 1     |    |  Conteneur 2     |    |  Conteneur 3     |   |
|   |   |  IP : 172.17.0.2 |    |  IP : 172.17.0.3 |    |  IP : 172.17.0.4 |   |
|   |   +-----------------+    +-----------------+    +-----------------+   |
|   |                                                           |   |
|   +-----------------------------------------------------------+   |
|                                                             |
|  +---------------------------------------------------------+   |
|  |                 Communication Externe                   |   |
|  | (Les conteneurs peuvent accéder au réseau extérieur via  |   |
|  | l'interface docker0 qui agit comme passerelle)           |   |
|  +---------------------------------------------------------+   |
+-------------------------------------------------------------+
```

### Explication du schéma :

1. **docker0 (Bridge)** : `docker0` est une interface réseau virtuelle créée par Docker dans Debian 12. Elle agit comme un **pont** entre tous les conteneurs qui utilisent le mode **bridge**. Son IP est `172.17.0.1`, qui sert de **passerelle par défaut** pour les conteneurs.
   
2. **Réseau Virtuel Docker** : Docker crée un réseau virtuel interne (ici, `172.17.0.0/16`) pour relier les conteneurs entre eux. Chaque conteneur obtient une adresse IP dans ce sous-réseau.
   - **Conteneur 1** : IP `172.17.0.2`
   - **Conteneur 2** : IP `172.17.0.3`
   - **Conteneur 3** : IP `172.17.0.4`
   
3. **Communication entre les Conteneurs** : Les conteneurs peuvent **communiquer entre eux** sur ce réseau interne, en utilisant les adresses IP attribuées dans le sous-réseau `172.17.x.x`. Par exemple, le **Conteneur 1** peut envoyer des requêtes au **Conteneur 2** en utilisant l'adresse IP `172.17.0.3`.

4. **Passerelle pour l'accès externe** : Si un conteneur a besoin d'accéder à l'extérieur (Internet ou réseau de l'hôte), il passera par `docker0`, qui agit comme passerelle pour ces connexions.

5. **Interfaces Réseau Externe** : `docker0` peut router les connexions sortantes vers les interfaces réseau de la machine Debian (comme `enp0s3` ou `enp0s8`), ce qui permet aux conteneurs de communiquer avec le monde extérieur.

