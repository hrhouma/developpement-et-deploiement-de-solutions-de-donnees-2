---
title: "Chapitre 13 - types de services par les images (théorie4)"
description: "Projet final qui combine tous les concepts appris pour déployer automatiquement une infrastructure web complète avec base de données"
emoji: "🔧"
---



# Chapitre 13 - types de services par les images



<a name="table-des-matières"></a>
## Table des matières




---
# 1 - Rappel de ce que c'est un Service Kubernete
---

- Dans cette partie, nous allons discuter des services Kubernetes.
> 1. Les services Kubernetes permettent la communication entre les différentes composantes de l'application, qu'elles soient internes ou externes.
> 2. Les services Kubernetes nous aident à connecter des applications entre elles ou avec des utilisateurs.
> 3. Par exemple, notre application pourrait avoir plusieurs groupes de composants exécutant différentes sections : un groupe pour servir une interface utilisateur, un autre groupe pour les processus backend, et un troisième groupe pour se connecter à une source de données externe.
> 4. Ce sont les services qui permettent la connectivité entre ces groupes de composants.
> 5. Les services rendent l'application frontale accessible aux utilisateurs finaux, facilitent la communication entre les composants backend et frontend, et permettent la connexion à une source de données externe.
> 6. Ainsi, les services permettent un couplage lâche entre les microservices de notre application.




<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service1.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

  <p style={{textAlign: "center"}}><em>Figure 1 : Les Services assurent la connexion entre les différents composants d'une application, notamment entre les utilisateurs et le frontend, entre le frontend et le backend, ainsi qu'entre le backend et la base de données</em></p>
</div>

Cette figure montre comment les services jouent un rôle central dans une architecture informatique. Les utilisateurs (en haut) accèdent aux fonctionnalités via des services qui agissent comme des "ponts" pour se connecter aux différentes ressources, comme des applications ou des bases de données.

> Chaque service est un **élément indépendant**, capable de fonctionner de manière autonome tout en échangeant des informations avec d'autres services si nécessaire. Cela signifie que chaque service peut regrouper et organiser des actions spécifiques, comme gérer des données ou exécuter des tâches précises, sans dépendre directement des autres. Cette indépendance permet de rendre le système plus structuré, évolutif et facile à gérer. Ainsi, même si un service tombe en panne ou est mis à jour, le reste de l'architecture continue de fonctionner normalement. Cela garantit une meilleure fiabilité et une réponse rapide aux besoins des utilisateurs.



> Les services constituent un élément fondamental et critique de toute architecture Kubernetes moderne. Ils agissent comme une couche d'abstraction essentielle qui :

- Fournit une interface stable et persistante pour accéder aux pods
- Gère automatiquement la découverte et le routage du trafic
- Assure l'équilibrage de charge entre les pods
- Permet une communication fiable entre les différents composants


> Les services Kubernetes remplissent plusieurs rôles stratégiques :

1. **Abstraction du Réseau** : Masquent la complexité des pods éphémères
2. **Load Balancing** : Distribuent le trafic de manière optimale
3. **Service Discovery** : Facilitent la découverte automatique des ressources
4. **Exposition Externe** : Permettent l'accès depuis l'extérieur du cluster



---
# 2 - Cas concret d'utilisation des Services (NodePort) : Problème de communication externe et solution
---
- Voyons un cas concret de l'utilisation des services.
- Jusqu'à présent, nous avons parlé de la communication entre les pods via le réseau interne.
- Examinons maintenant d'autres aspects du réseau dans cette leçon.

### 2.1 - Communication Externe

> Imaginons que nous ayons déployé notre pod avec une application web qui y tourne. Comment, en tant qu'utilisateur externe, pouvons-nous accéder à cette page web ?

#### 2.1.1 - Configuration Existante

- Le nœud Kubernetes a une adresse IP, par exemple 192.168.1.2. Mon ordinateur portable est sur le même réseau avec l'adresse IP 192.168.1.10. Le réseau interne des pods est dans la plage 10.240.0.0, et le pod a une adresse IP 10.240.0.2.

- Il est clair que je ne peux pas pinger ou accéder directement au pod à l'adresse 10.240.0.2 car il se trouve sur un réseau séparé.



<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service2.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 2: Illustration d'un Service Kubernetes gérant la communication entre les Pods et le trafic externe</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>




