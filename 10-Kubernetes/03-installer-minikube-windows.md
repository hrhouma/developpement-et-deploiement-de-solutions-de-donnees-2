---
title: "Chapitre 3 - installer minikube sur une machine windows (pratique1)"
description: "Découvrez les principes fondamentaux de Terraform et comprenez comment l'Infrastructure as Code révolutionne le déploiement."
emoji: "🔧"
---

# Chapitre 3 - installer minikube sur une machine windows (pratique1)


Dans ce chapitre, nous allons explorer l'installation et la configuration de Minikube sur Windows. Cette introduction pratique vous permettra de :

- **Comprendre les prérequis** pour installer Minikube sur Windows
- **Découvrir comment configurer** votre environnement Kubernetes local
- **Maîtriser les étapes** d'installation et de configuration de Minikube

Ce guide rendra chaque étape simple et accessible, en vous guidant pas à pas dans la mise en place de votre environnement Kubernetes local avec Minikube.



---
## Étape 1 : Installation et Configuration de kubectl sur Windows



### Installation de kubectl sur Windows

Cette section explique comment installer et configurer kubectl sur Windows, l'outil en ligne de commande indispensable pour interagir avec les clusters Kubernetes.

Pour plus de détails, consultez la [documentation officielle](https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/).


### 1.1. Téléchargement de kubectl

Pour commencer, nous devons créer un dossier dédié pour kubectl :

  ```powershell
  mkdir C:\Users\hrehouma\Documents\kubectl
  cd C:\Users\hrehouma\Documents\kubectl
  ```


> 💡 **Note**: Remplacez `hrehouma` par votre nom d'utilisateur. Vous pouvez le connaître en tapant la commande `whoami` dans PowerShell.

- Téléchargez l'exécutable kubectl :

```powershell
curl.exe -LO "https://dl.k8s.io/release/v1.30.0/bin/windows/amd64/kubectl.exe"
```

1.2. Téléchargement du fichier de vérification
- Pour garantir l'intégrité du binaire, téléchargez le fichier de somme de contrôle :

```powershell 
curl.exe -LO "https://dl.k8s.io/v1.30.0/bin/windows/amd64/kubectl.exe.sha256"
```

### 1.3. Valider les binaires

```powershell 
CertUtil -hashfile kubectl.exe SHA256
```

Pour vérifier l'intégrité du fichier kubectl.exe téléchargé, utilisez la commande suivante :

```powershell 
type kubectl.exe.sha256
```

### 1.4. Tester l'outil kubectl avant de l'ajouter au path




```powershell 
kubectl version --client
```
> *Affiche la version du client kubectl en format texte*

##### Affiche la version du client kubectl en format yaml

```powershell 
kubectl version --client --output=yaml
```
> *Affiche la version du client kubectl en format yaml*

### 1.5. Ajouter kubectl au PATH système

Pour ajouter kubectl aux variables d'environnement système :

1. Ouvrez les "Variables d'environnement système" :
   - Appuyez sur `Windows + R`
   - Tapez `sysdm.cpl`
   - Cliquez sur "Variables d'environnement"

2. Dans la section "Variables système", sélectionnez "Path" et cliquez sur "Modifier"

3. Ajoutez le chemin complet vers kubectl :
   ```
   C:\Users\<votre_utilisateur>\Documents\kubectl
   ```

> 💡 **Note**: Remplacez `<votre_utilisateur>` par votre nom d'utilisateur Windows. Pour le connaître, exécutez la commande `whoami` dans PowerShell.

4. Cliquez sur "OK" pour sauvegarder les modifications

5. **Important**: Redémarrez votre terminal PowerShell pour que les changements prennent effet



### 1.6. Accéder au répertoire utilisateur

- Pour accéder à votre répertoire utilisateur Windows :


```powershell 
cd %USERPROFILE%  
```

> par exemple, ça me ramene à mon répertoire d'utilisateur cd C:\Users\hrehouma


