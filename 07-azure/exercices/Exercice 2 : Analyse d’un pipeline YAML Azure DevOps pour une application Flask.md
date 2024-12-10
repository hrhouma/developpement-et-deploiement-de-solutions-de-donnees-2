### **Exercice 2 : Analyse d’un pipeline YAML Azure DevOps pour une application Flask**

#### **Objectif :**
Comprendre et expliquer le rôle de chaque section et tâche dans un pipeline YAML pour une application Flask.

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
    flask run --host=0.0.0.0
  displayName: 'Run Flask Application'

- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(System.DefaultWorkingDirectory)'
    ArtifactName: 'flask-artifacts'
    publishLocation: 'Container'
```

---

#### **Questions à répondre :**

1. **Section `trigger`**  
   - Quelle est la branche surveillée par le pipeline ? Pourquoi est-elle nommée `main` ?

2. **Section `pool`**  
   - Expliquez pourquoi un environnement Ubuntu est utilisé.  
   - Quels autres types d’agents peuvent être utilisés ?

3. **Tâche `UsePythonVersion@0`**  
   - Quel est l’objectif de cette tâche ?  
   - Expliquez le paramètre `versionSpec: '3.10'`.

4. **Script : Configuration de l’environnement Python**  
   - Expliquez les commandes utilisées dans ce script.  
   - Quelle est l’importance de `venv` pour les environnements Python ?  
   - Pourquoi utilise-t-on le fichier `requirements.txt` ?

5. **Script : Exécution de l'application Flask**  
   - Que fait la commande `flask run --host=0.0.0.0` ?  
   - Pourquoi spécifie-t-on `--host=0.0.0.0` ?

6. **Tâche `PublishBuildArtifacts@1`**  
   - Quelle est l’utilité de publier des artefacts dans un pipeline Flask ?  
   - Expliquez les paramètres `PathtoPublish`, `ArtifactName`, et `publishLocation`.

---

---

### **Exercice 2 : Analyse d’un pipeline YAML Azure DevOps pour une application FastAPI**

#### **Objectif :**
Comprendre et expliquer le rôle de chaque section et tâche dans un pipeline YAML pour une application FastAPI.

---

### **Fichier YAML :**
```yaml
trigger:
- develop

pool:
  vmImage: 'ubuntu-22.04'

steps:
- task: UsePythonVersion@0
  inputs:
    versionSpec: '3.11'
    addToPath: true

- script: |
    python -m venv venv
    source venv/bin/activate
    pip install -r requirements.txt
    pip install uvicorn
  displayName: 'Set up Python environment and install dependencies'

- script: |
    uvicorn main:app --host 0.0.0.0 --port 8000
  displayName: 'Run FastAPI Application'

- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(System.DefaultWorkingDirectory)'
    ArtifactName: 'fastapi-artifacts'
    publishLocation: 'Container'
```

---

#### **Questions à répondre :**

1. **Section `trigger`**  
   - Quelle branche déclenche le pipeline ?  
   - Pourquoi surveille-t-on la branche `develop` ici ?

2. **Section `pool`**  
   - Expliquez l’utilité d’utiliser un environnement Ubuntu.  
   - Pourquoi choisir un environnement avec `vmImage: 'ubuntu-22.04'` pour FastAPI ?

3. **Tâche `UsePythonVersion@0`**  
   - Expliquez le rôle de cette tâche et le paramètre `versionSpec: '3.11'`.  
   - Pourquoi est-il important d’ajouter Python au PATH ?

4. **Script : Configuration de l’environnement Python**  
   - Pourquoi crée-t-on un environnement virtuel (`venv`) ?  
   - Expliquez l’installation de `uvicorn`.  
   - Quelle est l’importance de `requirements.txt` dans ce contexte ?

5. **Script : Exécution de l’application FastAPI**  
   - Que signifie la commande `uvicorn main:app --host 0.0.0.0 --port 8000` ?  
   - Pourquoi spécifie-t-on `--host` et `--port` dans ce cas ?

6. **Tâche `PublishBuildArtifacts@1`**  
   - Quel est l’objectif de publier les artefacts pour une application FastAPI ?  
   - Comment peut-on utiliser ces artefacts dans une prochaine étape du pipeline ?

---

### **Livrables attendus pour les deux exercices :**
1. Une explication détaillée des sections et des tâches.  
2. Une description claire et concise de l’objectif de chaque étape.  
3. Des exemples pratiques pour illustrer vos explications.  

---

### **Bonus : Questions de réflexion**
1. Quels sont les avantages d’utiliser Azure DevOps pour une application Python Flask ou FastAPI par rapport à un autre outil CI/CD comme Jenkins ?  
2. Pourquoi est-il important de publier les artefacts pour une application web ?
