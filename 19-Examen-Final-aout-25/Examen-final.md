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


*VOUS AVEZ LE CHOIX ENTRE OPTION C1 ou OPTION C2 ou OPTION C3 ou OPTION C4*


# OPTION C1

# Références: 

- https://github.com/hrhouma/developpement-et-deploiement-de-solutions-de-donnees-2/blob/main/11-Terraform-pratiques/12-travail-pratique-02.md
- https://github.com/hrhouma/terraform-1.git


1. Dessinez le **workflow général** de l’infrastructure Terraform fournie (`TERRAFORM-1`).
2. Indiquez **qui appelle quoi**, **dans quel ordre**, et quelles **ressources AWS** sont concernées.
3. Le schéma doit inclure les **fichiers du projet** visibles dans l’arborescence (`main.tf`, `autoscaling.tf`, `snapshot.tf`, `s3.tf`, etc.) et **les interactions entre eux**.
4. Y a-t-il un fichier principal ?
5. Comment les appels entre les fichiers sont-ils gérés ?
6. À quoi faut-il faire attention pour que les ressources soient créées dans le bon ordre ?

7. Prenez **deux fichiers de votre choix** parmi :
`main.tf`, `autoscaling.tf`, `snapshot.tf`, `rds.tf`, `s3.tf`

Expliquez **comment ils interagissent** entre eux ou avec d'autres parties du projet.

* Existe-t-il des références croisées ?
* Ces fichiers dépendent-ils des mêmes ressources ou variables ?
* Comment Terraform sait-il quoi faire en premier ?


8. Selon vous, que pourrait-on **améliorer** dans la structure actuelle du projet Terraform-1 ?

* Fichiers de variables ?
* Modularité ?
* Réduction de duplication ?
* Sécurité des identifiants ?

Citez **au moins 3 améliorations concrètes**, avec une courte justification.


9. Fonction Lambda et automatisation

Expliquez le rôle de la fonction `lambda_function.py` dans ce projet :

* À quoi sert-elle ?
* Comment est-elle configurée pour être appelée automatiquement ?
* Quelle ressource AWS déclenche son exécution ?
* Que faudrait-il vérifier pour que tout fonctionne ?




# OPTION C2

- La startup « CaféDev » lance une API `catalog` consommée par des clients web externes. L'équipe veut « aller vite » et publie un premier brouillon de manifestes. Le tech lead affirme:
- Votre mission: auditer, repérer les faussetés/pièges, corriger, proposer des améliorations.



### Livrables attendus
- Un fichier  listant: erreurs, impacts, corrections proposées (avec justification en 1–3 lignes chacune).
- Des manifestes corrigés (`deployment.yaml`, `service.yaml`, optionnel `ingress.yaml`).
- Commandes utiles (`kubectl get/describe`, `kubectl logs`, `curl` interne/externe si applicable).



### Manifeste initial (avec pièges)

```yaml
# deployment.yaml (brouillon fourni par l'équipe)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalog-deploy
  labels:
    app: website
spec:
  replicas: 1
  selector:
    matchLabels:
      app: catalog
  template:
    metadata:
      labels:
        app: catalog-api
    spec:
      containers:
        - name: catalog
          image: nginx:1.25 # placeholder
          ports:
            - name: http
              containerPort: 8080
          readinessProbe:
            httpGet:
              path: /healthz
              port: 9090     # piège: ne correspond pas au port exposé
            initialDelaySeconds: 1
            periodSeconds: 2
          livenessProbe:
            tcpSocket:
              port: http     # nommé mais cible un port inexistant
            initialDelaySeconds: 5
            periodSeconds: 5
          resources:
            limits:
              cpu: "200m"
              memory: "128Mi"
            # requests manquants
          env:
            - name: ENV
              value: prod
```

```yaml
# service.yaml (brouillon fourni par l'équipe)
apiVersion: v1
kind: Service
metadata:
  name: catalog
spec:
  type: ClusterIP  
  selector:
    app: catalog  
  ports:
    - name: web
      port: 80
      targetPort: 80  
      nodePort: 30080 
```

```yaml
# ingress.yaml (optionnel mais souvent demandé)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: catalog
spec:
  ingressClassName: nginx
  rules:
    - host: catalog.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: catalog
                port:
                  number: 80
```


### Tâches
1) Analysez l'énoncé et les manifestes. Relevez au moins 10 incohérences/erreurs/pièges. Pour chacune:
   - Dites si c'est correct, améliorable ou faux
   - Expliquez l'impact (fonctionnel/sécurité/fiabilité)
   - Proposez une correction

