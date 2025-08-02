# 🎓 Certification Readiness : Services Kubernetes

## 🎯 Guide de Préparation aux Certifications

Ce document évalue votre préparation aux certifications Kubernetes officielles basée sur votre maîtrise des services.

---

## 📊 Auto-Évaluation Rapide

### ✅ **Checklist de Maîtrise**

Cochez ce que vous maîtrisez :

#### 🔒 **ClusterIP - Niveau Requis : CKAD, CKA**
- [ ] Je comprends que ClusterIP est le type par défaut
- [ ] Je peux configurer la communication inter-services
- [ ] Je maîtrise le DNS interne (`service.namespace.svc.cluster.local`)
- [ ] Je sais déboguer les problèmes d'endpoints
- [ ] Je peux créer des services headless (ClusterIP: None)

#### 🚪 **NodePort - Niveau Requis : CKAD, CKA** 
- [ ] Je comprends la plage de ports 30000-32767
- [ ] Je peux configurer Kind avec extraPortMappings
- [ ] Je sais quand utiliser NodePort (développement uniquement)
- [ ] Je comprends les limitations de sécurité
- [ ] Je peux déboguer les problèmes de connectivité externe

#### ⚖️ **LoadBalancer - Niveau Requis : CKA**
- [ ] Je comprends le rôle des cloud providers
- [ ] Je connais les annotations cloud-spécifiques (AWS/Azure/GCP)
- [ ] Je sais configurer `loadBalancerSourceRanges`
- [ ] Je comprends pourquoi ça reste en `<pending>` sur Kind/Minikube
- [ ] Je peux estimer les coûts (~$18/mois par LB)

#### 🌐 **Ingress - Niveau Requis : CKAD, CKA**
- [ ] Je comprends qu'Ingress n'est PAS un service
- [ ] Je peux installer un Ingress Controller (NGINX)
- [ ] Je maîtrise le routage par domaine et par chemin
- [ ] Je sais configurer SSL automatique avec cert-manager
- [ ] Je comprends les économies vs multiples LoadBalancers
- [ ] Je peux configurer le canary deployment

#### 🛡️ **Sécurité - Niveau Requis : CKS**
- [ ] Je peux configurer des NetworkPolicies
- [ ] Je maîtrise les whitelist d'IPs avec Ingress
- [ ] Je comprends externalTrafficPolicy: Local
- [ ] Je sais sécuriser les communications inter-services
- [ ] Je peux configurer mTLS avec service mesh

#### 🔧 **Debug et Troubleshooting - Niveau Requis : CKA**
- [ ] `kubectl get svc` et `kubectl describe svc`
- [ ] `kubectl get endpoints` pour vérifier la sélection de pods
- [ ] `kubectl exec` pour tester depuis l'intérieur du cluster
- [ ] Lecture des logs d'Ingress Controller
- [ ] Debug des problèmes de certificats SSL

---

## 🎯 Préparation par Certification

### 🥉 **CKAD (Certified Kubernetes Application Developer)**

**Focus :** Développement d'applications

#### **Services Essentiels à Maîtriser :**
1. ✅ **ClusterIP** - Communication entre microservices
2. ✅ **NodePort** - Tests et développement  
3. ✅ **Ingress** - Exposition HTTP/HTTPS

#### **Compétences Clés :**
```bash
# Créer un service ClusterIP
kubectl expose deployment webapp --port=80 --target-port=8080

# Créer un service NodePort
kubectl expose deployment webapp --type=NodePort --port=80 --target-port=8080

# Créer un Ingress
kubectl create ingress webapp --rule="app.example.com/*=webapp:80"
```

#### **Scénarios d'Examen Typiques :**
- Exposer une application avec plusieurs services
- Configurer Ingress avec SSL
- Déboguer une communication inter-services

#### **Score Quiz Recommandé :** 35+ / 50

---

### 🥈 **CKA (Certified Kubernetes Administrator)**

**Focus :** Administration et infrastructure

#### **Services Essentiels à Maîtriser :**
1. ✅ **Tous les types** (ClusterIP, NodePort, LoadBalancer, Ingress)
2. ✅ **NetworkPolicies** pour la sécurité
3. ✅ **Debug avancé** et troubleshooting