### 2.1.2 - Solution

#### 2.1.2.1 - Options pour Voir la Page Web

- Premièrement, si nous nous connectons au nœud Kubernetes à l'adresse 192.168.1.2, depuis ce nœud, nous pourrions accéder à la page web du pod en utilisant une commande curl ou en ouvrant un navigateur et en accédant à l'adresse http://10.240.0.2.

- Cependant, cela se fait depuis l'intérieur du nœud Kubernetes, et ce n'est pas ce que nous voulons. Nous souhaitons accéder au serveur web depuis notre propre ordinateur sans avoir à nous connecter au nœud, simplement en accédant à l'IP du nœud Kubernetes.

- Nous avons donc besoin de quelque chose pour mapper les requêtes de notre ordinateur au nœud, puis du nœud au pod exécutant le conteneur web. C'est là qu'interviennent les services Kubernetes.



#### 2.1.2.2 - Explication du fonctionnement du Service NodePort : Réseaux interne et externe


<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service16-17.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 3: Vues détaillées d'un Service Kubernete NodePort et ses interactions</em></p>
</div>

Cette illustration montre clairement que l'accès à une application Kubernetes via un **Service NodePort** implique l'utilisation de **deux réseaux distincts** : un réseau externe et un réseau interne


*<u style={{color: "#FF6B6B"}}>1. Réseau externe (côté utilisateur)</u>*

> - **Adresse IP externe du Node** : `192.168.1.2`
> - **Adresse IP de l'utilisateur** : `192.168.1.10`
> - L'utilisateur envoie une requête HTTP à l'adresse IP **externe** du Node (`192.168.1.2`) sur le **port exposé** (`30008`). Cette IP est visible sur le réseau auquel appartient le Node et permet aux clients de l'extérieur du cluster de joindre un service.



*<u style={{color: "#FF6B6B"}}>2. Réseau interne (côté cluster Kubernetes)</u>*

> - **Adresse IP interne du Pod** : `10.244.0.2`
> - **Adresse du sous-réseau Kubernetes** : `10.244.0.0/16` (exemple de plage IP interne assignée aux Pods)

>À l'intérieur du cluster, chaque Pod possède une adresse IP privée unique issue d'un réseau interne dédié (`10.x.x.x`). Cette adresse IP est **invisible depuis l'extérieur** du cluster. Le Pod communique avec d'autres ressources internes via ce réseau interne.



*<u style={{color: "#FF6B6B"}}>3. Comment fonctionne la communication entre les réseaux ?</u>*

> 1. L'utilisateur envoie une requête à l'IP **externe** du Node (`192.168.1.2`) sur le port `30008` :
>    ```bash
>    curl http://192.168.1.2:30008
>    ```
> 2. Le service **NodePort** reçoit cette requête sur le port et la redirige vers l'IP **interne** du Pod (`10.244.0.2`).
> 3. Le Pod traite la requête et répond à l'utilisateur via le réseau externe.



*<u style={{color: "#FF6B6B"}}>4. Pourquoi deux réseaux ?</u>*

> - **Réseau interne (10.x.x.x)** : Ce réseau est dédié aux communications internes des Pods et ne doit pas être accessible directement depuis l'extérieur pour des raisons de sécurité.
> - **Réseau externe (192.168.x.x)** : Ce réseau permet l'interconnexion entre les clients externes et les services du cluster.



*<u style={{color: "#FF6B6B"}}>5. Exemple pratique</u>*

> - Requête envoyée via le réseau externe :
>    ```bash
>    curl http://192.168.1.2:30008
>    ```
> - Redirection interne vers le Pod `10.244.0.2` qui renvoie :
>    ```
>    Hello World!
>    ```

Nous avons trouvé une solution pour accéder à notre application web depuis l'extérieur du cluster Kubernetes grâce au Service de type **NodePort**. Le Service **NodePort** agit comme un "pont" entre le réseau externe du Node et le réseau interne du cluster Kubernetes. Cette distinction des réseaux permet de protéger l'accès direct aux Pods tout en offrant un point d'entrée pour les utilisateurs extérieurs. Le service assure ainsi une communication fluide sans exposer directement les adresses IP internes des Pods.






---
# 3 - Implémentation d'un Service NodePort
---

Revenons à NodePort, nous avons discuté de l'accès externe à l'application. Nous avons dit qu'un service peut nous aider en mappant un port sur le nœud à un port sur le pod.

