# 📚 Cours Exhaustif : Services Kubernetes

Bienvenue dans le cours le plus complet sur les services Kubernetes ! Cette documentation couvre tout ce que vous devez savoir pour maîtriser les services en développement et en production.

## 🎯 Structure du Cours

### 📖 Modules Principaux

| Module | Fichier | Description | Durée |
|--------|---------|-------------|-------|
| **1** | [Introduction](01-introduction-services-kubernetes.md) | Concepts de base et vue d'ensemble | 30 min |
| **2** | [ClusterIP](02-clusterip-service.md) | Service par défaut - Communication interne | 45 min |
| **3** | [NodePort](03-nodeport-service.md) | Développement et test local | 60 min |
| **4** | [LoadBalancer](04-loadbalancer-service.md) | Production cloud simple | 45 min |
| **5** | [Ingress](05-ingress-solution-moderne.md) | Solution moderne pour la production | 90 min |
| **6** | [Comparaisons](06-comparaisons-et-bonnes-pratiques.md) | Bonnes pratiques et patterns | 60 min |
| **7** | [Visualisations](07-visualisations-services-kubernetes.md) | **🎨 Approche visuelle exhaustive** | 45 min |
| **8** | [Quiz](08-quiz-services-kubernetes.md) | **🧠 50 questions + mises en situation** | 60 min |

**⏱️ Durée totale estimée : 7h15**

## 🚀 Parcours d'Apprentissage Recommandé

### 🎓 Débutant (2h)
1. ✅ Module 1 : Introduction
2. ✅ Module 2 : ClusterIP (bases)
3. ✅ Module 3 : NodePort (développement)

### 🛠️ Intermédiaire (4h)
1. ✅ Modules 1-3 (révision rapide)
2. ✅ Module 4 : LoadBalancer
3. ✅ Module 5 : Ingress (partie 1)
4. ✅ Module 6 : Comparaisons (section décision)

### 🚀 Avancé (7h15)
1. ✅ **Tous les modules** avec exercices pratiques
2. ✅ **Module 7** : Visualisations et diagrammes
3. ✅ **Module 8** : Quiz exhaustif de validation
4. ✅ Implémentation des patterns avancés
5. ✅ Configuration monitoring et sécurité

## 🎯 Objectifs Pédagogiques

### À la fin de ce cours, vous saurez :

#### 🎯 **Comprendre**
- [x] La différence entre les 4 types de services
- [x] Quand utiliser chaque type selon l'environnement
- [x] L'architecture et le routage réseau

#### 🛠️ **Configurer**
- [x] Services ClusterIP pour la communication interne
- [x] NodePort pour le développement local (Kind/Minikube)
- [x] LoadBalancer pour la production cloud
- [x] Ingress avec SSL automatique et routage avancé

#### 🚀 **Déployer**
- [x] Applications complètes avec services appropriés
- [x] Monitoring et observabilité
- [x] Sécurité et network policies
- [x] Patterns de déploiement (Blue-Green, Canary)

## 💡 Concepts Clés Couverts

### 🏗️ **Architecture**
- Services vs Pods vs Deployments
- Load balancing et service discovery
- DNS et communication inter-services

### 🌐 **Réseau**
- ClusterIP (interne uniquement)
- NodePort (développement)
- LoadBalancer (production cloud)
- Ingress (production moderne)

### 🔒 **Sécurité**
- Network policies
- SSL/TLS automatique
- Rate limiting et authentification
- Restriction par IP

### 📊 **Observabilité**
- Monitoring avec Prometheus
- Logs centralisés
- Tracing distribué
- Health checks

## 🛠️ Environnements Pratiques

### 🐳 **Développement Local**
```bash
# Kind avec port mapping
kind create cluster --config kind-config.yaml

# NodePort pour accès rapide
kubectl apply -f examples/nodeport-dev.yaml
curl http://localhost:31200/
```

### ☁️ **Production Cloud**
```bash
# Ingress avec SSL automatique
kubectl apply -f examples/ingress-production.yaml

# Accès via domaine
curl https://myapp.example.com/
```

## 📊 Comparaison Rapide

| Environnement | Service Recommandé | Coût | Complexité |
|---------------|-------------------|------|------------|
| **Kind/Minikube** | NodePort + extraPortMappings | Gratuit | Simple |
| **Développement Cloud** | LoadBalancer | $18/mois | Simple |
| **Production (1 service)** | LoadBalancer | $18/mois | Moyen |
| **Production (Multi-services)** | Ingress | $18/mois total | Avancé |

