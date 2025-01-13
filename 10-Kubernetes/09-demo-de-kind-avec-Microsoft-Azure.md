---
title: "Chapitre 9 - démonstration-kind-vm-azure commandes de gestion rapide avec kubectl (pratique7)"
description: "Je vous fournis un exemple exhaustif avec toutes les possibilités (clé SSH, mot de passe, variables avancées) pour gérer efficacement vos configurations Ansible."
emoji: "📖" 
---

# Chapitre 9 - démonstration de kind avec Microsoft Azure - commandes de gestion rapide avec kubectl (pratique7)

---
# 🎯 Objectif 
---

Dans ce tutoriel, vous apprendrez à :

- 🚀 Créer un cluster Kubernetes avec KIND sur Microsoft Azure
- 💻 Déployer une infrastructure cloud complète avec un seul nœud
- 🔧 Configurer et gérer votre cluster de manière efficace
- 📚 Maîtriser les concepts fondamentaux de Kubernetes
- ⚡ Optimiser vos déploiements pour un environnement de production

Ce guide est conçu pour être :
- ✅ Simple à suivre, même pour les débutants
- ✅ Applicable en environnement professionnel 
- ✅ Optimisé pour les bonnes pratiques DevOps

---
<a name="table-des-matieres"></a>
# Tableau des matières
---