*<u style={{color: "red"}}>3.1. Ports impliqués :</u>*

Regardons de plus près le service. Il y a trois ports impliqués :

> 1. Le port sur le pod où le serveur web s'exécute, appelé port cible (target port), généralement 80.
> 2. Le port sur le service lui-même, simplement appelé port.
> 3. Le port sur le nœud, appelé NodePort, par exemple 30008.

*<u style={{color: "red"}}>3.2. Création du service :</u>*

Nous créons un service en utilisant un fichier de définition, comme nous l'avons fait pour les déploiements, les réplicasets ou les pods. La structure du fichier reste la même : API version, kind, metadata et spec.

    > - La version de l'API est v1.
    > - Le kind est Service.
    > - Les metadata incluent le nom du service.
    > - La section spec est cruciale : on y définit les ports et le type de service (NodePort).

*<u style={{color: "red"}}>3.3. Définition des ports :</u>*

Sous ports, nous définissons :
> - Le port cible (target port), 80.
    > - Le port du service, 80.
    > - Le NodePort, par exemple 30008.

*<u style={{color: "red"}}>3.4.Labeles et sélecteurs :</u>*

> - Il manque encore une chose : connecter le service au pod. Nous utilisons des labels et des sélecteurs pour cela. Nous ajoutons les labels du pod dans la section selector du fichier de définition du service.

Une fois cela fait, nous créons le service avec la commande `kubectl create` et vérifions avec `kubectl get services`.

*<u style={{color: "red"}}>3.5. Accès au Service :</u>*

> - Nous pouvons maintenant accéder au service web en utilisant curl ou un navigateur avec l'adresse IP du nœud et le NodePort.

Pour résumer, que ce soit un pod unique, plusieurs pods sur un même nœud, ou plusieurs pods sur plusieurs nœuds, le service est créé de la même manière sans étapes supplémentaires.



# Partie 2 : Démonstration des Services Kubernetes

Dans cette démonstration, nous allons examiner les services dans Kubernetes et reprendre là où nous nous étions arrêtés lors de la précédente démonstration.

Nous avons créé quelques pods en créant un déploiement, alors vérifions d'abord le statut de ce déploiement.

Nous avons un déploiement appelé "my-app-deployment" avec six réplicas, ce qui signifie essentiellement que six pods fonctionnent dans le cluster Kubernetes.

Nous avons maintenant une application créée pour s'exécuter sur ce cluster. Cependant, pour que l'utilisateur final puisse y accéder via son navigateur web, nous devons créer un service.

Pour ce faire, revenons à notre éditeur.

Nous avons créé un nouveau répertoire appelé "Service". Dans ce répertoire "Service", nous allons créer un nouveau fichier appelé "service-definition.yaml".

Notez que vous n'avez pas besoin de suivre cette structure de répertoire comme je le fais. Je le fais simplement pour organiser les exemples. Vous pourriez simplement avoir tous les fichiers au même endroit.

### Création du Fichier de Définition du Service

Comme précédemment, la première chose à ajouter est l'élément racine, la version de l'API. Pour un service, elle doit être définie à "v1". Pour le type (kind), nous allons spécifier "Service".

Ensuite, nous allons ajouter les métadonnées avec le nom du service que nous pouvons appeler "my-app-service".

Sous cela, nous allons ajouter la section des spécifications (spec). La première propriété que nous allons créer est le type de service, que nous allons définir comme "NodePort".

Notre objectif est de pouvoir accéder à notre application sur un port du nœud, qui est le nœud Minikube dans notre cas.

Nous allons ensuite ajouter le port et le port par défaut sur lequel Nginx écoute, qui est 80. Nous allons également ajouter notre port cible (target port), qui est également le port 80.

Il s'agit essentiellement du port sur le service lui-même.

Ensuite, nous allons ajouter un NodePort que nous pouvons définir à une valeur telle que 30004. Cela pourrait être n'importe quelle valeur entre 30000 et 32767.

Ce NodePort est le port sur le nœud, le nœud de travail, qui est le nœud Minikube sur lequel l'application sera accessible.

Ensuite, nous allons ajouter un sélecteur (selector) qui nous aide à lier notre service au pod avec la même étiquette.

### Vérification du Fichier de Déploiement

