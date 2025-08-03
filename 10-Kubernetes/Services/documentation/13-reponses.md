# Quiz Kubernetes – Services (50 Questions)

## RÉPONSES ET JUSTIFICATIONS DÉTAILLÉES

---

### SECTION 1 : Concepts de Base (Questions 1–10)

**1. B) NodePort avec extraPortMappings**
✅ Kind utilise Docker. Par défaut, les ports NodePort ne sont pas exposés à l'hôte. Pour accéder à l'application via `localhost:31200`, il faut configurer `extraPortMappings` dans la configuration Kind. ClusterIP est uniquement interne. LoadBalancer ne fonctionne pas sans cloud provider. Ingress nécessite une couche HTTP.

**2. C) ClusterIP**
✅ ClusterIP est conçu pour exposer les services uniquement à l’intérieur du cluster. Idéal pour une base de données accessible uniquement aux pods internes.

**3. C) 30000–32767**
✅ C’est la plage par défaut pour les ports NodePort dans Kubernetes. Elle est configurable mais reste par défaut cette plage dans toutes les distributions.

**4. C) ClusterIP**
✅ Kubernetes utilise `ClusterIP` comme valeur par défaut si le champ `type` n’est pas spécifié dans la définition du Service.

**5. C) 1 Ingress Controller + 5 services ClusterIP**
✅ Ingress permet de router plusieurs services HTTP avec un seul point d'entrée public, évitant le coût élevé de plusieurs LoadBalancers.

**6. B) service.beta.kubernetes.io/aws-load-balancer-ssl-cert**
✅ Annotation AWS pour attacher un certificat SSL ACM à un LoadBalancer Kubernetes. Les autres options concernent Ingress (NGINX) ou cert-manager.

**7. C) Il faut configurer extraPortMappings**
✅ Kind tourne dans un conteneur Docker. NodePort ne sera pas accessible depuis l'hôte sans un mapping explicite du port vers la machine hôte.

**8. B) api-service.production.svc.cluster.local**
✅ Nom DNS complet dans Kubernetes : `<service>.<namespace>.svc.cluster.local`.

**9. B) Environnement sans support cloud (Kind/Minikube)**
✅ Le type `LoadBalancer` nécessite un cloud provider pour provisionner automatiquement une IP externe. En local, il reste en état `Pending`.

**10. B) L’Ingress gère le routage HTTP/HTTPS, le service la connectivité réseau**
✅ Le Service agit au niveau réseau (L4), l’Ingress agit au niveau applicatif (L7). L’un ne remplace pas l’autre, ils sont complémentaires.

---

### SECTION 2 : Mises en Situation (Questions 11–25)

**11. B) LoadBalancer simple**
✅ AWS EKS permet de créer un LoadBalancer avec peu d'efforts. Pour un seul service, c'est plus simple que de déployer un Ingress Controller.

**12. B) 1 Ingress avec 3 règles de routage par host**
✅ Un seul Ingress avec des règles pour chaque environnement réduit la maintenance et les coûts.

**13. B) Ingress avec annotation `canary-weight: "10"`**
✅ L’annotation `nginx.ingress.kubernetes.io/canary-weight` permet un déploiement progressif basé sur le pourcentage de trafic.

**14. A) NodePort avec ports séquentiels**
✅ Pratique en local avec Kind. Chaque développeur utilise un port différent grâce à extraPortMappings.

**15. B) 1 service avec changement de selector**
✅ Le service pointe soit vers les pods blue, soit vers green. Changement atomique de selector = aucun downtime.

**16. B) Commencer par la moins critique**
✅ Réduit les risques et permet de valider la stratégie de migration.

**17. B) Ingress avec annotation `nginx.ingress.kubernetes.io/proxy-read-timeout`**
✅ WebSocket nécessite des timeout plus longs. NGINX supporte cela via cette annotation.

**18. D) Toutes les réponses ci-dessus**
✅ On peut combiner : firewall côté LoadBalancer, restriction IP côté Ingress, et NetworkPolicy interne.

**19. B) ClusterIP**
✅ Accès interne seulement. Pas besoin d’un LoadBalancer ou NodePort pour une base Redis partagée dans le cluster.

**20. B) Configurer `proxy-body-size`**
✅ Ingress NGINX limite par défaut à 1MB. Cette annotation permet de le dépasser.

