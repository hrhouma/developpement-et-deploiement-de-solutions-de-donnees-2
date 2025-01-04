# **Grille d’Évaluation du Projet de Fin de Session – Déploiement CI/CD**

| **Critères**                         | **Description**                                                                                                   | **Points** | **Commentaires** |
|--------------------------------------|-------------------------------------------------------------------------------------------------------------------|------------|-----------------|
| **1. Choix de l’application (5%)**   | - L'application est clairement identifiée (titre, description, origine GitHub ou autre cours)                     | 5 points   |                 |
| **2. Clarté des objectifs (5%)**     | - Les objectifs du projet sont bien définis (pipeline CI/CD, plateforme choisie, fonctionnalités attendues)        | 5 points   |                 |
| **3. Choix de la plateforme CI/CD (10%)** | - Indication claire de la plateforme choisie (CodePipeline, GitHub Actions, Azure DevOps, etc.)                    | 10 points  |                 |
| **4. Configuration de l’infrastructure (20%)** | - Création et configuration des ressources nécessaires (serveurs, conteneurs, bases de données)                     | 20 points  | Évaluer la cohérence de la configuration |
| **5. Automatisation du pipeline (30%)** | - Pipeline CI/CD fonctionnel et automatisé (build, tests, déploiement en staging/production)                        | 30 points  |                 |
| **6. Gestion des erreurs (10%)**     | - Gestion des erreurs dans le pipeline (ex. étapes conditionnelles, alertes, logs bien configurés)                 | 10 points  |                 |
| **7. Documentation détaillée (20%)** | - Documentation claire et précise qui permet de reproduire toutes les étapes du projet sans ambiguïté               | 20 points  | _- 50% si la documentation est incomplète ou non reproductible_ |
| **8. Qualité de la présentation (5%)** | - Présentation orale ou écrite bien structurée (explications des choix techniques, conclusions claires)             | 5 points   |                 |

---

# **Détail des critères :**