Jetons rapidement un coup d'œil au fichier YAML de déploiement et vous remarquerez que l'étiquette pour le pod est "app" avec la valeur "my-app".

Ajoutons cette même valeur ici sous la section "selector".

### Finalisation du Fichier de Définition du Service

Une fois cela terminé, notre fichier de définition de service est complet et nous pouvons procéder à sa création sur nos clusters.

Je vais le sauvegarder ici et revenir à mon terminal. Je vais naviguer vers le nouveau répertoire que nous avons créé, où se trouve notre fichier de définition de service.

Je vais créer le service en utilisant la commande `kubectl create` avec l'option `-f` et spécifier le fichier de définition du service en entrée.

Je lance cette commande et le service a été créé.

Nous pouvons maintenant exécuter la commande `kubectl get services` et vous remarquerez que le nouveau service est visible. Le type du service est "NodePort", car nous voulons qu'il soit accessible sur le port du nœud de travail.

Voici l'adresse IP du cluster qui est également créée pour le service. Il s'agit d'une adresse créée pour le service dans le réseau interne du cluster.

Voici le port sur le nœud de travail que nous pouvons utiliser pour accéder à notre application. Si vous connaissez l'adresse IP du nœud de travail, vous pouvez simplement aller sur un navigateur, taper l'adresse IP du nœud de travail suivie du numéro de port, et vous devriez pouvoir accéder à cette application.

### Utilisation de Minikube

Comme nous exécutons cela sur Minikube, nous pouvons également utiliser la commande `minikube service` suivie du nom du service, qui est "my-app-service", et utiliser l'option `--url`. Cela devrait nous donner l'URL où le service est disponible.

Essayons d'accéder à cela sur un navigateur. Vous pouvez simplement copier cette URL, aller sur un navigateur et coller cette URL dans le navigateur. Nous voyons alors la page web par défaut de Nginx, ce qui confirme que l'application Nginx est opérationnelle et accessible via un navigateur web.

C'est tout pour cette démonstration. Je vous retrouverai dans la prochaine leçon.





### Partie 3 : ClusterIP

Bonjour et bienvenue dans ce cours.

Dans cette leçon, nous allons discuter du service ClusterIP de Kubernetes.

Une application web full-stack a généralement différents types de pods hébergeant différentes parties de l'application.

Vous pouvez avoir plusieurs pods exécutant un serveur web frontend, un autre ensemble de pods exécutant un serveur backend, un ensemble de pods exécutant un store clé-valeur comme Redis et un autre ensemble de pods exécutant une base de données persistante comme MySQL.

Le serveur web frontend doit communiquer avec les serveurs backend, et ces derniers doivent communiquer avec la base de données ainsi que les services Redis, etc.

### Connectivité entre les Services

Les pods ont tous une adresse IP qui leur est attribuée, comme nous pouvons le voir à l'écran. Cependant, ces adresses IP ne sont pas statiques. Les pods peuvent tomber à tout moment et de nouveaux pods sont créés en permanence, donc vous ne pouvez pas vous fier à ces adresses IP pour la communication interne entre les composants de l'application.

De plus, si le premier pod frontend à l'adresse 10.240.0.3 doit se connecter à un service backend, lequel des trois doit-il choisir et qui prend cette décision ?

Un service Kubernetes peut nous aider à regrouper les pods et à fournir une interface unique pour accéder aux pods d'un groupe.

### Exemple de Service Backend

Par exemple, un service créé pour les pods backend regroupera tous les pods backend et fournira une interface unique pour que d'autres pods puissent accéder à ce service. Les requêtes sont transférées de manière aléatoire à l'un des pods sous le service.

De même, vous pouvez créer des services supplémentaires pour Redis et permettre aux pods backend d'accéder aux systèmes Redis via le service. Cela nous permet de déployer facilement et efficacement une application basée sur des microservices sur un cluster Kubernetes.

Chaque couche peut maintenant s'adapter ou se déplacer selon les besoins sans impacter la communication entre les différents services.

### Création d'un Service ClusterIP

Chaque service obtient une IP et un nom attribués à l'intérieur du cluster, et c'est ce nom qui doit être utilisé par les autres pods pour accéder au service. Ce type de service est connu sous le nom de ClusterIP.

Pour créer un tel service, utilisez comme toujours un fichier de définition. Dans ce fichier de définition de service, utilisez le modèle par défaut avec les sections API version, kind, metadata et spec.