## 🧪 Exercices Pratiques

### 🎯 Exercice 1 : Service ClusterIP
**Objectif :** Créer une communication entre microservices

```bash
# 1. Déployer une base de données
kubectl apply -f exercises/database-deployment.yaml

# 2. Créer un service ClusterIP
kubectl apply -f exercises/database-service.yaml

# 3. Tester la connectivité depuis une app
kubectl apply -f exercises/app-deployment.yaml
```

### 🎯 Exercice 2 : NodePort pour Développement
**Objectif :** Exposer une application en développement

```bash
# 1. Configurer Kind avec port mapping
kind create cluster --config exercises/kind-config.yaml

# 2. Déployer avec NodePort
kubectl apply -f exercises/webapp-nodeport.yaml

# 3. Tester l'accès
curl http://localhost:31200/
```

### 🎯 Exercice 3 : Ingress Production
**Objectif :** Configuration complète de production

```bash
# 1. Installer ingress controller
helm install ingress-nginx ingress-nginx/ingress-nginx

# 2. Configurer cert-manager
kubectl apply -f exercises/cert-manager.yaml

# 3. Déployer avec SSL automatique
kubectl apply -f exercises/production-ingress.yaml
```

## 🔧 Outils et Scripts

### 📜 Scripts Utiles
- `debug-service.sh` - Debug et diagnostic des services
- `validate-service.sh` - Validation des configurations
- `deploy-script.sh` - Déploiement automatisé

### 🛠️ Commandes Essentielles
```bash
# Lister tous les services
kubectl get svc --all-namespaces

# Debug d'un service
kubectl describe svc <service-name> -n <namespace>

# Vérifier les endpoints
kubectl get endpoints <service-name> -n <namespace>

# Test de connectivité
kubectl run test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://<service-name>.<namespace>/
```

## 🎓 Ressources Supplémentaires

### 📚 Documentation Officielle
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [Network Policies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

### 🔗 Outils Recommandés
- **Kind** : Kubernetes local
- **cert-manager** : Certificats SSL automatiques
- **NGINX Ingress** : Controller Ingress populaire
- **MetalLB** : LoadBalancer pour on-premise

## ❓ FAQ

### **Q: Quel service utiliser pour mon cas ?**
**A:** Consultez le flowchart dans le [Module 6](06-comparaisons-et-bonnes-pratiques.md#-flowchart-de-décision)

### **Q: Pourquoi mon LoadBalancer reste en `<pending>` ?**
**A:** Vous n'êtes probablement pas dans un environnement cloud. Voir [Module 4](04-loadbalancer-service.md#-problèmes-courants-et-solutions)

### **Q: Comment économiser sur les coûts de LoadBalancer ?**
**A:** Utilisez Ingress au lieu de multiples LoadBalancers. Voir [Module 5](05-ingress-solution-moderne.md)

### **Q: Kind ne fonctionne pas avec NodePort**
**A:** Il faut configurer `extraPortMappings`. Voir [Module 3](03-nodeport-service.md#-configuration-spéciale-pour-kind)

## 🎉 Certification de Fin de Cours

### ✅ Checklist de Maîtrise

- [ ] Je comprends les 4 types de services et leurs usages
- [ ] Je peux configurer ClusterIP pour la communication interne
- [ ] Je maîtrise NodePort pour le développement local
- [ ] Je peux déployer LoadBalancer en production cloud
- [ ] Je sais implémenter Ingress avec SSL automatique
- [ ] Je connais les bonnes pratiques de sécurité
- [ ] Je peux diagnostiquer et déboguer les problèmes de services
- [ ] J'ai pratiqué sur différents environnements (Kind, Cloud)

### 🏆 Projet Final
**Déployez une application complète avec :**
- Frontend (React/Vue/Angular)
- API Backend (Node.js/Python/Go)
- Base de données (PostgreSQL/MongoDB)
- Monitoring (Prometheus/Grafana)
- SSL automatique avec Let's Encrypt

---

## 🤝 Contribuer

Ce cours est en amélioration continue ! N'hésitez pas à :
- Signaler des erreurs
- Proposer des améliorations
- Ajouter des exemples pratiques
- Partager vos retours d'expérience

**Bon apprentissage ! 🚀**