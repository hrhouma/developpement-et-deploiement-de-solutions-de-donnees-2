### **Exercice 01 - Analyse et explication d'un pipeline YAML Azure DevOps**

#### **Objectif :**
Comprendre et expliquer le rôle de chaque section et tâche dans un pipeline YAML Azure DevOps pour un projet .NET Core.

---

### **Consignes :**
1. **Analysez le fichier YAML suivant.**  
   Votre tâche consiste à répondre aux questions suivantes pour chaque section et tâche.
   
2. **Structure de réponse attendue :**  
   - **Titre de la section/tâche**
   - **Explication de la fonction de cette section ou tâche**
   - **Paramètres importants et leur rôle**
   - **Exemple pratique ou utilité en contexte réel**

---

### **Fichier YAML fourni :**
```yaml
trigger:
- master

pool:
  vmImage: 'ubuntu-22.04'

steps:
- task: UseDotNet@2
  inputs:
    packageType: 'sdk'
    version: '7.x'
    installationPath: $(Agent.ToolsDirectory)/dotnet

- task: DotNetCoreCLI@2
  displayName: 'Restore Libraries'
  inputs:
    command: 'restore'
    projects: '**/*.csproj'

- task: DotNetCoreCLI@2
  displayName: 'Build'
  inputs:
    command: 'build'
    projects: '**/*.csproj'
    arguments: '--configuration $(BuildConfiguration)'

- task: DotNetCoreCLI@2
  displayName: 'Publish'
  inputs:
    command: 'publish'
    publishWebProjects: true
    projects: '**/*.csproj'
    arguments: '--configuration $(BuildConfiguration) --output $(Build.ArtifactStagingDirectory)'
    zipAfterPublish: true
    modifyOutputPath: true

- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(Build.ArtifactStagingDirectory)'
    ArtifactName: 'drop'
    publishLocation: 'Container'
```

---

### **Questions à répondre :**

#### **1. Section `trigger`**
   - Quel est le rôle du `trigger` dans ce fichier YAML ?  
   - Que signifie spécifiquement `- master` ?

#### **2. Section `pool`**
   - À quoi sert la section `pool` ?  
   - Pourquoi utilise-t-on `vmImage: 'ubuntu-22.04'` dans ce pipeline ?  

#### **3. Tâche `UseDotNet@2`**
   - Quel est l’objectif de cette tâche ?  
   - Que signifie `packageType: 'sdk'` et pourquoi choisit-on `version: '7.x'` ?  
   - Expliquez l’utilité de la variable `$(Agent.ToolsDirectory)`.

#### **4. Tâche `DotNetCoreCLI@2` (Restore Libraries)**
   - Quel est le rôle de cette tâche dans le pipeline ?  
   - Pourquoi utilise-t-on la commande `restore` et que signifie `projects: '**/*.csproj'` ?  

#### **5. Tâche `DotNetCoreCLI@2` (Build)**
   - Expliquez la commande `build`.  
   - Que signifie l’argument `--configuration $(BuildConfiguration)` ?  
   - Pourquoi cette étape est-elle essentielle dans un pipeline CI/CD ?

#### **6. Tâche `DotNetCoreCLI@2` (Publish)**
   - Quel est l’objectif de cette tâche ?  
   - Expliquez les paramètres `publishWebProjects`, `zipAfterPublish`, et `modifyOutputPath`.  
   - Pourquoi les artefacts générés sont-ils placés dans `$(Build.ArtifactStagingDirectory)` ?

#### **7. Tâche `PublishBuildArtifacts@1`**
   - À quoi sert cette tâche ?  
   - Expliquez les paramètres `PathtoPublish`, `ArtifactName`, et `publishLocation`.  
   - Où les artefacts sont-ils stockés après cette étape et comment sont-ils utilisés ?

---

### **Livrable attendu :**
1. **Un document structuré** contenant les explications pour chaque section et tâche.  
2. **Réponses claires et concises** aux questions.  
3. **Exemples pratiques** pour illustrer vos explications.  

---

### **Bonus : Question de réflexion**
Pourquoi le choix d’Azure DevOps pour CI/CD est-il avantageux dans un projet en .NET Core ?
