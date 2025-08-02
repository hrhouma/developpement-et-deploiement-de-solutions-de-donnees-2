
## Quiz : Quel service Kubernetes suis-je ?

**Instructions** : Lisez chaque description et devinez le type de service (ClusterIP, NodePort, LoadBalancer ou Ingress).

---

### Question 1 :

Je suis un service Kubernetes qui ne communique qu'entre applications internes, jamais avec l’extérieur.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 2 :

Je permets aux développeurs de tester facilement une application depuis leur ordinateur personnel via un port précis.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 3 :

Je suis souvent coûteux si chaque application utilise un service différent, car j'attribue une IP publique unique à chaque fois.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 4 :

Je suis un service économique qui regroupe plusieurs applications derrière une seule adresse IP publique.
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 5 :

Je ne suis accessible qu’à l’intérieur du cluster Kubernetes lui-même.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 6 :

Mon numéro de port est généralement compris entre 30000 et 32767.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 7 :

J’utilise des règles précises (domaines, chemins, headers) pour diriger le trafic vers la bonne application.
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 8 :

Je suis parfait pour exposer une application simple en production, mais moins pratique quand il y en a plusieurs.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 9 :

Je suis gratuit et idéal pour héberger une base de données interne.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 10 :

Je suis parfait pour une utilisation locale rapide avec Kind ou Minikube.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 11 :

J’offre des fonctionnalités avancées comme la répartition intelligente de trafic (ex. tests canary).
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 12 :

Si j’ai 5 applications différentes, je risque de coûter cher en frais mensuels.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 13 :

Je ne permets jamais aux utilisateurs externes d'accéder directement à mes applications.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 14 :

Je nécessite généralement une configuration `extraPortMappings` pour être utilisé localement avec Kind.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 15 :

J’ai besoin d’un contrôleur spécifique comme NGINX, Traefik ou Istio pour fonctionner correctement.
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 16 :

Je suis automatiquement intégré aux services de cloud comme AWS, Azure ou GCP pour obtenir une IP publique.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 17 :

Je ne coûte absolument rien et reste totalement invisible depuis Internet.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 18 :

Je suis le seul service qui permet à des utilisateurs externes d'accéder directement à une application par IP publique sans configuration complexe.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 19 :

Je suis souvent utilisé pour les environnements de tests et de développement rapide car je suis simple et gratuit.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 20 :

Je suis très économique pour gérer plusieurs applications en production avec une seule adresse publique.
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 21 :

Je n’ai pas de mécanisme direct pour recevoir du trafic externe depuis Internet.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 22 :

Je permets à l'utilisateur externe de se connecter directement via l’adresse IP et un numéro de port spécifique du nœud Kubernetes.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 23 :

Je suis généralement combiné avec des annotations spéciales pour configurer le service cloud associé.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 24 :

J’utilise une seule IP publique et je distribue le trafic selon des règles définies pour différents chemins d’accès.
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 25 :

Je suis idéal pour connecter une application à une autre en interne, comme un frontend vers un backend.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 26 :

Je suis le seul service capable d’exposer plusieurs services Kubernetes différents à l'extérieur avec une seule IP publique.
**Qui suis-je ?**

**Réponse :** Ingress

---

### Question 27 :

Mon coût augmente proportionnellement avec le nombre d'applications que j'expose publiquement.
**Qui suis-je ?**

**Réponse :** LoadBalancer

---

### Question 28 :

Je suis très utilisé en local par les développeurs car je permets un accès simple sans coûts supplémentaires.
**Qui suis-je ?**

**Réponse :** NodePort

---

### Question 29 :

Je ne permettrai jamais une connexion directe venant de l'extérieur, même en configurant des ports spéciaux.
**Qui suis-je ?**

**Réponse :** ClusterIP

---

### Question 30 :

Je suis souvent utilisé pour mettre en place des tests avancés comme les déploiements progressifs (« canary deployment ») en production.
**Qui suis-je ?**

**Réponse :** Ingress

---

**Corrigé : Tableau récapitulatif pour rappel**

| Type             | Quand l'utiliser simplement ?                                    |
| ---------------- | ---------------------------------------------------------------- |
| **ClusterIP**    | Communication interne uniquement.                                |
| **NodePort**     | Accès rapide pour tests ou développement.                        |
| **LoadBalancer** | Exposition simple d'applications en production.                  |
| **Ingress**      | Plusieurs applications en production avec un seul point d'accès. |

