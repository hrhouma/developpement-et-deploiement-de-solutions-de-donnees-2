# Certification Readiness : Services Kubernetes

## Guide de Préparation aux Certifications

Ce document évalue votre préparation aux certifications Kubernetes officielles en fonction de votre maîtrise des services et de leur déploiement.

---

## Auto-Évaluation Rapide

### Checklist de Maîtrise

Cochez ce que vous maîtrisez :

#### ClusterIP – Niveau Requis : CKAD, CKA

* [ ] Je comprends que ClusterIP est le type par défaut
* [ ] Je peux configurer la communication inter-services
* [ ] Je maîtrise le DNS interne (`service.namespace.svc.cluster.local`)
* [ ] Je sais déboguer les problèmes d'endpoints
* [ ] Je peux créer des services headless (ClusterIP: None)

#### NodePort – Niveau Requis : CKAD, CKA

* [ ] Je comprends la plage de ports 30000-32767
* [ ] Je peux configurer Kind avec extraPortMappings
* [ ] Je sais quand utiliser NodePort (développement uniquement)
* [ ] Je comprends les limitations de sécurité
* [ ] Je peux déboguer les problèmes de connectivité externe

#### LoadBalancer – Niveau Requis : CKA

* [ ] Je comprends le rôle des cloud providers
* [ ] Je connais les annotations spécifiques aux clouds (AWS, Azure, GCP)
* [ ] Je sais configurer `loadBalancerSourceRanges`
* [ ] Je comprends pourquoi un LoadBalancer reste en `<pending>` sur Kind/Minikube
* [ ] Je peux estimer les coûts (\~18 \$/mois par LoadBalancer)

#### Ingress – Niveau Requis : CKAD, CKA

* [ ] Je comprends qu’Ingress n’est pas un Service
* [ ] Je peux installer un Ingress Controller (ex : NGINX)
* [ ] Je maîtrise le routage HTTP par domaine et par chemin
* [ ] Je sais configurer SSL automatique avec cert-manager
* [ ] Je comprends les économies vs plusieurs LoadBalancers
* [ ] Je peux configurer un déploiement canary

#### Sécurité – Niveau Requis : CKS

* [ ] Je peux configurer des NetworkPolicies
* [ ] Je maîtrise les restrictions d’IP avec Ingress
* [ ] Je comprends `externalTrafficPolicy: Local`
* [ ] Je sais sécuriser la communication entre services
* [ ] Je peux configurer mTLS avec un service mesh

#### Debug et Troubleshooting – Niveau Requis : CKA

* [ ] Utilisation de `kubectl get svc`, `describe svc`, `get endpoints`
* [ ] Utilisation de `kubectl exec` pour tester dans le cluster
* [ ] Lecture des logs d’un Ingress Controller
* [ ] Diagnostic des certificats SSL
* [ ] Vérification de la sélection de pods

---

## Préparation par Certification

### CKAD – Application Developer

**Focus :** Développement d'applications

#### Services à maîtriser

1. ClusterIP : communication entre microservices
2. NodePort : test local
3. Ingress : exposition HTTP/HTTPS

#### Compétences clés

```bash
kubectl expose deployment webapp --port=80 --target-port=8080
kubectl expose deployment webapp --type=NodePort --port=80
kubectl create ingress webapp --rule="app.example.com/*=webapp:80"
```

#### Scénarios typiques

* Créer plusieurs services pour une application
* Configurer Ingress avec certificat SSL
* Diagnostiquer les problèmes de communication entre pods

**Score recommandé au quiz : 35+ / 50**

---

### CKA – Kubernetes Administrator

**Focus :** Administration, réseau, configuration

#### Services à maîtriser

1. Tous les types de services (ClusterIP, NodePort, LoadBalancer, Ingress)
2. NetworkPolicies
3. Debug approfondi

#### Compétences clés

```bash
kubectl get svc --all-namespaces
kubectl get endpoints
kubectl describe svc my-service

kubectl run test --image=busybox --rm -it --restart=Never -- \
  nslookup my-service.my-namespace.svc.cluster.local

kubectl apply -f networkpolicy.yaml
kubectl describe networkpolicy
```