#### **Compétences Clés :**
```bash
# Vérifier la santé des services
kubectl get svc --all-namespaces
kubectl get endpoints
kubectl describe svc <service-name>

# Debug réseau
kubectl run test --image=busybox --rm -it --restart=Never -- \
  nslookup <service-name>.<namespace>.svc.cluster.local

# NetworkPolicies
kubectl apply -f networkpolicy.yaml
kubectl describe networkpolicy
```

#### **Scénarios d'Examen Typiques :**
- Diagnostiquer pourquoi un service ne fonctionne pas
- Configurer LoadBalancer avec restrictions d'IP
- Migrer de NodePort vers Ingress
- Sécuriser la communication entre namespaces

#### **Score Quiz Recommandé :** 40+ / 50

---

### 🥇 **CKS (Certified Kubernetes Security Specialist)**

**Focus :** Sécurité avancée

#### **Services Essentiels à Maîtriser :**
1. ✅ **NetworkPolicies** restrictives
2. ✅ **Service Mesh** (Istio/Linkerd)
3. ✅ **mTLS** et chiffrement
4. ✅ **Ingress** avec WAF et authentification

#### **Compétences Clés :**
```bash
# NetworkPolicy restrictive
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
  - Ingress
  - Egress

# Ingress avec auth
annotations:
  nginx.ingress.kubernetes.io/auth-type: basic
  nginx.ingress.kubernetes.io/auth-secret: basic-auth
```

#### **Scénarios d'Examen Typiques :**
- Implémenter zero-trust networking
- Configurer mTLS entre services
- Sécuriser Ingress avec WAF
- Audit des communications réseau

#### **Score Quiz Recommandé :** 45+ / 50

---

## 📚 Plan de Révision par Certification

### 🎯 **Pour CKAD (2-3 semaines)**

#### **Semaine 1 : Fondamentaux**
- [ ] Module 1 : Introduction 
- [ ] Module 2 : ClusterIP
- [ ] Module 3 : NodePort
- [ ] Quiz questions 1-25

#### **Semaine 2 : Avancé**
- [ ] Module 5 : Ingress
- [ ] Module 7 : Visualisations
- [ ] Quiz questions 26-50
- [ ] Pratique hands-on

#### **Semaine 3 : Préparation**
- [ ] Mock exams CKAD
- [ ] Quiz final > 35/50
- [ ] Révision points faibles

### 🎯 **Pour CKA (3-4 semaines)**

#### **Semaine 1-2 : Base CKAD**
- [ ] Tous les modules 1-5
- [ ] Quiz > 35/50

#### **Semaine 3 : Administration**
- [ ] Module 4 : LoadBalancer (approfondi)
- [ ] Module 6 : Debug et troubleshooting
- [ ] NetworkPolicies
- [ ] Quiz > 40/50

#### **Semaine 4 : Préparation**
- [ ] Mock exams CKA
- [ ] Scenarios de production
- [ ] Quiz final > 40/50

### 🎯 **Pour CKS (4-6 semaines)**

#### **Semaine 1-3 : Base CKA**
- [ ] Certification CKA ou équivalent
- [ ] Quiz > 40/50

#### **Semaine 4-5 : Sécurité**
- [ ] Service Mesh (Istio)
- [ ] mTLS configuration
- [ ] NetworkPolicies avancées
- [ ] Ingress sécurisé

#### **Semaine 6 : Préparation**
- [ ] Mock exams CKS
- [ ] Security scenarios
- [ ] Quiz final > 45/50

---

## 🧪 Laboratoires Pratiques

### 🔬 **Lab 1 : Service Discovery (CKAD)**

**Objectif :** Créer une application multi-tiers avec services

```bash
# 1. Déployer frontend, backend, database
kubectl create deployment frontend --image=nginx
kubectl create deployment backend --image=httpd
kubectl create deployment database --image=postgres

# 2. Exposer avec services appropriés
kubectl expose deployment frontend --type=NodePort --port=80
kubectl expose deployment backend --port=8080
kubectl expose deployment database --port=5432

# 3. Tester la communication
kubectl run test --image=busybox --rm -it --restart=Never -- \
  wget -qO- http://backend:8080
```

### 🔬 **Lab 2 : Ingress avec SSL (CKA)**

**Objectif :** Configurer Ingress complet avec certificats