- Vérifiez si le dossier .kube existe dans votre répertoire utilisateur. Si ce n'est pas le cas, nous allons le créer :


> 💡 **Note**: Création du dossier .kube et du fichier de configuration
> Le dossier .kube est essentiel pour kubectl - il stocke la configuration du cluster
> Le fichier config contiendra les informations de connexion aux clusters


```powershell 
mkdir .kube
cd .kube
powershell
New-Item config -type file
```

> 💡 **Note**: Le dossier .kube est utilisé par kubectl pour stocker sa configuration



### 1.7. Vérification finale


```powershell 
kubectl cluster-info
kubectl cluster-info dump
```
> ⚠️ Attention ! Ces commandes peuvent ne pas fonctionner étant donné que nous n'avons pas encore créé de cluster 🚫



### 1.8. Vérification finale 

Fermer la ligne de commande et réouvrir

```powershell 
kubectl version --client
```
> *Affiche la version du client kubectl en format texte*
```powershell 
kubectl version --client --output=yaml
```
> *Affiche la version du client kubectl en format yaml*


---

## Étape 2 : Installation et Configuration de Minikube sur Windows


### 2.1. Installation de Minikube sur Windows

Pour installer Minikube sur Windows, nous allons suivre les étapes suivantes :

1. Téléchargez l'exécutable Minikube depuis le site officiel :
   [Télécharger Minikube pour Windows](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)

> 💡 **Note**: Assurez-vous d'avoir les prérequis suivants installés :
> - Windows 10 64-bit ou plus récent
> - 4GB de RAM minimum (8GB recommandé)
> - 20GB d'espace disque libre
> - Un hyperviseur (VirtualBox, Hyper-V, etc.)

### 2.2. Créer un dossier minikube dans Documents

> Écrire cmd ensuite powershell

```powershell 
mkdir C:\Users\%USERPROFILE%\Documents\minikube
cd C:\Users\%USERPROFILE%\Documents\minikube
```


### 2.3. Création et téléchargement de minikube dans le dossier C:\minikube 

> 💡 **Note**: Le téléchargement et l'installation se font automatiquement via PowerShell. Contentez-vous d'exécuter les commandes suivantes sans intervention manuelle.


```powershell 
New-Item -Path 'c:\' -Name 'minikube' -ItemType Directory -Force
Invoke-WebRequest -OutFile 'c:\minikube\minikube.exe' -Uri 'https://github.com/kubernetes/minikube/releases/latest/download/minikube-windows-amd64.exe' -UseBasicParsing
```


### 2.4. Ajout de Minikube au PATH système

Il existe deux méthodes pour ajouter Minikube au PATH système :

#### Méthode 1 : Via l'interface graphique Windows

1. Ouvrez les "Paramètres système avancés"
2. Cliquez sur "Variables d'environnement"
3. Dans la section "Variables système", sélectionnez "Path"
4. Cliquez sur "Modifier"
5. Ajoutez le chemin `C:\minikube`
6. Cliquez sur "OK" pour sauvegarder

#### Méthode 2 : Via PowerShell (recommandée)

Exécutez la commande PowerShell ci-dessous pour ajouter automatiquement Minikube au PATH :

```powershell 
$oldPath = [Environment]::GetEnvironmentVariable('Path', [EnvironmentVariableTarget]::Machine)


if ($oldPath.Split(';') -inotcontains 'C:\minikube'){
  [Environment]::SetEnvironmentVariable('Path', $('{0};C:\minikube' -f $oldPath), [EnvironmentVariableTarget]::Machine)
}
```

### 2.5. Vérifier l'ajout de Minikube au PATH système

Pour vérifier que Minikube a bien été ajouté au PATH système, vous pouvez utiliser l'une des méthodes suivantes :

#### Via l'invite de commandes (CMD)

```cmd
path
```

#### Via PowerShell

```powershell
$env:Path
```

---

## Étape 3 : Démarrer le cluster Minikube