2) Corrigez les manifestes pour rendre l'API accessible à des clients externes selon deux approches alternatives:
   - A. Sans Ingress: Service de type `NodePort` (cluster on-prem) OU `LoadBalancer` (si cloud supporté)
   - B. Avec Ingress: Service `ClusterIP` derrière un Ingress Controller



# OPTION C3


La startup « CaféDev » expose plusieurs composants de l’API `catalog` et veut ouvrir l’accès aux clients externes et internes. Un brouillon de manifests a été partagé “pour gagner du temps”. Votre mission: auditer spécifiquement la **couche Services** (types, sélecteurs, ports, exposition), repérer les faussetés/pièges, corriger, et proposer des améliorations.

### Livrables attendus

* Un fichier listant: erreurs liées aux **Services**, impact, correction proposée (justification 1–3 lignes).
* Manifests corrigés: `deployment.yaml`, `service.yaml` (et `ingress.yaml` si vous le jugez nécessaire).
* Commandes de vérification (focus Services): `kubectl get/describe svc,endpoints`, `kubectl get pods -o wide`, `kubectl port-forward`, tests réseau internes/externe si applicable.

---

## Manifeste initial (avec pièges)

> Placez tout dans `bundle.yaml` et appliquez tel quel avant d’auditer.

```yaml
# Namespace
apiVersion: v1
kind: Namespace
metadata:
  name: cafedev

---
# Deployment principal (catalog-api)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalog-api
  namespace: cafedev
  labels:
    app: catalog-api
spec:
  replicas: 2
  selector:
    matchLabels:
      app: catalog-api
  template:
    metadata:
      labels:
        app: catalog-api
    spec:
      containers:
        - name: api
          image: nginx:1.25
          ports:
            - name: web
              containerPort: 8080
            - name: metrics
              containerPort: 9100

---
# Deployment secondaire (catalog-admin)
apiVersion: apps/v1
kind: Deployment
metadata:
  name: catalog-admin
  namespace: cafedev
  labels:
    app: catalog-admin
spec:
  replicas: 1
  selector:
    matchLabels:
      app: catalog-admin
  template:
    metadata:
      labels:
        app: catalog-admin
    spec:
      containers:
        - name: admin
          image: nginx:1.25
          ports:
            - name: http
              containerPort: 8081

---
# 1) Service interne pour catalog-api (ClusterIP attendu)
apiVersion: v1
kind: Service
metadata:
  name: catalog-api
  namespace: cafedev
spec:
  type: ClusterIP
  selector:
    app: catalog     
  ports:
    - name: http
      port: 80
      targetPort: http  
    - name: metrics
      port: 9100
      targetPort: 9200   

---
# 2) Service externe direct (NodePort)
apiVersion: v1
kind: Service
metadata:
  name: catalog-api-nodeport
  namespace: cafedev
spec:
  type: NodePort
  selector:
    app: catalog-api
  externalTrafficPolicy: Local  
  ports:
    - name: web
      port: 80
      targetPort: 8080
      nodePort: 80              
    - name: web-dup
      port: 80                  
      targetPort: web          

---
# 3) Service LoadBalancer “rapide” (cloud?)
apiVersion: v1
kind: Service
metadata:
  name: catalog-api-lb
  namespace: cafedev
spec:
  type: LoadBalancer
  selector:
    app: catalog-api
  sessionAffinity: ClientIP
  sessionAffinityConfig:
    clientIP:
      timeoutSeconds: 999999   # à valider selon la norme
  ports:
    - name: http
      port: 80
      targetPort: 8080
    - name: udp-alt
      port: 9999
      protocol: UDP           

---
# 4) Service Headless utilisé “pour le fun”
apiVersion: v1
kind: Service
metadata:
  name: catalog-headless
  namespace: cafedev
spec:
  clusterIP: None
  type: LoadBalancer         
  selector:
    app: catalog-api
  ports:
    - name: head
      port: 8080
      targetPort: web

---
# 5) Service ExternalName 
apiVersion: v1
kind: Service
metadata:
  name: external-db
  namespace: cafedev
spec:
  type: ExternalName
  externalName: db.external.example.com
  ports:                      
    - port: 5432

---
# 6) Service “vide” pour endpoints manuels 
apiVersion: v1
kind: Service
metadata:
  name: legacy-svc
  namespace: cafedev
spec:
  type: ClusterIP
  selector: {}               
  ports:
    - name: legacy
      port: 7777
      targetPort: 7777

---
# 7) Service admin : ports et noms incohérents
apiVersion: v1
kind: Service
metadata:
  name: catalog-admin
  namespace: cafedev
spec:
  type: ClusterIP
  selector:
    app: catalog-admin
  ports:
    - name: http              
      port: 80
      targetPort: 8082         
    - name: http                
      port: 8081
      targetPort: http

---
# 8) Ingress “bonus” (facultatif dans cet exercice)
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: catalog
  namespace: cafedev
spec:
  ingressClassName: nginx
  rules:
    - host: catalog.cafedev.local
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: catalog-api
                port:
                  number: 80
```



