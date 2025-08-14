## Examen Final — Session 2025



# Partie A — QCM (25 points)
Pour chaque question, cochez une seule réponse. 2 points par bonne réponse.

1. Terraform est principalement un outil de:
   - A. Gestion de configuration serveur
   - B. Orchestration de conteneurs
   - C. Infrastructure as Code
   - D. Monitoring

2. Le fichier qui définit la version des providers et de Terraform est:
   - A. `versions.tf`
   - B. `backend.tf`
   - C. `providers.tf`
   - D. `variables.tf`

3. La commande qui crée/actualise l'infrastructure est:
   - A. `terraform init`
   - B. `terraform plan`
   - C. `terraform apply`
   - D. `terraform refresh`

4. Le state Terraform doit idéalement être stocké:
   - A. Sur la machine de chaque développeur
   - B. Dans un backend distant verrouillable
   - C. Dans un fichier `state.json` versionné Git
   - D. Dans un secret manager

5. `for_each` est mieux adapté que `count` lorsque:
   - A. On veut créer zéro ou une ressource
   - B. On veut indexer par une clef stable (map, set de strings)
   - C. On n'a pas besoin de faire référence aux instances
   - D. On veut des index numériques seulement

6. `depends_on` est nécessaire lorsque:
   - A. Les dépendances ne sont pas détectées automatiquement par les références
   - B. Toujours, par bonne pratique
   - C. Jamais
   - D. Un provider échoue à s'initialiser

7. Un bloc `data` sert à:
   - A. Définir des ressources gérées
   - B. Importer des ressources non gérées
   - C. Lire des informations existantes côté provider
   - D. Définir des variables locales

8. Les workspaces Terraform servent principalement à:
   - A. Séparer physiquement les comptes cloud
   - B. Gérer des environnements (états) multiples au sein d'un même code
   - C. Gérer des modules
   - D. Mettre à jour des providers

9. Lors d'un `terraform import`:
   - A. Terraform crée la ressource dans le cloud
   - B. Terraform lit une ressource existante et la mappe au state
   - C. Terraform détruit la ressource
   - D. Terraform met à jour le provider

10. `lifecycle { prevent_destroy = true }` permet:
   - A. D'empêcher la création d'une ressource
   - B. D'empêcher toute modification
   - C. D'empêcher sa destruction accidentelle
   - D. D'activer la recréation forcée






11. Le type de Service par défaut si `type` n'est pas défini est:
   - A. NodePort
   - B. LoadBalancer
   - C. ClusterIP
   - D. ExternalName

12. Un Service `ClusterIP` est accessible:
   - A. Depuis l'extérieur du cluster via IP publique
   - B. Seulement depuis l'intérieur du cluster
   - C. Seulement depuis les nœuds master
   - D. Via Ingress uniquement

13. Un Service `NodePort` expose un port:
   - A. Sur un seul nœud
   - B. Sur tous les nœuds du cluster
   - C. Uniquement sur le pod leader
   - D. Sur le control plane

14. Le range par défaut de `nodePort` (kube-proxy standard) est:
   - A. 1–1024
   - B. 1024–2048
   - C. 30000–32767
   - D. 49152–65535

15. Un Service `LoadBalancer` nécessite généralement:
   - A. Un Ingress Controller
   - B. Un fournisseur cloud qui provisionne un équilibreur
   - C. etcd dédié
   - D. Un Pod privileged

16. Un Service `ExternalName`:
   - A. Crée un load balancer externe
   - B. Utilise des Endpoints pour router le trafic
   - C. Résout un nom CNAME vers une cible externe
   - D. Nécessite un Ingress


17. Dans un Service, `targetPort` correspond:
   - A. Au port écouté par le Pod/Container
   - B. Au port ouvert sur le nœud
   - C. Au port de l'Ingress
   - D. Au port du LoadBalancer externe




18. Un Deployment gère:
   - A. Des Pods directement
   - B. Des ReplicaSets qui gèrent des Pods
   - C. Des StatefulSets
   - D. Des Jobs

19. La stratégie de déploiement par défaut d'un Deployment est:
   - A. Recreate
   - B. Blue/Green
   - C. Canary
   - D. RollingUpdate