### 3.1. Démarrer le cluster

Pour démarrer votre cluster Minikube, exécutez la commande suivante dans PowerShell :

```powershell
minikube start
```

💡 **Note**: Lors de mes tentatives de démarrage du cluster Minikube, j'ai rencontré plusieurs difficultés qui ont nécessité différentes approches :

> 1. **Première tentative** - Commande basique (échec) ❌ :
> ```powershell
> minikube start
> ```
> 2. **Deuxième tentative** - Utilisation du driver VirtualBox (échec) ❌ :
> ```powershell
> minikube start --driver=virtualbox
> ```
> 3. **Troisième tentative** - Utilisation du driver VirtualBox sans vérification de la compatibilité avec VT-x (échec) ❌ :
> ```powershell
> minikube start --driver=virtualbox --no-vtx-check
> ```
> 4. **Quatrième tentative** - Suppression du cluster existant et démarrage avec le driver Hyper-V (succès) ✅ :
> ```powershell
> minikube delete
> minikube start --no-vtx-check
> ```


##### 📝 Voir l'annexe 1  pour les Détails des erreurs rencontrées




## Étape 4 : Tests et commandes pour tester le cluster

1. **Utilisation directe de kubectl** :

```powershell
minikube kubectl -- get po -A
```
> *Affiche les pods dans tous les namespaces*

2. **Création d'un alias pour kubectl** :


```powershell
alias kctl="minikube kubectl"
```
> *Crée un alias pour kubectl*
3. **Utilisation de minikube kubectl** :

```powershell
kctl get po -A
```
> *Utilise l'alias pour afficher les pods dans tous les namespaces*

4. **Refaire les mêmes manipulations avec kubectl** :
```powershell
alias kctl="minikube kubectl"
kubectl get po -A
```
> *Affiche les pods dans tous les namespaces*

5. **Ouvrir le dashboard** :

> *excécuter la commande ci-bas dans un nouvel terminal cmd et laisser le dashborad ouvert, ouvrez un navigateur et tapez localhost:30000*

```powershell
minikube dashboard 
```
6. **Résumé des commandes** :

```powershell
kubectl get po -A
```
> *Affiche les pods dans tous les namespaces*

```powershell
minikube kubectl -- get po -A
```
> *Affiche les pods dans tous les namespaces*

```powershell
alias kubectl="minikube kubectl --"
```
> *Crée un alias pour kubectl*

```powershell
minikube dashboard --url 
```
> *Ouvre le dashboard*

```powershell
minikube dashboard --url --no-sandbox
```
> *Ouvre le dashboard sans sandbox*

```powershell
minikube dashboard --url --no-sandbox --skip-open-browser
```
> *Ouvre le dashboard sans sandbox et sans ouvrir le navigateur*

```powershell
minikube dashboard --url --no-sandbox --skip-open-browser --skip-minikube-start
```
> *Ouvre le dashboard sans sandbox et sans ouvrir le navigateur et sans démarrer minikube*

```powershell
minikube dashboard --url --no-sandbox --skip-open-browser --skip-minikube-start --skip-minikube-download
```
> *Ouvre le dashboard sans sandbox et sans ouvrir le navigateur et sans démarrer minikube et sans télécharger minikube*

```powershell
minikube dashboard --url --no-sandbox --skip-open-browser --skip-minikube-start --skip-minikube-download --skip-minikube-download-check
```
> *Ouvre le dashboard sans sandbox et sans ouvrir le navigateur et sans démarrer minikube et sans télécharger minikube et sans vérifier le téléchargement de minikube*

```powershell 
minikube dashboard --url --no-sandbox --skip-open-browser --skip-minikube-start --skip-minikube-download --skip-minikube-download-check --skip-minikube-download-check-minikube
```
> *Ouvre le dashboard sans sandbox et sans ouvrir le navigateur et sans démarrer minikube et sans télécharger minikube et sans vérifier le téléchargement de minikube et sans vérifier le téléchargement de minikube*

