# 📚 Cours Exhaustif : Services Kubernetes

## 🎯 Introduction

Un **Service** dans Kubernetes est un objet qui définit comment exposer un ensemble de pods pour les rendre accessibles soit à l'intérieur du cluster, soit depuis l'extérieur.

### 🤔 Pourquoi les Services sont-ils nécessaires ?

1. **Les Pods sont éphémères** : Ils peuvent être créés, détruits, redémarrés
2. **Les IPs des Pods changent** : Chaque fois qu'un pod redémarre, il obtient une nouvelle IP
3. **Load Balancing** : Distribuer le trafic entre plusieurs répliques
4. **Discovery de service** : Permettre aux applications de se trouver mutuellement

### 🏗️ Comment ça fonctionne ?

```
[Client] → [Service] → [Pod 1]
                    → [Pod 2]
                    → [Pod 3]
```

Le Service agit comme un **proxy stable** qui route le trafic vers les pods sains.

### 🔍 Sélection des Pods

Les Services utilisent des **labels selectors** pour identifier quels pods cibler :

```yaml
# Service
spec:
  selector:
    app: webapp
    tier: frontend

# Pods correspondants
metadata:
  labels:
    app: webapp
    tier: frontend
```

### 🌐 DNS et Discovery

Kubernetes crée automatiquement des entrées DNS pour chaque service :
- Format : `<service-name>.<namespace>.svc.cluster.local`
- Exemple : `webapp-service.webapp-namespace.svc.cluster.local`

## 📊 Vue d'ensemble des Types de Services

| Type | Usage | Accessibilité | Environnement |
|------|-------|---------------|---------------|
| `ClusterIP` | Communication interne | Cluster seulement | Tous |
| `NodePort` | Développement/test | IP du nœud + port | Kind/Minikube |
| `LoadBalancer` | Production | IP publique | Cloud (AWS/Azure/GCP) |
| `ExternalName` | Redirection DNS | Externe | Tous |

---

## 🚀 Prochaines étapes

- **Partie 2** : ClusterIP - Le service par défaut
- **Partie 3** : NodePort - Développement et test
- **Partie 4** : LoadBalancer - Production cloud
- **Partie 5** : Ingress - La solution moderne
- **Partie 6** : Comparaisons et bonnes pratiques