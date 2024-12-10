### **Exercice 03 - Analyse d’un pipeline YAML Azure DevOps pour une application ETL avec Pandas**

#### **Objectif :**
Comprendre et expliquer le rôle de chaque section et tâche dans un pipeline YAML pour un processus ETL (Extraction, Transformation, Loading) utilisant Pandas dans un projet Python.

---

### **Fichier YAML :**
```yaml
trigger:
- main

pool:
  vmImage: 'ubuntu-22.04'

steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.10'
    addToPath: true

- script: |
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
  displayName: 'Set up Python environment and install dependencies'

- script: |
    python extract_data.py
  displayName: 'Extract Data'

- script: |
    python transform_data.py
  displayName: 'Transform Data'

- script: |
    python load_data.py
  displayName: 'Load Data into Target System'

- task: PublishBuildArtifacts@1
  displayName: 'Publish Processed Data'
  inputs:
    PathtoPublish: '$(System.DefaultWorkingDirectory)/processed_data'
    ArtifactName: 'etl-data-artifacts'
    publishLocation: 'Container'
```

---

#### **Contexte :**
Ce pipeline automatise un processus ETL (Extraction, Transformation, Chargement) avec les étapes suivantes :
1. **Extraction des données** depuis une source (ex : fichier CSV, API).  
2. **Transformation des données** (nettoyage, calculs) avec Pandas.  
3. **Chargement des données** dans une cible (ex : base de données ou stockage).  

---

### **Questions à répondre :**

#### **1. Section `trigger`**  
   - Quel est le rôle du `trigger` dans ce pipeline ?  
   - Pourquoi déclenche-t-on le pipeline sur la branche `main` ?  
   - Donnez un exemple où vous utiliseriez une autre branche pour le `trigger`.

#### **2. Section `pool`**  
   - Pourquoi utilise-t-on `vmImage: 'ubuntu-22.04'` ?  
   - Quels avantages cela apporte-t-il pour une application Pandas ?

#### **3. Tâche `UsePythonVersion@0`**  
   - Quel est l’objectif de cette tâche ?  
   - Pourquoi choisit-on ici Python 3.10 ?

#### **4. Script : Configuration de l’environnement Python**  
   - Expliquez les étapes pour configurer un environnement Python virtuel.  
   - Quelle est l’importance du fichier `requirements.txt` dans ce processus ?  
   - Pourquoi cette étape est-elle essentielle avant d’exécuter des scripts ETL ?

#### **5. Script : `python extract_data.py`**  
   - Quel est l’objectif de ce script ?  
   - Donnez un exemple de tâche d’extraction de données avec Pandas (par ex., lecture d’un fichier CSV ou appel à une API).  
   - Expliquez pourquoi l’étape d’extraction est la première dans un processus ETL.

#### **6. Script : `python transform_data.py`**  
   - Que fait cette étape dans le processus ETL ?  
   - Donnez un exemple de transformation des données avec Pandas (par ex., suppression de valeurs manquantes, ajout de colonnes calculées).  
   - Pourquoi la transformation est-elle essentielle dans un pipeline ETL ?

#### **7. Script : `python load_data.py`**  
   - Expliquez l’objectif de cette étape dans un pipeline ETL.  
   - Donnez un exemple de chargement des données dans une cible (par ex., stockage S3, base de données SQL).  
   - Quels problèmes pourraient survenir si cette étape échoue ?

#### **8. Tâche `PublishBuildArtifacts@1`**  
   - Quel est le rôle de cette tâche dans le pipeline ?  
   - Pourquoi les données transformées ou chargées doivent-elles être publiées en tant qu’artefacts ?  
   - Donnez des exemples de situations où les artefacts publiés seraient réutilisés (par ex., pour des rapports ou des analyses supplémentaires).

---

### **Livrable attendu :**
1. Une analyse claire et détaillée de chaque section et tâche du pipeline.  
2. Des explications illustrées par des exemples pratiques (ex : extraction d’un fichier CSV, transformation avec Pandas).  
3. Une réflexion sur l’importance de chaque étape dans un processus ETL.

---

### **Bonus : Questions de réflexion**
1. Quels sont les avantages de CI/CD pour un processus ETL comparé à un processus manuel ?  
2. Comment pourriez-vous automatiser les tests pour vérifier que chaque étape ETL fonctionne correctement (par ex., tests unitaires pour Pandas) ?  
3. Quels autres outils que Pandas pourraient être utilisés pour des pipelines ETL complexes, et pourquoi ?