- La version de l'API est "v1".
- Le type est "Service".
- Donnez un nom à votre service, par exemple "backend".

Sous la spécification, nous avons le type et les ports. Le type est ClusterIP. En fait, ClusterIP est le type par défaut, donc même si vous ne le spécifiez pas, il assumera automatiquement ce type.

Sous la section ports, nous avons le targetPort et le port. Le targetPort est le port où le backend est exposé, dans ce cas 80, et le port est celui où le service est exposé, qui est également 80.

Pour lier le service à un ensemble de pods, nous utilisons un sélecteur. Nous référons au fichier de définition des pods, copions les labels de celui-ci et les plaçons sous la section selector.

### Création et Vérification du Service

- Nous pouvons maintenant créer le service en utilisant la commande `kubectl create` et vérifier son statut avec la commande `kubectl get services`.
- Le service peut être accessible par d'autres pods en utilisant le ClusterIP ou le nom du service.



### Partie 4 : LoadBalancer

- Nous allons maintenant examiner un autre type de service connu sous le nom de LoadBalancer.

- Nous avons déjà vu le service NodePort qui nous permet de rendre une application externe accessible sur un port des nœuds de travail. Concentrons-nous maintenant sur les applications frontend, comme l'application de vote et l'application de résultats.

- Ces pods sont hébergés sur les nœuds de travail dans un cluster. Supposons que nous ayons un cluster de quatre nœuds et que nous voulions rendre les applications accessibles aux utilisateurs externes en créant des services de type NodePort.

### Accessibilité avec NodePort

- Les services de type NodePort permettent de recevoir le trafic sur les ports des nœuds et de le rediriger vers les pods respectifs. Mais quelle URL donneriez-vous à vos utilisateurs pour accéder aux applications ?

- Vous pourriez accéder à n'importe laquelle de ces deux applications en utilisant l'IP de n'importe lequel des nœuds et le port élevé sur lequel le service est exposé. Cela signifie que vous auriez quatre combinaisons d'IP et de port pour l'application de vote et quatre combinaisons d'IP et de port pour l'application de résultats.

- Même si vos pods sont uniquement hébergés sur deux des nœuds, ils seront toujours accessibles via les IP de tous les nœuds du cluster. Par exemple, si les pods de l'application de vote ne sont déployés que sur les nœuds avec les IP 70 et 71, ils seront toujours accessibles sur les ports de tous les nœuds du cluster.

### Besoin d'une URL Unique

- Pourtant, ce n'est pas ce que les utilisateurs finaux souhaitent. Ils ont besoin d'une URL unique, comme par exemple `voting.abc.com` ou `result.abc.com`, pour accéder à l'application. Comment y parvenir ?
  
- Une façon d'y parvenir est de créer une nouvelle machine virtuelle pour le load balancer, d'y installer et de configurer un load balancer approprié comme HAProxy ou NGINX, puis de configurer le load balancer pour rediriger le trafic vers les nœuds sous-jacents.

### Utilisation des Load Balancers Natifs des Clouds

- Cependant, configurer tout cela et ensuite maintenir et gérer le load balancer externe peut être une tâche fastidieuse. Si nous étions sur une plateforme cloud supportée comme Google Cloud, AWS ou Azure, nous pourrions tirer parti du load balancer natif de cette plateforme cloud.

- Kubernetes prend en charge l'intégration avec les load balancers natifs de certains fournisseurs de cloud et peut configurer cela pour nous. Il suffit de définir le type de service pour les services frontend en tant que LoadBalancer au lieu de NodePort.

### Environnements Supportés

- Il est important de noter que cela ne fonctionne que sur des plateformes cloud supportées. GCP, AWS et Azure sont définitivement supportés. Si vous définissez le type de service en tant que LoadBalancer dans un environnement non supporté comme VirtualBox ou d'autres environnements, cela aura le même effet que de le définir en tant que NodePort, où les services sont exposés sur un port élevé sur les nœuds. Il n'y aura simplement pas de configuration de load balancer externe.

- Lorsque nous passerons en revue les démonstrations de déploiement de notre application sur des plateformes cloud, nous verrons cela en action.






































---
### Annexe 1 : *L'Importance des Services dans une Architecture Kubernetes*
---

<br/>
<br/>
<br/>





