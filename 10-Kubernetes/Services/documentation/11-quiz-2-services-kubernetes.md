# Quiz - Services Kubernetes (50 Questions)

## Instructions

Ce quiz comprend 50 questions à choix multiples (A, B, C, D) sur des mises en situation pratiques liées aux services Kubernetes.

## Temps recommandé

* Débutant : 60 minutes
* Intermédiaire : 45 minutes
* Expert : 30 minutes

## Barème de notation

* 45-50 points : Expert Kubernetes
* 35-44 points : Avancé
* 25-34 points : Intermédiaire
* 15-24 points : Débutant
* < 15 points : Révision nécessaire

---

## SECTION 1 : Concepts de base (Questions 1-10)

**1.** Vous développez une application locale avec Kind. Vous accédez à `http://localhost:31200`. Quel service utilisez-vous ?

* A) ClusterIP
* B) NodePort avec extraPortMappings
* C) LoadBalancer
* D) Ingress

**2.** Une base de données PostgreSQL uniquement interne au cluster. Quel service choisir ?

* A) NodePort
* B) LoadBalancer
* C) ClusterIP
* D) ExternalName

**3.** Quelle est la plage par défaut des ports NodePort ?

* A) 1-1024
* B) 8000-9000
* C) 30000-32767
* D) 40000-50000

**4.** Type de service par défaut ?

* A) NodePort
* B) LoadBalancer
* C) ClusterIP
* D) Ingress

**5.** La méthode la plus économique pour exposer 5 microservices ?

* A) 5 LoadBalancers
* B) 5 NodePorts
* C) 1 Ingress + 5 ClusterIPs
* D) 5 ExternalNames

**6.** Annotation AWS pour SSL LoadBalancer ?

* A) kubernetes.io/ingress.class
* B) service.beta.kubernetes.io/aws-load-balancer-ssl-cert
* C) nginx.ingress.kubernetes.io/ssl-redirect
* D) cert-manager.io/cluster-issuer

**7.** NodePort inaccessible par défaut dans Kind car :

* A) Kind ne supporte pas NodePort
* B) Ports bloqués par Docker
* C) Nécessite extraPortMappings
* D) Seulement en production

**8.** DNS interne d'un service nommé `api-service` dans namespace `production` ?

* A) api-service.svc.cluster.local
* B) api-service.production.svc.cluster.local
* C) production.api-service.cluster.local
* D) api-service.cluster.local

**9.** LoadBalancer reste en état pending. Cause probable ?

* A) Peu de pods
* B) Environnement sans support cloud
* C) Port incorrect
* D) Mauvais labels

**10.** Différence principale entre service et Ingress ?

* A) Service gère SSL
* B) Ingress routage HTTP/HTTPS, service réseau
* C) Pas de différence
* D) Ingress plus ancien

---

## SECTION 2 : Mises en situation (Questions 11-25)

**11.** Application web unique sur AWS EKS, budget limité. Recommandation ?

* A) NodePort
* B) LoadBalancer
* C) Ingress
* D) ClusterIP

**12.** 3 environnements (`dev`, `staging`, `prod`) : Approche Ingress ?

* A) 3 Ingress
* B) 1 Ingress, règles par host
* C) 3 LoadBalancers
* D) NodePort avec DNS

**13.** Déploiement canary 10% :

* A) 2 LoadBalancers DNS pondéré
* B) Ingress avec annotation canary-weight
* C) NodePort externe
* D) Modifier réplicas

**14.** 5 développeurs avec environnements Kind locaux :

* A) NodePort séquentiels
* B) LoadBalancer IP
* C) Ingress sous-domaines
* D) ClusterIP port-forward

**15.** Déploiement Blue-Green haute disponibilité :

* A) 2 LoadBalancers DNS switch
* B) 1 service changement selector
* C) 2 Ingress
* D) NodePort externe

---

## SECTION 3 : Coûts et économies (Questions 26-35)

**26.** Coût mensuel LoadBalancer cloud ?

* A) \$5
* B) \$18
* C) \$50
* D) \$100

**27.** Économie mensuelle de 8 services LoadBalancer vers 1 Ingress ?

* A) \$0
* B) \$36
* C) \$126
* D) \$144

**28.** Service gratuit en cloud ?

* A) LoadBalancer
* B) Ingress Controller
* C) ClusterIP
* D) NodePort avec Kind

---

## SECTION 4 : Configuration et débogage (Questions 36-45)

**36.** Service sans endpoints, vérifier d'abord :

* A) kubectl get svc
* B) kubectl get endpoints
* C) kubectl describe pods
* D) kubectl get ingress

**37.** Config Kind pour NodePort localhost:31200 ?

* A) extraPortMappings containerPort/hostPort
* B) portMappings nodePort/hostPort
* C) extraPorts port/targetPort
* D) hostNetwork: true

**38.** Erreur 503 sur Ingress, ordre de debug ?

* A) Pods → Service → Ingress → DNS
* B) DNS → Ingress → Service → Pods
* C) Service → Pods → Ingress → DNS
* D) Ingress → DNS → Service → Pods

---

## SECTION 5 : Concepts avancés (Questions 46-50)

**46.** Ingress vs Service Mesh :

* A) Ingress HTTP uniquement
* B) Service Mesh fonctionnalités avancées
* C) Ingress plus simple
* D) Toutes les réponses

**47.** Déploiement sans interruption avec services ?

* A) Blue-green selector
* B) Rolling update
* C) Canary avec Ingress
* D) Toutes les réponses

**48.** Usage d'un service Headless ?

* A) Service discovery
* B) StatefulSets
* C) Pas de load balancing
* D) Toutes les réponses



### Fin du quiz