---

## Étape 5 : Gérer le cycle de vie du cluster Minikube


```powershell
minikube pause
```
> *pause le cluster*

```powershell
minikube unpause
```
> *unpause le cluster*

```powershell
minikube stop
```
> *stop le cluster*

```powershell
minikube config set memory 9001
```
> *set la mémoire du cluster*

```powershell
minikube addons list
```
> *liste les addons*

```powershell
minikube start -p aged --kubernetes-version=v1.16.1
```
> *start le cluster avec le namespace aged et la version kubernetes v1.16.1*

```powershell
minikube delete --all
```
> *delete tous les clusters*

```powershell
minikube start --driver=docker
```
> *start le cluster avec le driver docker*

```powershell
minikube start --driver=virtualbox
```
> *start le cluster avec le driver virtualbox*

```powershell
minikube start --driver=hyperv
```
> *start le cluster avec le driver hyperv*

```powershell
minikube start --driver=hyperkit
```
> *start le cluster avec le driver hyperkit*

```powershell
minikube start --driver=podman
```
> *start le cluster avec le driver podman*

```powershell
minikube start --driver=none
```
> *start le cluster avec le driver none*

```powershell
minikube start --driver=docker --container-runtime=containerd
```
> *start le cluster avec le driver docker et le container runtime containerd*

```powershell
minikube start --driver=docker --container-runtime=cri-o
```
> *start le cluster avec le driver docker et le container runtime cri-o*

```powershell
minikube start --driver=docker --container-runtime=cri-o --container-runtime-endpoint=/var/run/crio/crio.sock
```
> *start le cluster avec le driver docker et le container runtime cri-o et le endpoint /var/run/crio/crio.sock*







---
# Références et ressources utiles :

- [Manipulations et commandes avec minikube](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)
- [Documentation officielle de Minikube](https://minikube.sigs.k8s.io/docs/)
- [Guide d'installation de Minikube sur Windows](https://minikube.sigs.k8s.io/docs/start/?arch=%2Fwindows%2Fx86-64%2Fstable%2F.exe+download)
- [Documentation des drivers supportés](https://minikube.sigs.k8s.io/docs/drivers/)
- [Tutoriels et exemples d'utilisation](https://minikube.sigs.k8s.io/docs/tutorials/)


<br/>
# Annexe 1 : Détails des erreurs rencontrées

---
### Tentative 1 et 2 
---

```ssh
Message d'erreur: 
X Exiting due to HOST_VIRT_UNAVAILABLE: Failed to start host: creating host: create: precreate: This computer doesn't have VT-X/AMD-v enabled. Enabling it in the BIOS is mandatory
* Suggestion: Virtualization support is disabled on your computer. If you are running minikube within a VM, try '--driver=docker'. Otherwise, consult your systems BIOS manual for how to enable virtualization.
* Related issues:
  - https://github.com/kubernetes/minikube/issues/3900
  - https://github.com/kubernetes/minikube/issues/4730
```

### Solution: https://stackoverflow.com/questions/70813386/how-to-resolve-minikube-start-error-this-computer-doesnt-have-vt-x-amd-v-enab

--------------------
### Tentative 3 
--------------------

```ssh
Message d'erreur:

X Exiting due to GUEST_NOT_FOUND: Failed to start host: error loading existing host. Please try running [minikube delete], then run [minikube start] again: filestore "minikube": open C:\Users\me\.minikube\machines\minikube\config.json: The system cannot find the file specified.
* Suggestion: minikube is missing files relating to your guest environment. This can be fixed by running 'minikube delete'
* Related issue: https://github.com/kubernetes/minikube/issues/9130
```

### Solution: https://github.com/kubernetes/minikube/issues/13498

```ssh
I had same problem and I resolved my problem with
1-) minikube delete
2-) minikube start --no-vtx-check (Without specifying driver)
Magically it worked maybe it will help you too.
```