---
### Annexe 2 : *Explication détaillée du service NodePort*
---


-------------









----

### *<u style={{color: "green"}}>Figure 2 : Interaction avec un Pod Kubernetes : De l'Utilisateur au Service Déployé</u>*

>Cette illustration montre comment un utilisateur peut interagir avec une application déployée dans un Pod Kubernetes via un accès SSH à un Node. Elle illustre le fonctionnement du réseau dans Kubernetes, avec la communication des adresses IP internes (Pod) et externes (Node).



Cette figure montre la communication entre un utilisateur (via un terminal sur une machine locale) et un **Pod** déployé sur un **Node** Kubernetes. Voici les détails des éléments représentés :

1. **Utilisateur (192.168.1.10)** : L'utilisateur utilise une machine locale avec une adresse IP privée `192.168.1.10`. La communication est établie via **SSH** vers un Node.
   
2. **Node Kubernetes (192.168.1.2)** : Le Node, une machine physique ou virtuelle avec l'adresse IP `192.168.1.2`, héberge des **Pods**. Un Pod est une unité de déploiement dans Kubernetes, contenant des conteneurs exécutant des applications.

3. **Pod (10.244.0.2)** : Ce Pod, identifié par l'adresse IP interne `10.244.0.2`, exécute un conteneur Python (représenté par le logo Python). Le Pod répond à des requêtes via une commande **curl** pour accéder à une page web ou un service interne.

4. **Commande `curl http://10.244.0.2`** : Cette commande est exécutée pour envoyer une requête HTTP au Pod. La réponse **"Hello World!"** indique que le service fonctionne correctement.























---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service3.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 3: Illustration d'un Service Kubernetes gérant la communication entre les Pods et le trafic externe</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---


<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service4.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 4: Illustration détaillée d'un Service Kubernetes et ses composants</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service5.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 5: Illustration détaillée d'un Service Kubernetes et ses composants</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service6.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 6: Illustration détaillée d'un Service Kubernetes et ses composants</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service7.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 7: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service8.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 8: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service9.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 9: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service10.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 10: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service11.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 11: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service12.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 12: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service13.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 13: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---

<div align="center">
  <img 
    src="/img/kubernetes/chapitre11/service14.png"
    alt="Diagramme d'un service Kubernetes"
    width="100%"
    height="auto" 
    style={{
      maxWidth: "1200px", 
      boxShadow: "0 4px 8px rgba(0,0,0,0.1)",
      borderRadius: "8px",
      margin: "2rem auto",
      animation: "bounce 2s infinite, pulse 3s infinite"
    }}
  />

---
  <p style={{
    animation: "slideIn 1s ease-in-out, fadeIn 2s ease-in",
    transform: "translateY(20px)"
  }}><em>Figure 14: Vue détaillée d'un Service Kubernetes et ses interactions</em></p>
</div>

<style>
{`
  @keyframes bounce {
    0%, 100% { transform: translateY(0); }
    50% { transform: translateY(-5px); }
  }
  
  @keyframes slideIn {
    from { transform: translateX(-100%); }
    to { transform: translateX(0); }
  }

  @keyframes pulse {
    0% { opacity: 1; }
    50% { opacity: 0.9; }
    100% { opacity: 1; }
  }
`}
</style>

---




# Annexe 

### Types de Services Kubernetes

Le service Kubernetes est un objet, tout comme les pods, les réplicasets ou les déploiements que nous avons utilisés auparavant. Un de ses cas d'utilisation est d'écouter un port sur le nœud et de transférer les requêtes de ce port à un port sur le pod exécutant l'application web.

#### NodePort

- Ce type de service est appelé NodePort, car le service écoute un port sur le nœud et transfère les requêtes à ce port.

#### ClusterIP

- Le deuxième type de service est le ClusterIP. Dans ce cas, le service crée une IP virtuelle à l'intérieur du cluster pour permettre la communication entre différents services, comme un ensemble de serveurs frontend et un ensemble de serveurs backend.

#### LoadBalancer

- Le troisième type est le LoadBalancer, où il provisionne un équilibrage de charge pour notre application sur des fournisseurs de cloud supportés, comme pour distribuer la charge entre différents serveurs web dans la couche frontend.


### Référence très importante sur les services de type nodePort:
- https://www.youtube.com/watch?v=5lzUpDtmWgM
