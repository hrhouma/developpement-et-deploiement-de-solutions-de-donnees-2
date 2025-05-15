# **Projet DevOps – Plateforme Multi-Wiki avec Docker Compose et CI/CD GitHub Actions**

## **1. Contexte général**

Votre équipe travaille pour **DocInfra**, une entreprise spécialisée dans l’hébergement de documentation et support technique pour des partenaires externes. Ces partenaires (des établissements scolaires, des entreprises, des associations, etc.) souhaitent disposer de leur propre espace Wiki en ligne, sécurisé, maintenu, et facilement modifiable.

Pour cela, DocInfra utilise l’outil **Wiki.js**, une solution open-source moderne, basée sur Node.js et PostgreSQL, déployée via **Docker**.

Votre mission : **déployer une infrastructure évolutive, automatisée et propre**, permettant de maintenir **plusieurs sites webs Wiki.js indépendants**, chacun isolé dans un conteneur, avec sa propre base de données.

---

## **2. Objectifs pédagogiques**

* Mettre en œuvre une **architecture Docker multi-instances**
* Configurer un **reverse proxy Nginx** avec plusieurs sous-domaines
* Déployer les services automatiquement avec **GitHub Actions**
* Maintenir chaque Wiki.js de manière **isolée, modulaire et extensible**
* Appliquer les **bonnes pratiques DevOps** : automatisation, séparation des configurations, gestion des secrets

---

## **3. Description fonctionnelle du projet**

### 📌 Vous devez :

1. Déployer **au moins 3 instances indépendantes** de Wiki.js :

   * `wiki1.monplateforme.local` → institution 1
   * `wiki2.monplateforme.local` → institution 2
   * `wiki-public.monplateforme.local` → version publique

2. Pour chaque instance :

   * Lancer un conteneur PostgreSQL dédié
   * Lancer un conteneur Wiki.js connecté à sa base
   * Configurer un volume Docker pour stocker les données persistantes

3. Mettre en place **un reverse proxy Nginx** qui redirige les sous-domaines vers les bons ports internes.

4. Mettre en place un **workflow GitHub Actions** :

   * Déclenché à chaque `git push` sur `main`
   * Qui transfère les fichiers sur un serveur distant via SSH
   * Et redémarre les bons services via Docker Compose

---

## **4. Architecture technique**

### 🧱 Composants à installer sur le serveur (VPS)

| Composant        | Rôle                                                |
| ---------------- | --------------------------------------------------- |
| Docker + Compose | Conteneuriser Wiki.js et PostgreSQL                 |
| Nginx            | Reverse proxy + gestion des sous-domaines           |
| Certbot (option) | Certificats HTTPS (non exigé dans ce projet)        |
| GitHub Actions   | Déclencheur CI/CD pour synchroniser les changements |

---

### 📦 Exemple de structure de projet

```
wikijs-multisite/
├── instances/
│   ├── wiki1/
│   │   └── docker-compose.yml
│   ├── wiki2/
│   │   └── docker-compose.yml
│   └── wiki-public/
│       └── docker-compose.yml
├── nginx/
│   └── wikijs.conf
├── .github/
│   └── workflows/
│       └── deploy.yml
└── README.md
```

---

## **5. Contraintes techniques**

* Chaque Wiki.js doit tourner sur un **port différent** (ex : 3001, 3002, 3003)
* Chaque base de données doit avoir :

  * Un nom distinct
  * Un utilisateur et mot de passe propres
* Le reverse proxy doit router en fonction du sous-domaine
* Aucun Wiki ne doit pouvoir accéder à un autre
* Le système doit être **déployable automatiquement** via GitHub

---

## **6. Exemple de docker-compose.yml (instance wiki1)**

```yaml
version: "3"

services:
  db:
    image: postgres:13
    restart: always
    environment:
      POSTGRES_DB: wikijs1
      POSTGRES_USER: wikijs
      POSTGRES_PASSWORD: wikijs123
    volumes:
      - db-wiki1:/var/lib/postgresql/data

  wikijs:
    image: requarks/wiki:2
    restart: always
    ports:
      - "3001:3000"
    environment:
      DB_TYPE: postgres
      DB_HOST: db
      DB_PORT: 5432
      DB_USER: wikijs
      DB_PASS: wikijs123
      DB_NAME: wikijs1
    depends_on:
      - db
    volumes:
      - wiki1-data:/wiki/data

volumes:
  db-wiki1:
  wiki1-data:
```

---

## **7. Exemple de configuration Nginx**

```nginx
server {
  listen 80;
  server_name wiki1.monplateforme.local;
  location / {
    proxy_pass http://127.0.0.1:3001;
    include proxy_params;
  }
}

server {
  listen 80;
  server_name wiki2.monplateforme.local;
  location / {
    proxy_pass http://127.0.0.1:3002;
    include proxy_params;
  }
}
```

---

## **8. Déploiement automatique avec GitHub Actions**

Un fichier `.github/workflows/deploy.yml` doit :

* S’exécuter sur `push` vers `main`
* Copier les fichiers vers `/opt/wikijs-deploy/` sur le VPS
* Relancer les bons `docker-compose` dans chaque dossier
* Recharger Nginx si nécessaire

---

## **9. Étapes à réaliser**

| Étape | Travail attendu                                           |
| ----- | --------------------------------------------------------- |
| 1     | Créer le projet Git avec une arborescence claire          |
| 2     | Développer le `docker-compose.yml` pour chaque instance   |
| 3     | Écrire le fichier Nginx de reverse proxy                  |
| 4     | Tester localement chaque instance avec un port distinct   |
| 5     | Rédiger le workflow GitHub Actions complet (`deploy.yml`) |
| 6     | Tester le déploiement automatique sur un VPS (via SSH)    |
| 7     | Documenter le tout dans un `README.md`                    |

---

## **10. Évaluation (sur 40 points)**

| Critère                                   | Points |
| ----------------------------------------- | ------ |
| Fonctionnement des 3 instances Wiki.js    | 10     |
| Isolation correcte des bases PostgreSQL   | 5      |
| Reverse proxy Nginx fonctionnel           | 5      |
| Automatisation complète avec GitHub CI/CD | 10     |
| Structure propre, lisible et maintenable  | 5      |
| Documentation du projet                   | 5      |