1. [Configuration initiale d'Azure](#etape1)
   - Configuration du compte et des ressources Azure
   - Préparation de l'environnement avec script1_setup_azure.sh

2. [Déploiement du nœud master](#etape2)
   - Création de la VM master avec script2_create_master.sh
   - Configuration des paramètres réseau et sécurité

3. [Installation et configuration de Kubernetes](#etape3) 
   - Installation des composants avec script3_configure_master.sh
   - Déploiement du cluster Kind et configuration de kubectl

4. [Utilisation et tests du cluster](#etape4)
   - Commandes kubectl essentielles
   - Déploiement d'applications de test
   - Vérification de l'état du cluster

5. [Maintenance du cluster](#etape5)
   - 🔄 Réinitialisation du cluster avec 05-script5_kubernetes_reset.sh (*Script optionnel 🛠️*)
   - 🔧 Gestion des configurations et des ressources
   - 🔍 Vérification de l'état du cluster après réinitialisation
   - 🔧 ⚙️ 🔄 Configuration alternative avec 06-script3_configure_master2.sh (*Script optionnel 🛠️*) 

6. [Nettoyage de l'environnement](#etape7)
   - Suppression des ressources avec script7_cleanup.sh
   - Vérification du nettoyage complet


# 📑 Table des matières des scripts

| Étape | Script | Description | Lien |
|-------|--------|-------------|------|
| 1 | `01-script1_setup_azure.sh` | Configuration initiale de l'environnement Azure | [Voir le script 1](#script1) |
| 2 | `02-script2_create_master.sh` | Création du nœud master Kubernetes | [Voir le script 2](#script2) |
| 3 | `03-script3_configure_master.sh` | Installation et configuration de Kubernetes | [Voir le script 3](#script3) |
| 4 | *Pas de script* | Manipulations et tests avec kubectl | [Voir les commandes](#script4) |
| 5 | `05-script5_kubernetes_reset.sh` | Réinitialisation du cluster *(OPTIONNEL 1)* | [Voir le script 4](#script5) |
| 6 | `06-script3_configure_master2.sh` | Configuration alternative du master *(OPTIONNEL 2)* | [Voir le script 6](#script6) |
| 7 | `07-script7_cleanup.sh` | Nettoyage des ressources Azure | [Voir le script 7](#script7) |


---
# Introduction
---

Pour commencer, vous devez :

1. Créer un compte Azure :
   - Soit un compte étudiant via le programme Azure for Students
   - Soit un compte gratuit Azure Free Tier

2. Accéder au Shell Azure CLI :
   - Connectez-vous au portail Azure (portal.azure.com)
   - Cliquez sur l'icône du terminal en haut à droite de la page
   - Sélectionnez "Azure Cloud Shell"

3. Une fois dans le Shell Azure CLI, nous allons créer les scripts nécessaires pour déployer notre infrastructure.
   Les scripts seront créés comme indiqué ci-bas.

```bash
nano 01-script1_setup_azure.sh
nano 02-script2_create_master.sh
nano 03-script3_configure_master.sh
nano 05-script5_kubernetes_reset.sh
nano 06-script3_configure_master2.sh
nano 07-script7_cleanup.sh
```
### 🔧 ou simplement 

```bash
nano 0{1,2,3,5,6,7}-script{1_setup_azure,2_create_master,3_configure_master,5_kubernetes_reset,3_configure_master2,7_cleanup}.sh

```
#### [🏠 Retour à la table des matières](#table-des-matieres)

<a name="script1"></a>
<a name="etape1"></a>
---
# Étape 1 -  Création de l'environnement Azure pour Kubernetes 
---

# 📜 Script correspondant : `01-script1_setup_azure.sh`


#### Étape 1.1 - Création du fichier de configuration Azure

- Ouvrir  le fichier 01-script1_setup_azure.sh

```bash
nano 01-script1_setup_azure.sh
```


<a name="etape1.2"></a>
#### Étape 1.2 - Copiez le code

- Copiez le code ci-bas dans le fichier 01-script1_setup_azure.sh


```bash
#!/bin/bash

# Configuration des variables
RESOURCE_GROUP="k8s-cluster"
LOCATION="westus"
VNET_NAME="k8sVNet"
SUBNET_MASTER="k8sSubnetMaster"
SUBNET_WORKER="k8sSubnetWorker"
NSG_NAME="k8sMasterNSG"
NIC_NAME="k8sMasterNIC"

# Création du groupe de ressources
az group create --name $RESOURCE_GROUP --location $LOCATION

# Création du réseau virtuel et des sous-réseaux
az network vnet create --resource-group $RESOURCE_GROUP --name $VNET_NAME --address-prefix 10.0.0.0/16 \
    --subnet-name $SUBNET_MASTER --subnet-prefix 10.0.1.0/24

az network vnet subnet create --resource-group $RESOURCE_GROUP --vnet-name $VNET_NAME \
    --name $SUBNET_WORKER --address-prefix 10.0.2.0/24

# Création du groupe de sécurité réseau (NSG) pour le master
az network nsg create --resource-group $RESOURCE_GROUP --name $NSG_NAME --location $LOCATION

# Création de la règle NSG pour ouvrir le port 6443 (Kubernetes API Server)
az network nsg rule create --resource-group $RESOURCE_GROUP --nsg-name $NSG_NAME \
    --name AllowKubernetesAPI --priority 1000 --direction Inbound --access Allow \
    --protocol Tcp --destination-port-range 6443 --destination-address-prefix "*" \
    --source-address-prefix "*" --source-port-range "*"

# Association du NSG à la NIC de la VM master
# Note: Cette commande suppose que la NIC existe déjà. Si la NIC n'existe pas encore,
# elle doit être créée avec la VM ou explicitement avant d'exécuter cette commande.
# Cette étape est normalement effectuée lors de la création de la VM Master dans create_master.sh
# az network nic update --resource-group $RESOURCE_GROUP --name $NIC_NAME --network-security-group $NSG_NAME

echo "Environnement Azure pour Kubernetes est prêt."
```
 
#### Étape 1.3 - Exécuter le script

- Exécuter le script ci-bas dans le fichier 01-script1_setup_azure.sh

```bash
chmod +x 01-script1_setup_azure.sh
./01-script1_setup_azure.sh
```
#### [🏠 Retour à la table des matières](#table-des-matieres)

<a name="script2"></a>
<a name="etape2"></a>

---
# Étape 2 - Création de la VM Master pour Kubernetes
---

# 📜 Script correspondant : `02-script2_create_master.sh`



```bash
#!/bin/bash

# Configuration des variables pour le Master
RESOURCE_GROUP="k8s-cluster"
VM_NAME="k8sMaster"
VNET_NAME="k8sVNet"
SUBNET_NAME="k8sSubnetMaster"
VM_SIZE="Standard_D2s_v3"
IMAGE="Ubuntu2204"
USERNAME="azureuser"

# Création de la VM Master avec une taille ajustée
az vm create \
    --resource-group $RESOURCE_GROUP \
    --name $VM_NAME \
    --image $IMAGE \
    --size $VM_SIZE \
    --vnet-name $VNET_NAME \
    --subnet $SUBNET_NAME \
    --admin-username $USERNAME \
    --generate-ssh-keys

echo "VM Master créée."
 
```

<a name="script3"></a>
<a name="etape3"></a>

#### [🏠 Retour à la table des matières](#table-des-matieres)



---
# Étape 3 - Configuration de la VM Master pour Kubernetes
---

# 📜 Script correspondant : `03-script3_configure_master.sh`

```bash 
#!/bin/bash

# Configuration des variables
RESOURCE_GROUP="k8s-cluster"

echo "Toutes les VM ont été créées. Installation des composants Kubernetes sur le master..."

# Récupération de l'IP publique du Master
MASTER_IP=$(az vm show --resource-group $RESOURCE_GROUP --name k8sMaster --show-details --query publicIps -o tsv)

# Connexion SSH à la VM Master
ssh -o StrictHostKeyChecking=no azureuser@$MASTER_IP << 'EOF'
sudo bash << 'ENDSSH'

# Mise à jour des packages
apt-get update
apt-get install -y ca-certificates curl software-properties-common

# Installation de Docker
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
apt-get update
apt-get install -y docker-ce docker-ce-cli containerd.io

# Installation de Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64
chmod +x ./kind
mv ./kind /usr/local/bin/

# Installation de kubectl
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
mv kubectl /usr/local/bin/

# Suppression de l'ancien cluster Kind s'il existe
echo "Suppression de l'ancien cluster Kind s'il existe..."
kind delete cluster --name kind

# Création du fichier de configuration Kind pour un cluster avec 1 nœud de contrôle et 2 workers
cat <<EOT > kind-config.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
nodes:
- role: control-plane
- role: worker
- role: worker
EOT

# Création du cluster Kind
echo "Création du nouveau cluster Kind..."
kind create cluster --config kind-config.yaml

# Configuration de kubectl pour utiliser le cluster Kind
kubectl cluster-info --context kind-kind

echo "Le cluster Kind est configuré avec succès."

ENDSSH
EOF

echo "Configuration du master Kubernetes avec Kind et kubectl sur le master terminée." 

```


#### [🏠 Retour à la table des matières](#table-des-matieres)

<a name="etape4"></a>
---
# Étape 4 - Manipulations et tests avec kubectl
---



# Ces commandes sont à exécuter sur la MACHINE MASTER (nœud de contrôle)
> [!IMPORTANT]
> Assurez-vous d'être connecté sur la machine master avant d'exécuter les commandes suivantes.
> L'adresse IP et les identifiants de connexion doivent correspondre à votre configuration.

```bash 
ssh -o StrictHostKeyChecking=no azureuser@20.237.198.42
sudo -s
kubectl config get-contexts
kubectl get nodes -o wide
kubectl get po -o wide
kubectl run nginx --image=nginx --dry-run=client -o yaml
kubectl get po
kubectl get po -n kube-system
kubectl get po -n kube-system -o wide
```

```bash 
alias kpo='kubectl get po -o wide'
kpo
``` 

```bash 
alias k='kubectl'
k get po
k get no
```

```bash 
k run mynginx --image=nginx --dry-run=client -o yaml > pod.yaml 
k get po
k apply -f pod.yaml
```

> [!NOTE]
> La commande ci-dessous permet d'obtenir le même résultat que la séquence de commandes précédente, mais en une seule ligne
> k run mynginx --image=nginx --dry-run=client -o yaml > pod.yaml 
> k apply -f pod.yaml


#### [🏠 Retour à la table des matières](#table-des-matieres)

<a name="etape5"></a>
---
# Étape 5 - Réinitialisation du cluster Kubernetes
---

# 📜 Script correspondant : `05-script5_kubernetes_reset.sh`

> [!IMPORTANT]
> Exécutez ces commandes dans Azure Cloud Shell
> Ouvrez Azure Cloud Shell en cliquant sur l'icône du terminal dans le portail Azure
> Ou accédez à https://shell.azure.com.

> Assurez-vous d'être connecté à votre compte Azure

```bash
az login
```
> Cette commande vous permet de vous connecter à votre compte Azure.
> Vérifiez que vous êtes dans le bon abonnement

```bash
az account show
```
> Cette commande vous permet de vérifier que vous êtes dans le bon abonnement.

```bash
ssh -o StrictHostKeyChecking=no azureuser@20.237.198.42
sudo -s
./kubernetes_reset.sh
```
> Cette commande vous permet de vous connecter à la VM Master.
> Vous devez être dans le répertoire où se trouve le script kubernetes_reset.sh.

#### [🏠 Retour à la table des matières](#table-des-matieres)

<a name="script5"></a>
<a name="etape6"></a>
---
# Étape 6 - Réinitialisation du cluster Kubernetes en cas de problème
---

### 6.1. Réinitialisation du cluster Kubernetes en cas de problème
# 📜 Script correspondant : `05-script5_kubernetes_reset.sh`


```bash
#!/bin/bash

echo "Début de la réinitialisation de l'état de Kubernetes sur ce nœud..."

# Réinitialisation de l'état de kubeadm
echo "Exécution de kubeadm reset pour nettoyer l'état de Kubernetes..."
sudo kubeadm reset -f

# Nettoyage des répertoires de données de Kubernetes
echo "Nettoyage des répertoires de données de Kubernetes..."
sudo rm -rf /etc/kubernetes/manifests/*
sudo rm -rf /var/lib/etcd/*
sudo rm -rf /var/lib/kubelet/*
sudo rm -rf $HOME/.kube/config

# Redémarrage des services de conteneurs
echo "Redémarrage des services Docker et Containerd..."
sudo systemctl restart docker
sudo systemctl restart containerd

# Vérification et libération des ports utilisés par Kubernetes (OPTIONNEL)
echo "Vérification des ports utilisés par Kubernetes (10250, 2379, 2380)..."
sudo netstat -tulnpe | grep -E '10250|2379|2380'

echo "La réinitialisation est terminée. Vous pouvez maintenant réinitialiser votre cluster Kubernetes avec 'kubeadm init'."
```
<a name="script6"></a>
### 6.2. Reconfiguration du master apres réinitialisation en cas de problème

# 📜 Script correspondant : `06-script3_configure_master2.sh`


```bash
exit 
exit 
./script3_configure_master.sh

```


> [!NOTE]
> exit (pour quitter le mode admin)
> exit (pour quitter la VM)
> ./script3_configure_master.sh (au niveau du cloud shell azure CLI)
 

🔄 Utilisez le même script que dans l'étape 3 ⚙️


<a name="script7"></a>
<a name="etape7"></a>

#### [🏠 Retour à la table des matières](#table-des-matieres)


---
# Étape 7 - Nettoyage des ressources Azure
---

# 📜 Script correspondant : `07-script7_cleanup.sh`


```bash
#!/bin/bash

# Configuration des variables
RESOURCE_GROUP="k8s-cluster"

# Suppression du groupe de ressources et de toutes les ressources associées
az group delete --name $RESOURCE_GROUP --yes --no-wait

echo "Azure resources are being deleted..."
```


### 🔄 Alternative (ou) 🗑️

```bash
az group delete --name k8s-cluster --yes --no-wait
```


#### [🏠 Retour à la table des matières](#table-des-matieres)




