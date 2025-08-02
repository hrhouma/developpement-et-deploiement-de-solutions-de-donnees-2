#!/bin/bash
# Script de déploiement automatisé pour le projet Gedeon

echo "🚀 Déploiement du projet Kubernetes..."

# 1. Recréer le cluster kind avec la bonne configuration
echo "📦 Recréation du cluster kind..."
kind delete cluster
kind create cluster --config kind-config.yaml

# 2. Attendre que le cluster soit prêt
echo "⏰ Attente que le cluster soit prêt..."
kubectl wait --for=condition=Ready nodes --all --timeout=300s

# 3. Créer le namespace
echo "📁 Création du namespace..."
kubectl create namespace webapp-namespace

# 4. Appliquer les configurations
echo "⚙️ Application des configurations..."
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml

# 5. Attendre que les pods soient prêts
echo "⏰ Attente que les pods soient prêts..."
kubectl wait --for=condition=Ready pod -l app=webapp -n webapp-namespace --timeout=300s

# 6. Afficher le statut
echo "📊 Statut du déploiement :"
kubectl get pods -n webapp-namespace
kubectl get svc -n webapp-namespace
kubectl get endpoints -n webapp-namespace

# 7. Test de connectivité
echo "🧪 Test de connectivité..."
sleep 5
echo "Test local (localhost:31200):"
curl -s http://localhost:31200/ | head -5

echo "✅ Déploiement terminé !"
echo "🌐 Application accessible sur :"
echo "   - Local: http://localhost:31200/"
echo "   - Externe: http://172.184.184.173:31200/"