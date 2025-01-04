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