20. Un Pod peut contenir:
   - A. Un seul container seulement
   - B. Plusieurs containers sidecar
   - C. Un container et zéro initContainer
   - D. Un seul volume maximum


21. Un Service sélectionne les Pods via:
   - A. Labels/selector
   - B. Annotations
   - C. Noms de Pods
   - D. Nom de ReplicaSet

22. `targetPort` peut être:
   - A. Un entier seulement
   - B. Un nom de port défini dans le container
   - C. Une plage de ports
   - D. Un tableau de ports

23. Un Service `LoadBalancer` crée aussi:
   - A. Un Ingress
   - B. Un ClusterIP et un NodePort sous-jacent
   - C. Un EndpointSlice externe
   - D. Un Pod proxy



24. Un Service de type `ClusterIP` peut être exposé à l'extérieur via:
   - A. Ingress/IngressController
   - B. EndpointSlice externe
   - C. NodePort automatique
   - D. ExternalName automatique



25. `kubectl set image deployment/web app=myimg:v2`:
   - A. Met à jour l'image et déclenche un rollout
   - B. N'a d'effet que si replicas=1
   - C. Crée un nouveau Service
   - D. Modifie le namespace













## Partie B — Questions de développement (20 points)


**Texte à lire avant de répondre**

Lorsqu’une équipe de développement met en production une nouvelle version d’une application ou d’un service, elle doit choisir une **stratégie de déploiement** adaptée à ses objectifs : disponibilité, rapidité, coût et gestion des risques.
L’approche la plus simple, souvent utilisée pour des applications internes ou peu critiques, est la stratégie **Recreate**. Dans ce cas, on arrête complètement la version en cours (version N), puis on déploie la nouvelle version (N+1). Cette méthode est facile à mettre en œuvre, mais entraîne inévitablement une coupure de service pendant la transition. Elle est donc rarement utilisée pour des services publics ou critiques.

Pour éviter une interruption, certaines équipes optent pour **Blue/Green**. Ici, deux environnements identiques coexistent : l’un sert le trafic (Blue) tandis que l’autre héberge la nouvelle version (Green). Une fois les tests terminés sur l’environnement Green, le trafic est basculé instantanément. Cette méthode offre un rollback rapide, mais nécessite souvent le double d’infrastructure et une bonne gestion des données partagées.

Une autre méthode très populaire est le **déploiement Canary**. Inspirée des “canaris” des mines de charbon (utilisés comme système d’alerte), elle consiste à exposer la nouvelle version à un petit pourcentage d’utilisateurs ou de serveurs, puis à augmenter progressivement cette proportion si tout fonctionne correctement. Cela permet de limiter les risques en détectant les problèmes tôt, mais nécessite un système de suivi et de monitoring robuste.

Enfin, la stratégie **RollingUpdate** remplace progressivement les anciennes instances par de nouvelles, par lots successifs, tout en maintenant le service en ligne. Cette méthode est largement utilisée dans Kubernetes ou les systèmes d’orchestration de conteneurs, car elle garantit une disponibilité élevée et s’automatise facilement. Elle présente toutefois un inconvénient : pendant la mise à jour, certaines instances peuvent servir l’ancienne version et d’autres la nouvelle, ce qui peut poser des problèmes si les deux ne sont pas parfaitement compatibles.

Ces quatre stratégies ne sont pas exclusives ; certaines organisations les combinent ou adaptent leur approche selon la nature du déploiement, les contraintes techniques et les attentes des utilisateurs. Le choix dépendra toujours d’un compromis entre simplicité, coût, rapidité et tolérance au risque.




## Questions

1. **Expliquez, avec vos propres mots, les différences essentielles entre les stratégies Recreate, Blue/Green, Canary et RollingUpdate.** Donnez pour chacune un exemple concret d’utilisation dans un contexte réel.

2. **Analysez les avantages et inconvénients de chaque stratégie** en tenant compte de la disponibilité du service, des coûts d’infrastructure et du risque d’erreurs lors du déploiement.



# Partie C — Questions de code et compréhension (55 points)


