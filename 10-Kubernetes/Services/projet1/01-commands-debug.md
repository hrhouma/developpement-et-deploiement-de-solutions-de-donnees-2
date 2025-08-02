# Commandes de débogage Kubernetes

## Recréer le cluster kind avec mapping des ports
```bash
# Supprimer l'ancien cluster
kind delete cluster

# Créer le nouveau cluster avec la configuration
kind create cluster --config kind-config.yaml
```

## Appliquer les configurations
```bash
# Créer le namespace
kubectl create namespace webapp-namespace

# Appliquer les configurations
kubectl apply -f deployment.yaml
kubectl apply -f service.yaml
```

## Vérifications importantes
```bash
# 1. Vérifier que les endpoints sont créés
kubectl get endpoints -n webapp-namespace webapp-service

# 2. Inspecter le service pour détecter les erreurs
kubectl describe svc -n webapp-namespace webapp-service

# 3. Tester depuis un pod
kubectl exec -n webapp-namespace -it <nom-du-pod> -- curl -s http://localhost:80

# 4. Vérifier les pods
kubectl get pods -n webapp-namespace

# 5. Voir les logs des pods
kubectl logs -n webapp-namespace <nom-du-pod>
```

## Tests de connectivité
```bash
# Depuis la VM (localhost)
curl http://localhost:31200/

# Depuis l'extérieur (IP publique Azure)
curl http://172.184.184.173:31200/

# Vérifier que le port est ouvert
nmap -p 31200 172.184.184.173
```

## Problèmes courants résolus
1. ✅ **targetPort mal configuré** : Était à 8080, maintenant à 80
2. ✅ **Cluster kind sans port mapping** : Maintenant configuré avec extraPortMappings
3. ✅ **Port 31200 dans Azure NSG** : Était déjà ouvert