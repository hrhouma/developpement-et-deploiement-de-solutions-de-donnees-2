---
title: "Chapitre 4 - installer minikube sur un serveur linux (pratique2)"
description: "Découvrez la théorie des variables, facts et registers pour créer des playbooks plus intelligents et dynamiques."
emoji: "🔧"
---

# Chapitre 4 - installer minikube sur un serveur linux (pratique2)
# Installation de Minikube sur Linux

## Prérequis

- Un serveur fonctionnant sous Ubuntu 22.04, 20.04, 18.04, 16.04 ou toute autre distribution basée sur Debian
- Il est recommandé d'utiliser une installation fraîche du système d'exploitation pour éviter tout problème inattendu
- Accès root au serveur

## Vue d'ensemble

Avant d'aborder Minikube, il est important de comprendre ce qu'est Kubernetes, car Minikube est une variante de Kubernetes couramment utilisée.

> Kubernetes est une plateforme portable, extensible et open source pour la gestion des charges de travail et des services conteneurisés, qui facilite à la fois la configuration déclarative et l'automatisation. En d'autres termes, Kubernetes est un gestionnaire de conteneurs qui gère plusieurs conteneurs pour servir à une extrémité et empêche le service d'être interrompu ou surchargé en répartissant toutes les charges et en les équilibrant sur tous les conteneurs simultanément. Plus simplement, Kubernetes est un gestionnaire multi-services.

Minikube est une implémentation légère de Kubernetes qui crée une machine virtuelle sur votre machine locale et déploie un cluster simple ne contenant qu'un seul nœud (nœud = machine/serveur). Minikube est disponible pour les systèmes Linux, macOS et Windows. Minikube est le type de Kubernetes le plus simple et le plus facile à utiliser si vous n'avez qu'un seul serveur à faire fonctionner.



## Étapes d'installation

### 1. Installation de Docker


Dans cet article, nous utiliserons Docker comme base pour Minikube. Si Docker n'est pas installé :

 ```powershell
sudo apt-get install docker.io -y 
sudo usermod -aG docker $USER && newgrp docker
```

### 2. Mise à jour des paquets système et installation des dépendances de Minikube

 ```powershell
sudo apt update
sudo apt install -y curl wget apt-transport-https
```

### 3. Installation de Minikube

Utilisez la commande curl suivante pour télécharger la dernière version binaire de Minikube :

 ```powershell
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
 ```

Une fois le binaire téléchargé, copiez-le dans le chemin /usr/local/bin et définissez les permissions exécutables sur lui :

 ```powershell
sudo install minikube-linux-amd64 /usr/local/bin/minikube
 ```

Vérifiez la version de Minikube :

```powershell
minikube version
```

> output
>```powershell
>minikube version: v1.32.0
>commit: 8220a6eb95f0a4d75f7f2d7b14cef975f050512d
>```

> Note: Au moment de la rédaction de ce tutoriel, la dernière version de minikube était la v1.32.0

### 4. Installation de kubectl

kubectl est une commande en ligne utilisée pour interagir avec le cluster Kubernetes. Elle est utilisée pour gérer les déploiements, les réplicas, les services, etc. Utilisez la commande suivante pour télécharger la dernière version de kubectl :

 ```powershell
curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
 ```

Une fois Kubectl téléchargé, définissez les permissions exécutables sur le binaire Kubectl et déplacez-le dans le chemin /usr/local/bin :

 ```powershell
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
 ```
> bouger le fichier kubectl dans le chemin /usr/local/bin qui est le chemin par défaut pour les binaires


 ```powershell
kubectl version -o yaml
 ```
> Vérifiez la version de kubectl 



### 5. Démarrer Minikube

Comme nous l'avons mentionné au début, nous utiliserons Docker comme base pour Minikube, donc démarrez Minikube avec le pilote Docker et exécutez :

 ```powershell
minikube start --driver=docker
 ```


### 6. Vérifier l'installation

Exécutez la commande suivante pour vérifier le statut :

```powershell
minikube status
```
> output
>```powershell
>minikube
>type: Control Plane
>host: Running
>kubelet: Running
>apiserver: Running
>kubeconfig: Configured 
>```

Exécutez la commande suivante pour vérifier la version de Kubernetes, le statut du nœud et les informations du cluster :

 ```powershell
 kubectl cluster-info
 ```
> output
>```powershell
>Le plan de contrôle Kubernetes est en cours d'exécution sur https://192.168.49.2:8443
>CoreDNS est en cours d'exécution sur https://192.168.49.2:8443/api/v1/namespaces/kube-system/services/kube-dns:dns/proxy
>```

Pour déboguer et diagnostiquer davantage les problèmes de cluster, utilisez   'kubectl cluster-info dump'.

 ```powershell

 ```
> output
>```powershell
>kubectl get nodes
>NOM       STATUT   RÔLES           ÂGE     VERSION
>minikube   Prêt    control-plane   3m27s   v1.30.0
>```

### 7. Gestion des addons sur minikube

Par défaut, seuls quelques addons sont activés lors de l'installation de Minikube. Pour voir les addons dans Minikube, exécutez la commande suivante :

 ```powershell
minikube addons list
 ```
> output
>```powershell
>minikube addons list
>```


Si vous souhaitez activer un addon, exécutez la commande suivante :

```powershell
minikube addons enable metrics-server
 ```

Supposons que nous souhaitons activer et accéder au tableau de bord Kubernetes. Exécutez :

```powershell
minikube dashboard
```

Pour le serveur, utilisez ces commandes

```powershell
minikube dashboard --url
 ```
> output
>```powershell
>minikube dashboard --url
>```


Exécutez la commande en arrière-plan

```powershell
kubectl proxy --address='0.0.0.0' --disable-filter=true &
 ```
> output
>```powershell
>W0423 04:59:24.539492   15291 proxy.go:177] Request filter disabled, your proxy is vulnerable to XSRF attacks, please be cautious
>Starting to serve on [::]:8001
>Use server IP and port [::]:8001 and use url /api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/
> http://server_ip:8001/api/v1/namespaces/kubernetes-dashboard/services/http:kubernetes-dashboard:/proxy/#/workloads?namespace=default
>```


Enjoy it! 🍻 That’s It; we are done...


# Références:

- https://medium.com/cypik/installing-minikube-on-ubuntu-22-04-lts-77f5abaf3d39
- https://kubernetes.io/docs/setup/production-environment/tools/kubeadm/install-kubeadm/