## **1. Choix de l’application (5 points)**
- L’application choisie est explicitement nommée et décrite (ex. lien GitHub, ça peut être une application utilisée dans un projet d'un autre cours et que vous voulez déployez dans ce cours).
- Peu importe le langage ou le framework (Python, Java, Flask, MERN, .NET, etc.).

## **2. Clarté des objectifs (5 points)**
- Définir les objectifs du projet : déploiement en production ou en staging, étapes de build/test, plateformes choisies.

## **3. Choix de la plateforme CI/CD (10 points)**
- Indiquer quelle plateforme est utilisée (CodePipeline, GitHub Actions, Azure DevOps, etc.) et pourquoi ce choix.
- Bonus : expliquer les avantages et limites de la plateforme.

## **4. Configuration de l’infrastructure (20 points)**
- Ressources nécessaires configurées correctement (VM, bases de données, conteneurs Docker, etc.).
- Infrastructure déclarative (si applicable, ex. Terraform/CloudFormation).

## **5. Automatisation du pipeline CI/CD (30 points)**
- Pipeline fonctionnel : build → tests → déploiement.
- Présence de plusieurs environnements (dev, staging, prod).
- Tests automatisés intégrés dans le pipeline.

## **6. Gestion des erreurs (10 points)**
- Logs clairs et détaillés.
- Comment avez-vous résolu les erreurs rencontrées.
- Gestion des cas d’échec avec étapes conditionnelles (rollback si déploiement échoue).
- Alertes configurées en cas de panne (optionnel)

## **7. Documentation détaillée (20 points)**
- Documentation complète, expliquant :
  - **Étapes d'installation** de l’environnement.
  - **Configuration des scripts**.
  - Instructions claires pour reproduire le projet.
- **Pénalité : -30% si la documentation n'est pas reproductible ou si des étapes sont manquantes.**

## **8. Qualité de la présentation (5 points)**
- Explication claire des choix techniques.
- Présentation fluide et capacité à répondre aux questions.

---

## **Notation :**
- **Total des points : 100 points**


-----------------
# Exemples de projets:
-----------------


### **1. Déploiement d'une application Flask pour l'analyse de données sur AWS Lambda avec GitHub Actions**  
**Description :**  
Déployer une API **Flask** qui reçoit des données CSV pour effectuer des analyses statistiques et renvoyer des visualisations (courbes, histogrammes) sur **AWS Lambda** via **API Gateway**. Le pipeline CI/CD sera automatisé avec **GitHub Actions** pour le build, le test et le déploiement.  
**Points clés :**  
- Utilisation de **Pandas** et **Matplotlib** pour le traitement des données.  
- Configuration des scripts de déploiement **Serverless Framework**.  
- Sauvegarde des résultats sur **S3** et gestion des logs via **CloudWatch**.  

**Stack :** Flask, Pandas, Matplotlib, AWS Lambda, GitHub Actions.  

---

### **2. Pipeline CI/CD pour une application Django Data Visualisation sur Azure**  
**Description :**  
Créer un pipeline CI/CD sur **Azure DevOps** pour une application **Django** permettant de visualiser les données d’une base **PostgreSQL** en temps réel. Déployer l’application sur **Azure App Service** et utiliser des **dashboards interactifs** avec **Plotly/Dash** intégrés.  
**Points clés :**  
- Connexion aux bases de données **PostgreSQL** via **Azure Database for PostgreSQL**.  
- Automatisation de la migration des données et des tâches planifiées via **Celery** et **Redis**.  
- Monitoring des performances avec **Azure Monitor** et visualisation des métriques dans **Log Analytics**.  

**Stack :** Django, PostgreSQL, Plotly/Dash, Azure App Service, Azure DevOps.  

---

### **3. Déploiement d'une application Python pour l'entraînement de modèles ML sur Google Cloud Run**  
**Description :**  
Créer un pipeline CI/CD avec **GitHub Actions** pour une application **Flask** permettant d’entraîner un modèle de régression linéaire sur des datasets téléchargés par les utilisateurs. Déployer cette application sur **Google Cloud Run**.  
**Points clés :**  
- Utilisation de **scikit-learn** pour l’entraînement des modèles.  
- Stockage des modèles entraînés dans **Google Cloud Storage**.  
- Suivi des performances du modèle avec des graphiques interactifs générés par **Seaborn**.  

**Stack :** Flask, scikit-learn, Seaborn, Google Cloud Run, GitHub Actions.  

---

### **4. Déploiement d'une application Data Science sur AWS SageMaker**  
**Description :**  
Créer une application **Streamlit** qui permet aux utilisateurs de charger des jeux de données et d’exécuter des modèles ML pré-entraînés sur **AWS SageMaker** pour des prédictions en temps réel. Le CI/CD sera automatisé via **CodePipeline** pour le déploiement des notebooks et des endpoints.  
**Points clés :**  
- Intégration des notebooks Jupyter avec **SageMaker** pour l’entraînement et l'inférence.  
- Affichage des prédictions via une interface interactive **Streamlit**.  
- Surveillance des performances des endpoints via **CloudWatch Metrics**.  

**Stack :** Streamlit, AWS SageMaker, Pandas, CodePipeline.  

---

### **5. Déploiement d'une application Node.js pour le traitement de gros volumes de données sur Azure**  
**Description :**  
Déployer une application **Node.js** qui utilise **Apache Spark** pour traiter des fichiers volumineux sur **Azure Databricks**. Le pipeline CI/CD sur **Azure DevOps** doit automatiser le déploiement des scripts Spark et l’exécution des tâches planifiées sur **Azure Data Lake**.  
**Points clés :**  
- Intégration avec **Azure Blob Storage** pour le stockage des fichiers d'entrée et de sortie.  
- Visualisation des résultats du traitement avec **Grafana** connectée aux logs Databricks.  
- Utilisation de **Cosmos DB** ou **SQL Database** pour stocker les résultats finaux.  

**Stack :** Node.js, Apache Spark, Azure Databricks, Grafana, Azure DevOps.  

---


### **6. Déploiement d'une application MERN de gestion de tâches sur AWS ECS avec CodePipeline**  
**Description :**  
Déployer une application **MERN** pour la gestion de projets et de tâches sur **AWS Elastic Container Service (ECS)**. Utiliser **CodePipeline** pour automatiser le pipeline CI/CD, avec **ECR** pour les images Docker et **ALB** (Application Load Balancer) pour la distribution du trafic.  
**Points clés :**  
- Utilisation de **Docker** pour conteneuriser le backend Node.js et le frontend React.  
- Configuration de **CloudWatch** pour surveiller les erreurs et le trafic.  
- Implémentation d’une stratégie de **rollback** en cas d’échec du déploiement.  

**Stack :** MongoDB Atlas, Express.js, React, Node.js, AWS ECS, CodePipeline.  

---

### **7. Pipeline CI/CD avec Azure DevOps pour une application MERN de blog**  
**Description :**  
Créer une application **MERN** pour la gestion d'un blog (création d’articles, commentaires, profils utilisateurs) et la déployer sur **Azure App Service** via **Azure DevOps**.  
**Points clés :**  
- Création d’un pipeline YAML dans **Azure DevOps** pour les étapes de build, tests, et déploiement.  
- Stockage des images et des fichiers sur **Azure Blob Storage**.  
- Configuration des **variables de secrets** pour gérer les connexions à MongoDB et les clés API.  

**Stack :** MongoDB, Express.js, React, Node.js, Azure App Service, Azure DevOps.  

---

### **8. Déploiement d'une application MERN e-commerce sur Google Cloud Run avec GitHub Actions**  
**Description :**  
Créer une boutique en ligne MERN (catalogue de produits, panier d'achat, paiement) et la déployer sur **Google Cloud Run** avec un pipeline CI/CD automatisé via **GitHub Actions**.  
**Points clés :**  
- Utilisation de **Cloud Firestore** ou **MongoDB Atlas** pour la persistance des données.  
- Gestion des fichiers d’images produits sur **Google Cloud Storage**.  
- Implémentation d'une stratégie de **blue/green deployment** pour éviter les temps d'arrêt.  

**Stack :** MongoDB Atlas, Express.js, React, Node.js, Google Cloud Run, GitHub Actions.  

---

### **9. Application MERN de gestion d'événements avec monitoring sur Kubernetes**  
**Description :**  
Déployer une application MERN de gestion d'événements (calendrier, inscriptions, notifications) sur un cluster **Kubernetes** hébergé sur **AWS EKS**. Utiliser **Jenkins** pour créer un pipeline CI/CD complet.  
**Points clés :**  
- Utilisation des **Helm Charts** pour gérer la configuration Kubernetes.  
- Implémentation de **Prometheus/Grafana** pour visualiser les métriques du cluster et des conteneurs.  
- Configuration du **Auto-Scaling** pour adapter le nombre de pods en fonction de la charge.  

**Stack :** MongoDB, Express.js, React, Node.js, Kubernetes (EKS), Jenkins.  

---

### **10. Déploiement d'une application MERN de gestion de portfolio sur Netlify et Heroku avec CircleCI**  
**Description :**  
Déployer une application **MERN** pour gérer un portfolio de projets personnels avec un frontend React sur **Netlify** et un backend Node.js sur **Heroku**. Utiliser **CircleCI** pour le pipeline CI/CD.  
**Points clés :**  
- Tests automatisés sur chaque push via **CircleCI**.  
- Gestion des secrets avec **CircleCI Environment Variables**.  
- Monitoring des performances avec des outils comme **Sentry** pour détecter les erreurs sur le frontend et backend.  

**Stack :** MongoDB Atlas, Express.js, React, Node.js, Netlify, Heroku, CircleCI.  