## Tâches

1. **Audit focalisé Services**
   Relevez **au moins 12** incohérences/erreurs/pièges spécifiquement liés aux **Services** (type, sélecteurs, ports, protocoles, stratégies d’externalisation, noms de ports, duplication, headless, ExternalName, endpoints, etc.).
   Pour chaque point:

   * Indiquez si c’est correct, améliorable ou faux.
   * Expliquez l’impact (résolution de service, endpoints non créés, trafic non routé, exposition incorrecte, pertes de sessions, incompatibilité protocolaire, etc.).
   * Proposez une correction concrète (1–3 lignes de justification).

2. **Rendre `catalog-api` accessible à des clients externes** selon **une** des deux voies (au choix) :

   * **Sans Ingress** : via `NodePort` (on-prem) ou `LoadBalancer` (si support cloud).
   * **Avec Ingress** : `Service` de type `ClusterIP` placé derrière l’Ingress Controller.
     Décrivez brièvement votre choix et ses implications côté Service.

3. **Vérifications ciblées Services**
   Dressez une courte liste de commandes et tests pour:

   * Vérifier la création des **Endpoints/EndpointSlices** et la correspondance selectors ↔ labels.
   * Vérifier la cohérence **port/targetPort** (noms et numéros).
   * Tester l’accessibilité depuis un Pod outillage (`kubectl exec -it … -- curl …`).
   * Tester l’accès externe si vous optez pour NodePort/LoadBalancer/Ingress.



## Indices

* Les **selectors** contrôlent la présence ou l’absence d’Endpoints.
* Un **ExternalName** n’expose pas de ports et ne crée pas d’Endpoints.
* Les **NodePorts** doivent respecter la plage autorisée et ne pas être dupliqués.
* Les **noms de ports** doivent être **uniques** par Service et cohérents avec les cibles nommées.
* **Headless** (`clusterIP: None`) et **LoadBalancer** poursuivent des objectifs différents.
* Vérifiez le **protocole** (TCP/UDP) et la réalité des ports écoutés côté Pods.
* `externalTrafficPolicy: Local` modifie la distribution du trafic et les IP sources visibles.

  ## Annexe:

- Un **Service headless** dans Kubernetes est un Service configuré avec `clusterIP: None`. Contrairement à un Service classique, il ne fournit pas d’adresse IP virtuelle unique : il renvoie directement la liste des adresses IP des Pods correspondants, ce qui permet aux clients de se connecter à eux individuellement (utile pour des bases de données distribuées ou des protocoles spécifiques comme gRPC point-à-point). En revanche, un Service de type **LoadBalancer** repose sur la création d’un point d’entrée unique, géré par le fournisseur cloud, qui répartit le trafic entre les Pods via l’IP virtuelle du Service. Associer `clusterIP: None` et `type: LoadBalancer` est donc contradictoire : le mode headless supprime la notion d’IP unique, tandis que le LoadBalancer exige cette IP pour fonctionner. En pratique, cette configuration empêchera la création correcte du load balancer et n’atteindra pas l’effet attendu.


# Option C4

**Consigne**
Vous devez proposer **une idée de pipeline CI/CD** pour un projet applicatif de votre choix (web, API, mobile, microservice…).

**Votre travail doit inclure :**

1. **Description du pipeline** – Présentez les étapes clés (CI et/ou CD) que vous mettriez en place.
2. **Fichier de configuration** – Fournissez un exemple de configuration (`.gitlab-ci.yml`, `.github/workflows/xxx.yml`, `Jenkinsfile`, etc.) correspondant à votre idée.
3. **Commandes et code** – Montrez les commandes principales utilisées (ex. `docker build`, `npm test`, `kubectl apply`).
4. **Documentation courte** – Expliquez le rôle de chaque étape.

**Liberté**

* Vous choisissez l’outil CI/CD.
* Vous choisissez le langage et le type d’application.
* Vous pouvez vous limiter à la CI, à la CD, ou couvrir les deux.

**Livrable attendu** : Un fichier texte, Markdown, word , ppt ou PDF regroupant la description, le code/configuration, et les explications.