```bash
# 1. Installer cert-manager
kubectl apply -f cert-manager.yaml

# 2. Créer ClusterIssuer
kubectl apply -f cluster-issuer.yaml

# 3. Créer Ingress avec SSL
kubectl apply -f ingress-ssl.yaml

# 4. Vérifier certificat
kubectl describe certificate
kubectl describe ingress
```

### 🔬 **Lab 3 : NetworkPolicies (CKS)**

**Objectif :** Sécuriser la communication inter-services

```bash
# 1. Politique par défaut : deny all
kubectl apply -f default-deny.yaml

# 2. Permettre frontend → backend uniquement
kubectl apply -f frontend-to-backend.yaml

# 3. Permettre backend → database uniquement  
kubectl apply -f backend-to-database.yaml

# 4. Tester les communications
kubectl exec frontend -- curl backend:8080  # ✅ Autorisé
kubectl exec frontend -- curl database:5432 # ❌ Bloqué
```

---

## 📊 Simulation d'Examen

### ⏱️ **Mini-Examen CKAD (30 minutes)**

#### **Scénario :** Déployer une application e-commerce

1. **[5 min]** Créer 3 deployments : `frontend`, `api`, `database`
2. **[10 min]** Exposer avec services appropriés
3. **[10 min]** Configurer Ingress pour `shop.example.com`
4. **[5 min]** Tester la connectivité complète

#### **Critères de Réussite :**
- [ ] Frontend accessible via Ingress
- [ ] API accessible depuis frontend (service discovery)
- [ ] Database accessible uniquement depuis API
- [ ] SSL configuré (bonus)

### ⏱️ **Mini-Examen CKA (45 minutes)**

#### **Scénario :** Diagnostiquer et réparer un cluster

1. **[15 min]** Service `broken-app` inaccessible → diagnostiquer et réparer
2. **[15 min]** Migrer service NodePort vers LoadBalancer
3. **[15 min]** Configurer NetworkPolicy restrictive

#### **Critères de Réussite :**
- [ ] Application réparée et accessible
- [ ] LoadBalancer fonctionnel avec IP publique
- [ ] NetworkPolicy appliquée sans casser l'app

### ⏱️ **Mini-Examen CKS (60 minutes)**

#### **Scénario :** Sécuriser une application critique

1. **[20 min]** Implémenter zero-trust networking
2. **[20 min]** Configurer Ingress avec auth et WAF
3. **[20 min]** Audit et monitoring des communications

#### **Critères de Réussite :**
- [ ] Aucune communication non-autorisée possible
- [ ] Authentification requise pour accès externe
- [ ] Logs de sécurité fonctionnels

---

## 🎯 Ressources Finales

### 📚 **Documentation Officielle à Maîtriser**
- [Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
- [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
- [NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

### 🛠️ **Outils à Installer**
```bash
# Kind pour pratique locale
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind

# Helm pour Ingress Controller
curl https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz | tar xz
sudo mv linux-amd64/helm /usr/local/bin/

# NGINX Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
```

### 🎓 **Prochaines Étapes**
1. **Terminer le quiz** avec score > seuil pour votre certification
2. **Pratiquer les labs** jusqu'à les réussir en temps imparti
3. **S'inscrire** à l'examen officiel
4. **Continuer la pratique** avec scenarios réels

---

## 🏆 Certification de Fin de Cours

### ✅ **Je certifie maîtriser :**

- [ ] **Tous les types de services** Kubernetes
- [ ] **Les patterns de déploiement** (Blue-Green, Canary)
- [ ] **L'optimisation des coûts** cloud
- [ ] **Le debug et troubleshooting**
- [ ] **La sécurité réseau** avancée

### 📊 **Mes Résultats :**

- **Quiz final :** _____ / 50
- **Lab CKAD :** ✅ / ❌
- **Lab CKA :** ✅ / ❌  
- **Lab CKS :** ✅ / ❌

### 🎯 **Je suis prêt pour :**

- [ ] **CKAD** (>35/50 + labs)
- [ ] **CKA** (>40/50 + labs)
- [ ] **CKS** (>45/50 + labs)

---

**🎉 Félicitations ! Vous avez terminé le cours le plus complet sur les services Kubernetes !**

**🚀 Vous êtes maintenant prêt pour les certifications officielles et les déploiements en production !**