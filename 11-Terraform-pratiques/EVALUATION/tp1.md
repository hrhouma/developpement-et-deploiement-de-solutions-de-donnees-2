# EXAMEN – TRAVAIL PRATIQUE : TERRAFORM & INFRASTRUCTURE AWS

**Titre** : Analyse et optimisation d’un déploiement Cloud avec Terraform
**Consignes** : Travail en équipe – supports autorisés (code du projet, documentation officielle Terraform)

# Références: 

- https://github.com/hrhouma/developpement-et-deploiement-de-solutions-de-donnees-2/blob/main/11-Terraform-pratiques/12-travail-pratique-02.md
- https://github.com/hrhouma/terraform-1.git

## PARTIE 1 — DESSIN TECHNIQUE ET EXPLICATION DU DÉROULEMENT (10 points)

> **Objectif** : Vérifier votre compréhension du fonctionnement global du projet et des appels entre les composants.

### Consigne :

1. Dessinez le **workflow général** de l’infrastructure Terraform fournie (`TERRAFORM-1`).
2. Indiquez **qui appelle quoi**, **dans quel ordre**, et quelles **ressources AWS** sont concernées.
3. Le schéma doit inclure les **fichiers du projet** visibles dans l’arborescence (`main.tf`, `autoscaling.tf`, `snapshot.tf`, `s3.tf`, etc.) et **les interactions entre eux**.

Vous pouvez représenter les appels directs, les dépendances implicites (variables, ressources) et les relations entre ressources AWS (EC2, RDS, S3, Lambda, SNS, etc.).


## PARTIE 2 — QUESTIONS DE SYNTHÈSE (30 points)

> Vous devez répondre de manière claire, concise, avec des exemples précis si nécessaire.



### 2.1 – Ordonnancement et dépendances (5 points)

Expliquez comment Terraform gère l’**ordre d’exécution** des fichiers dans ce projet.

* Y a-t-il un fichier principal ?
* Comment les appels entre les fichiers sont-ils gérés ?
* À quoi faut-il faire attention pour que les ressources soient créées dans le bon ordre ?



### 2.2 – Appels inter-fichiers (5 points)

Prenez **deux fichiers de votre choix** parmi :
`main.tf`, `autoscaling.tf`, `snapshot.tf`, `rds.tf`, `s3.tf`

Expliquez **comment ils interagissent** entre eux ou avec d'autres parties du projet.

* Existe-t-il des références croisées ?
* Ces fichiers dépendent-ils des mêmes ressources ou variables ?
* Comment Terraform sait-il quoi faire en premier ?


### 2.3 – Amélioration du projet (5 points)

Selon vous, que pourrait-on **améliorer** dans la structure actuelle du projet Terraform-1 ?

* Fichiers de variables ?
* Modularité ?
* Réduction de duplication ?
* Sécurité des identifiants ?

Citez **au moins 3 améliorations concrètes**, avec une courte justification.


### 2.4 – Fonction Lambda et automatisation (5 points)

Expliquez le rôle de la fonction `lambda_function.py` dans ce projet :

* À quoi sert-elle ?
* Comment est-elle configurée pour être appelée automatiquement ?
* Quelle ressource AWS déclenche son exécution ?
* Que faudrait-il vérifier pour que tout fonctionne ?



### 2.5 – Infrastructure cloud : points forts et limites (5 points)

À partir du projet `TERRAFORM-1`, identifiez :

* Deux **forces** de cette infrastructure (résilience, sécurité, scalabilité, etc.)
* Deux **limites** ou éléments à risque que vous avez repérés

Justifiez vos réponses.



### 2.6 – Étapes pratiques du déploiement (5 points)

Expliquez **dans vos propres mots** comment un nouvel utilisateur peut **lancer cette infrastructure** depuis le début. Mentionnez :

* Le travail préparatoire
* Les commandes Terraform nécessaires
* Les vérifications post-déploiement



## BARÈME GLOBAL

| Section                       | Points |
| ----------------------------- | ------ |
| Partie 1 – Schéma explicatif  | 10     |
| 2.1 – Ordonnancement          | 5      |
| 2.2 – Appels inter-fichiers   | 5      |
| 2.3 – Améliorations proposées | 5      |
| 2.4 – Fonction Lambda         | 5      |
| 2.5 – Forces et limites       | 5      |
| 2.6 – Déploiement pratique    | 5      |
| **Total**                     | **40** |