**21. A) Ingress avec header `X-Branch-Name`**
✅ Approche scalable pour tester plusieurs branches via un seul point d’entrée.

**22. B) Ingress comme abstraction cloud-agnostique**
✅ Permet de découpler des annotations spécifiques et facilite la transition inter-cloud.

**23. B) Ingress avec annotation de rate limit**
✅ Gère les limites de requêtes côté proxy, indépendamment de l’application.

**24. A) Ingress avec path `/legacy`**
✅ Permet de router une partie du trafic vers l’ancien backend, le reste vers le nouveau.

**25. B) MetalLB + LoadBalancer service**
✅ MetalLB émule un cloud provider dans les environnements bare-metal.

---

### SECTION 3 : Coûts et Économies (Questions 26–35)

**26. B) \$18/mois**
✅ Tarif approximatif constaté pour un LoadBalancer cloud sur AWS/Azure/GCP.

**27. C) \$126/mois (8×18 - 18)**
✅ 8 LoadBalancers = \$144 → 1 Ingress = \$18 → économie = \$126/mois.

**28. C) ClusterIP**
✅ ClusterIP n'utilise aucun composant externe ou ressource cloud payante.

**29. B et D) Bande passante et coût du LoadBalancer lui-même**
✅ Les deux sont facturés : coût fixe pour le LB et coût variable pour le trafic sortant.

**30. B) Commencer directement avec Ingress**
✅ Plus pérenne. Migration tardive = double travail et plus de complexité.

**31. B) Complexité de gestion et sécurité**
✅ NodePort expose tous les nœuds à Internet. Nécessite un bon firewalling.

**32. B) LoadBalancer plus cher**
✅ Chaque LB nécessite un certificat. Ingress peut mutualiser les certificats (wildcard, etc).

**33. D) ROI immédiat**
✅ Réduction directe des coûts en passant de plusieurs LB à 1 Ingress.

**34. A) LoadBalancer plus cher**
✅ Généralement, la bande passante via LoadBalancer est facturée au tarif public cloud, alors qu'Ingress peut être optimisé en interne.

**35. C) NodePort + IP publique**
✅ Rapide et sans provisionnement complexe. Moins coûteux qu’un LoadBalancer.

---

### SECTION 4 : Debug & Config (Questions 36–45)

**36. B) `kubectl get endpoints`**
✅ Vérifie si le service cible bien des pods. Si vide → mauvais selector.

**37. A)**

```yaml
extraPortMappings:
  - containerPort: 31200
    hostPort: 31200
```

✅ Syntaxe attendue pour exposer un port NodePort Kind localement.

**38. A) Pods → Service → Ingress → DNS**
✅ On commence toujours du plus bas niveau vers le haut dans la pile.

**39. D) Toutes les réponses**
✅ Les trois causes sont possibles : firewall, port, health check.

**40. A) `kubectl exec -it pod -- curl ...`**
✅ Exécute une commande directement dans un pod pour tester la connectivité.

**41. D) Toutes les réponses**
✅ Chacune donne une partie de l’état du certificat.

**42. B) Session affinity activée**
✅ Cela force les requêtes à aller toujours vers le même pod.

**43. D) Toutes les réponses**
✅ NodePort implique une vérification de l’IP du nœud, du firewall, et de la config service.

**44. D) Toutes les réponses**
✅ Le certificat ne sera pas généré si l’un des éléments requis manque.

**45. B) Utiliser le FQDN**
✅ Entre namespaces, les services doivent être appelés avec leur nom complet.

---

### SECTION 5 : Concepts Avancés (Questions 46–50)

**46. D) Toutes les réponses**
✅ Le Service Mesh complète ou remplace certains usages de l’Ingress, avec plus de fonctionnalités.

**47. D) Toutes les réponses**
✅ Chaque méthode est une stratégie valide selon le niveau de contrôle et les objectifs.

**48. D) Toutes les réponses**
✅ Le Headless service permet une résolution DNS directe sans équilibrage de charge.

**49. D) Toutes les réponses**
✅ externalTrafficPolicy: Local garde l’IP du client mais ne répartit pas la charge entre nœuds.

**50. A) Gateway API**
✅ Gateway API est la prochaine évolution standardisée d’Ingress dans Kubernetes.

