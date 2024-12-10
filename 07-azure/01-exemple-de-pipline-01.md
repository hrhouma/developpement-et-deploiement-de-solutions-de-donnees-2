
# exemple de pipeline 01

- Ce processus est utile pour automatiser la gestion d'une application .NET, de sa création à sa publication.

```
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

### **1. `trigger` :**
```yaml
trigger:
- master
```
- **Explication :** Ce bloc indique que le pipeline doit être déclenché lorsqu'il y a des modifications dans la branche `master`. Chaque commit ou merge dans cette branche exécutera automatiquement le pipeline.
- **Utilité :** Automatiser les tests, la construction, ou le déploiement dès qu’un changement est intégré dans la branche principale.

---

### **2. `pool` :**
```yaml
pool:
  vmImage: 'ubuntu-22.04'
```
- **Explication :** Spécifie le pool d’agents (machines exécutant le pipeline) utilisé pour exécuter ce workflow. Ici, le pipeline utilise une image préconfigurée avec Ubuntu 22.04 comme système d’exploitation.
- **Utilité :** Fournir un environnement standardisé pour exécuter les tâches. Ubuntu est souvent choisi pour sa légèreté et sa compatibilité.

---

### **3. Étapes (`steps`) :**

#### **Étape 1 : Installer le SDK .NET**
```yaml
- task: UseDotNet@2
  inputs:
    packageType: 'sdk'
    version: '7.x'
    installationPath: $(Agent.ToolsDirectory)/dotnet
```
- **Tâche :** `UseDotNet@2`
- **Explication :** Cette tâche installe le SDK .NET Core version `7.x`. 
  - `packageType: 'sdk'` indique que le SDK doit être installé (et non un runtime).
  - `version: '7.x'` demande une version spécifique (exemple : 7.0.1).
  - `installationPath: $(Agent.ToolsDirectory)/dotnet` spécifie où installer le SDK sur l’agent de build.
- **Utilité :** S’assurer que l’environnement a la bonne version du SDK pour construire l’application .NET.

---

#### **Étape 2 : Restaurer les dépendances**
```yaml
- task: DotNetCoreCLI@2
  displayName: 'Restore Libraries'
  inputs:
    command: 'restore'
    projects: '**/*.csproj'
```
- **Tâche :** `DotNetCoreCLI@2`
- **Explication :**
  - `command: 'restore'` exécute la commande `dotnet restore`, qui télécharge les dépendances déclarées dans les fichiers `.csproj` ou `packages.config`.
  - `projects: '**/*.csproj'` cible tous les fichiers projet `.csproj` du dépôt.
- **Utilité :** Préparer l’environnement en téléchargeant toutes les dépendances nécessaires avant de construire l’application.

---

#### **Étape 3 : Construire l’application**
```yaml
- task: DotNetCoreCLI@2
  displayName: 'Build'
  inputs:
    command: 'build'
    projects: '**/*.csproj'
    arguments: '--configuration $(BuildConfiguration)'
```
- **Tâche :** `DotNetCoreCLI@2`
- **Explication :**
  - `command: 'build'` exécute la commande `dotnet build` pour compiler l'application.
  - `projects: '**/*.csproj'` cible tous les projets `.csproj`.
  - `arguments: '--configuration $(BuildConfiguration)'` permet de spécifier la configuration de build (par exemple, Debug ou Release).
- **Utilité :** Compiler le code source et générer des fichiers binaires prêts à être testés ou publiés.

---

#### **Étape 4 : Publier l’application**
```yaml
- task: DotNetCoreCLI@2
  displayName: 'Publish'
  inputs:
    command: 'publish'
    publishWebProjects: true
    projects: '**/*.csproj'
    arguments: '--configuration $(BuildConfiguration) --output $(Build.ArtifactStagingDirectory)'
    zipAfterPublish: true
    modifyOutputPath: true
```
- **Tâche :** `DotNetCoreCLI@2`
- **Explication :**
  - `command: 'publish'` exécute la commande `dotnet publish`, qui génère une version prête pour le déploiement.
  - `publishWebProjects: true` publie uniquement les projets web.
  - `projects: '**/*.csproj'` cible tous les projets `.csproj`.
  - `arguments: '--configuration $(BuildConfiguration) --output $(Build.ArtifactStagingDirectory)'` :
    - `--configuration $(BuildConfiguration)` utilise la configuration définie dans les variables (Debug ou Release).
    - `--output $(Build.ArtifactStagingDirectory)` place les fichiers publiés dans un répertoire temporaire pour le pipeline.
  - `zipAfterPublish: true` compresse les fichiers publiés en une archive.
  - `modifyOutputPath: true` modifie le chemin de sortie pour mieux s'adapter au pipeline.
- **Utilité :** Générer une version packagée de l’application prête à être déployée.

---

#### **Étape 5 : Publier les artefacts**
```yaml
- task: PublishBuildArtifacts@1
  displayName: 'Publish Artifact'
  inputs:
    PathtoPublish: '$(Build.ArtifactStagingDirectory)'
    ArtifactName: 'drop'
    publishLocation: 'Container'
```
- **Tâche :** `PublishBuildArtifacts@1`
- **Explication :**
  - `PathtoPublish: '$(Build.ArtifactStagingDirectory)'` spécifie que les fichiers à publier se trouvent dans le répertoire de staging.
  - `ArtifactName: 'drop'` donne un nom au package publié.
  - `publishLocation: 'Container'` enregistre les artefacts dans un conteneur Azure DevOps.
- **Utilité :** Rendre les fichiers générés disponibles pour le déploiement ou les tests dans les étapes suivantes.

---

### **Résumé :**
Ce pipeline CI/CD suit une structure classique :
1. **Installation du SDK .NET** pour garantir un environnement cohérent.
2. **Restauration des dépendances** pour préparer l’application.
3. **Compilation** du code pour vérifier son bon fonctionnement.
4. **Publication** des fichiers déployables.
5. **Archivage** des artefacts pour les utiliser dans d’autres étapes ou pipelines.

