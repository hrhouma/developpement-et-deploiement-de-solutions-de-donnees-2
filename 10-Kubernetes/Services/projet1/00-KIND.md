# Guide Exhaustif : Kind + Projet Services Kubernetes

## Table des matières

1. [Introduction à Kind](#introduction-kind)
2. [Installation Complète](#installation-complete)
3. [Configuration Kind pour Projet1](#configuration-projet1)
4. [Déploiement du Projet1](#deploiement-projet1)
5. [Services Kubernetes avec Kind](#services-kubernetes)
6. [Tests et Validation](#tests-validation)
7. [Troubleshooting Exhaustif](#troubleshooting)
8. [Commandes Essentielles](#commandes-essentielles)
9. [Annexes](#annexes)

---

<a name="introduction-kind"></a>
# 1. Introduction à Kind

## Qu'est-ce que Kind ?

Kind (Kubernetes IN Docker) permet d'exécuter des clusters Kubernetes locaux en utilisant des conteneurs Docker comme "nœuds". Parfait pour le développement et les tests.

### Avantages pour le Projet1

- **Création rapide** de clusters en 30 secondes
- **Port mapping** pour services NodePort  
- **Multi-clusters** pour différents environnements
- **Compatible** avec tous les types de services Kubernetes
- **Légèreté** (< 2GB RAM)

### Cas d'usage du Projet1

- **ClusterIP** : Communication interne entre pods
- **NodePort** : Accès via localhost:31200
- **LoadBalancer** : Simulation avec MetalLB
- **Ingress** : Routage HTTP/HTTPS avancé

---

<a name="installation-complete"></a>
# 2. Installation Complète

## 2.1 Prérequis

```bash
# Vérification système
lsb_release -a
free -h
df -h
uname -m
```

## 2.2 Installation Docker

```bash
# Méthode automatisée
cd ~/Desktop
git clone https://github.com/hrhouma/install-docker.git
cd install-docker/
chmod +x install-docker.sh
sudo ./install-docker.sh

# Vérification
docker --version
docker run hello-world
```

## 2.3 Installation Kind

```bash
# Téléchargement automatique selon architecture
if [ $(uname -m) = "x86_64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
elif [ $(uname -m) = "aarch64" ]; then
    curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-arm64
fi

chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind
kind --version
```

## 2.4 Installation kubectl

```bash
# Installation version stable
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl
sudo mv kubectl /usr/local/bin/kubectl

# Auto-complétion
echo 'source <(kubectl completion bash)' >> ~/.bashrc
echo 'alias k=kubectl' >> ~/.bashrc
source ~/.bashrc
```

---

<a name="configuration-projet1"></a>
# 3. Configuration Kind pour Projet1

## 3.1 Configuration Optimisée

```bash
# Configuration avec port mapping pour NodePort
cat <<EOF > kind-config-projet1.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: projet1-cluster
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 31200    # NodePort principal
    hostPort: 31200
    protocol: TCP
  - containerPort: 80       # Ingress HTTP
    hostPort: 8080
    protocol: TCP
  - containerPort: 443      # Ingress HTTPS
    hostPort: 8443
    protocol: TCP
- role: worker
- role: worker
EOF
```

## 3.2 Création du Cluster

```bash
# Création avec validation
kind create cluster --config kind-config-projet1.yaml --wait 300s

# Vérification
kubectl cluster-info --context kind-projet1-cluster
kubectl get nodes -o wide

# Configuration kubectl
kubectl config use-context kind-projet1-cluster
kubectl create namespace webapp-namespace
```

---

<a name="deploiement-projet1"></a>
# 4. Déploiement du Projet1

## 4.1 Structure du Projet

```bash
# Vérification de la structure
ls -la
ls -la yaml/

# Structure attendue:
# projet1/
# ├── 00-KIND.md
# ├── yaml/
# │   ├── deployment.yaml
# │   ├── service.yaml
# │   ├── ansible.yaml
# │   └── deploy-script.sh
```

## 4.2 Déploiement Étape par Étape

```bash
# 1. Examen des manifestes
echo "📄 Deployment configuration:"
cat yaml/deployment.yaml

echo "📄 Service configuration:"
cat yaml/service.yaml

# 2. Déploiement
kubectl apply -f yaml/deployment.yaml
kubectl apply -f yaml/service.yaml

# 3. Vérification
kubectl get pods -n webapp-namespace -o wide
kubectl get services -n webapp-namespace
kubectl get endpoints -n webapp-namespace

# 4. Attendre que les pods soient prêts
kubectl wait --for=condition=Ready pod -l app=webapp -n webapp-namespace --timeout=300s
```

## 4.3 Script de Déploiement Automatisé

```bash
# Rendre exécutable et lancer
chmod +x yaml/deploy-script.sh
./yaml/deploy-script.sh
```

---

<a name="services-kubernetes"></a>
# 5. Services Kubernetes avec Kind

## 5.1 Service ClusterIP (Par défaut)

```bash
# Vérification du service actuel
kubectl get service webapp-service -n webapp-namespace -o yaml

# Test d'accès interne
kubectl run test-internal --image=busybox --rm -it --restart=Never --namespace=webapp-namespace -- \
  wget -qO- http://webapp-service:8080
```

## 5.2 Service NodePort

```bash
# Conversion vers NodePort avec port 31200
kubectl patch service webapp-service -n webapp-namespace -p '{
  "spec": {
    "type": "NodePort",
    "ports": [{
      "port": 8080,
      "targetPort": 80,
      "nodePort": 31200
    }]
  }
}'

# Test depuis l'hôte (grâce au port mapping Kind)
echo "🌐 Test NodePort via localhost:31200"
curl -s http://localhost:31200/ | head -10

# Test avec retry si nécessaire
for i in {1..5}; do
  curl -s --connect-timeout 5 http://localhost:31200/ && break
  sleep 2
done
```

## 5.3 LoadBalancer avec MetalLB

```bash
# Installation MetalLB
kubectl apply -f https://raw.githubusercontent.com/metallb/metallb/v0.13.7/config/manifests/metallb-native.yaml

# Configuration MetalLB
cat <<EOF | kubectl apply -f -
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: example
  namespace: metallb-system
spec:
  addresses:
  - 172.18.255.200-172.18.255.250
---
apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: empty
  namespace: metallb-system
EOF

# Service LoadBalancer
kubectl patch service webapp-service -n webapp-namespace -p '{"spec":{"type":"LoadBalancer"}}'
```

## 5.4 Ingress Controller

```bash
# Installation NGINX Ingress
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/kind/deploy.yaml

# Attendre que l'ingress soit prêt
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s

# Configuration Ingress
cat <<EOF | kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: webapp-ingress
  namespace: webapp-namespace
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: localhost
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: webapp-service
            port:
              number: 8080
EOF

# Test Ingress via port 8080
echo "🌐 Test Ingress via localhost:8080"
curl -s http://localhost:8080/ | head -10
```

---

<a name="tests-validation"></a>
# 6. Tests et Validation

## 6.1 Script de Test Complet

```bash
# Création du script de test
cat <<'EOF' > test-all-services.sh
#!/bin/bash

echo "🧪 Tests complets des services Kubernetes"
echo "========================================"

# Test ClusterIP (interne)
echo "1. Test ClusterIP..."
kubectl run test-internal --image=busybox --rm -it --restart=Never --namespace=webapp-namespace -- \
  wget -qO- --timeout=10 http://webapp-service:8080 >/dev/null 2>&1 && \
  echo "✅ ClusterIP OK" || echo "❌ ClusterIP FAILED"

# Test NodePort
echo "2. Test NodePort..."
curl -s --connect-timeout 5 http://localhost:31200/ >/dev/null 2>&1 && \
  echo "✅ NodePort OK" || echo "❌ NodePort FAILED"

# Test Ingress
echo "3. Test Ingress..."
curl -s --connect-timeout 5 http://localhost:8080/ >/dev/null 2>&1 && \
  echo "✅ Ingress OK" || echo "❌ Ingress FAILED"

echo "🏁 Tests terminés"
EOF

chmod +x test-all-services.sh
./test-all-services.sh
```

## 6.2 Validation État du Cluster

```bash
# Validation complète
echo "📊 État du cluster:"
kubectl get nodes -o wide
kubectl get pods -n webapp-namespace -o wide
kubectl get services -n webapp-namespace
kubectl get ingress -n webapp-namespace
kubectl get endpoints -n webapp-namespace
```

---

<a name="troubleshooting"></a>
# 7. Troubleshooting Exhaustif

## 7.1 Diagnostic NodePort

```bash
# Problème NodePort inaccessible
echo "🔍 Diagnostic NodePort"

# 1. Vérifier le service
kubectl get service -n webapp-namespace -o wide

# 2. Vérifier les endpoints
kubectl get endpoints -n webapp-namespace

# 3. Vérifier le port mapping Kind
docker ps | grep control-plane

# 4. Test connectivité interne
kubectl exec -n webapp-namespace deployment/webapp-deployment -- curl -s http://localhost:80/
```

## 7.2 Solutions Communes

```bash
# Solution 1: Recréer cluster avec port mapping
kind delete cluster --name projet1-cluster
kind create cluster --config kind-config-projet1.yaml

# Solution 2: Vérifier les labels
kubectl get pods -n webapp-namespace --show-labels
kubectl label pods -n webapp-namespace -l app=webapp app=webapp --overwrite

# Solution 3: Redémarrer déploiement
kubectl rollout restart deployment webapp-deployment -n webapp-namespace
```

## 7.3 Debug Réseau

```bash
# Test réseau complet avec netshoot
kubectl run netshoot --image=nicolaka/netshoot --rm -it --restart=Never -- \
  sh -c "ping -c 3 google.com && nslookup webapp-service.webapp-namespace.svc.cluster.local"
```

---

<a name="commandes-essentielles"></a>
# 8. Commandes Essentielles

## 8.1 Commandes Kind

```bash
# Gestion clusters
kind create cluster --name projet1
kind get clusters
kind delete cluster --name projet1

# Images
kind load docker-image nginx:latest --name projet1

# Logs
kind export logs ./logs/ --name projet1
```

## 8.2 Commandes kubectl

```bash
# Ressources principales
kubectl get pods -n webapp-namespace -o wide
kubectl describe pod <pod-name> -n webapp-namespace
kubectl logs -n webapp-namespace -l app=webapp

# Services
kubectl get services -n webapp-namespace
kubectl describe service webapp-service -n webapp-namespace
kubectl get endpoints -n webapp-namespace

# Debug
kubectl exec -it deployment/webapp-deployment -n webapp-namespace -- bash
kubectl port-forward service/webapp-service 8080:8080 -n webapp-namespace
```

## 8.3 Tests Rapides

```bash
# Test ClusterIP
kubectl run test --image=busybox --rm -it --restart=Never --namespace=webapp-namespace -- \
  wget -qO- http://webapp-service:8080

# Test NodePort
curl http://localhost:31200/

# Test Ingress  
curl http://localhost:8080/
```

---

<a name="annexes"></a>
# 9. Annexes

## 9.1 Configuration Multi-Clusters

```bash
# Cluster dev
cat <<EOF > kind-config-dev.yaml
kind: Cluster
apiVersion: kind.x-k8s.io/v1alpha4
name: dev-cluster
nodes:
- role: control-plane
  extraPortMappings:
  - containerPort: 31200
    hostPort: 31200
- role: worker
EOF

kind create cluster --config kind-config-dev.yaml
```

## 9.2 Script de Basculement Contextes

```bash
cat <<'EOF' > switch-context.sh
#!/bin/bash
echo "Contextes disponibles:"
kubectl config get-contexts
echo "Contexte actuel: $(kubectl config current-context)"

read -p "Nouveau contexte: " context
kubectl config use-context $context
echo "Basculé vers: $(kubectl config current-context)"
EOF

chmod +x switch-context.sh
```

## 9.3 Historique Commandes Importantes

```bash
# Installation complète
cd ~/Desktop
git clone https://github.com/hrhouma/install-docker.git
cd install-docker/ && chmod +x install-docker.sh && sudo ./install-docker.sh

# Kind et kubectl
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.22.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
chmod +x kubectl && sudo mv kubectl /usr/local/bin/kubectl

# Cluster avec projet1
kind create cluster --config kind-config-projet1.yaml
kubectl create namespace webapp-namespace
kubectl apply -f yaml/deployment.yaml
kubectl apply -f yaml/service.yaml

# Tests
curl http://localhost:31200/
kubectl run test --image=busybox --rm -it --restart=Never --namespace=webapp-namespace -- \
  wget -qO- http://webapp-service:8080
```

## 9.4 Références

- [Kind Documentation](https://kind.sigs.k8s.io/)
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [NGINX Ingress](https://kubernetes.github.io/ingress-nginx/)

---

## Conclusion

- **Installation** complète de Kind + kubectl  
- **Configuration** optimisée pour le projet1  
- **Déploiement** de tous les types de services  
- **Tests** et validation exhaustifs  
- **Troubleshooting** détaillé  
- **Commandes** essentielles maîtrisées  

**Vous maîtrisez maintenant Kind pour le développement Kubernetes !**

[🔙 Retour au début](#guide-exhaustif--kind--projet-services-kubernetes)