**Score recommandé au quiz : 40+ / 50**

---

### CKS – Security Specialist

**Focus :** Sécurité, audit, durcissement

#### Services à maîtriser

1. NetworkPolicies restrictives
2. Service Mesh (ex : Istio)
3. mTLS
4. Ingress avec authentification et WAF

#### Compétences clés

```yaml
# Exemple de NetworkPolicy
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: deny-all
spec:
  podSelector: {}
  policyTypes:
    - Ingress
    - Egress
```

```yaml
# Exemple d’annotations NGINX pour authentification
nginx.ingress.kubernetes.io/auth-type: basic
nginx.ingress.kubernetes.io/auth-secret: basic-auth
```

**Score recommandé au quiz : 45+ / 50**

---

## Plan de Révision

### Pour CKAD (2 à 3 semaines)

* Semaine 1 : ClusterIP, NodePort, commandes de base
* Semaine 2 : Ingress, services multiples
* Semaine 3 : examens blancs, quiz > 35/50

### Pour CKA (3 à 4 semaines)

* Semaines 1-2 : modules de base + quiz
* Semaine 3 : LoadBalancer, Debug réseau, NetworkPolicies
* Semaine 4 : pratiques en conditions réelles

### Pour CKS (4 à 6 semaines)

* Semaine 1-3 : revoir le contenu CKA
* Semaine 4-5 : pratique avancée sécurité
* Semaine 6 : examens blancs et études de cas

---

## Laboratoires Pratiques

### Lab 1 – Service Discovery

```bash
kubectl create deployment frontend --image=nginx
kubectl create deployment backend --image=httpd
kubectl create deployment database --image=postgres

kubectl expose deployment frontend --type=NodePort --port=80
kubectl expose deployment backend --port=8080
kubectl expose deployment database --port=5432
```

### Lab 2 – Ingress avec SSL

```bash
kubectl apply -f cert-manager.yaml
kubectl apply -f cluster-issuer.yaml
kubectl apply -f ingress-ssl.yaml
kubectl describe certificate
```

### Lab 3 – NetworkPolicies

```bash
kubectl apply -f default-deny.yaml
kubectl apply -f frontend-to-backend.yaml
kubectl apply -f backend-to-database.yaml
```

---

## Simulation d'Examen

### Mini-Examen CKAD (30 min)

* Créer des déploiements
* Exposer avec services
* Configurer un Ingress
* Tester la connectivité

### Mini-Examen CKA (45 min)

* Diagnostiquer un service cassé
* Migrer vers LoadBalancer
* Configurer NetworkPolicies

### Mini-Examen CKS (60 min)

* Implémenter Zero Trust
* Ingress sécurisé
* Monitoring et audit

---

## Ressources Finales

* [Documentation Kubernetes Services](https://kubernetes.io/docs/concepts/services-networking/service/)
* [Ingress](https://kubernetes.io/docs/concepts/services-networking/ingress/)
* [NetworkPolicies](https://kubernetes.io/docs/concepts/services-networking/network-policies/)

### Outils recommandés

```bash
# Kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind && sudo mv ./kind /usr/local/bin/kind

# Helm
curl https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz | tar xz
sudo mv linux-amd64/helm /usr/local/bin/

# NGINX Ingress
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm install ingress-nginx ingress-nginx/ingress-nginx
```

---

## Certification Finale

### Je certifie maîtriser :

* [ ] Tous les types de services Kubernetes
* [ ] Patterns de déploiement (Blue-Green, Canary)
* [ ] Optimisation des coûts
* [ ] Debug et troubleshooting
* [ ] Sécurité réseau

### Résultats à consigner

* Quiz final : \_\_\_ / 50
* Lab CKAD : ✅ / ❌
* Lab CKA : ✅ / ❌
* Lab CKS : ✅ / ❌

### Je suis prêt pour :

* [ ] CKAD (35+/50)
* [ ] CKA (40+/50)
* [ ] CKS (45+/50)

