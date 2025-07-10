## <h2 id="sans-service">Absence de Service – Conséquences</h2>

### **1. Les Pods ne sont pas exposés**

Un **Service** agit comme une façade stable pour accéder à un ou plusieurs Pods.
Sans lui :

* Les Pods **n'ont pas d'adresse IP stable** ni de nom DNS commun.
* Il faut connaître **manuellement l’IP interne** du Pod (éphémère et non fiable).
* Aucun autre Pod, ni utilisateur externe, **ne peut interagir facilement** avec ces Pods.

---

### **2. L’équilibrage de charge n’existe pas**

Sans Service :

* Si plusieurs Pods assurent le même rôle (ex. : serveur web), **aucune répartition du trafic** ne peut avoir lieu automatiquement.
* Le trafic doit être **géré manuellement** (ce qui est irréaliste en production).

---

### **3. Aucun accès depuis l’extérieur du cluster**

* Kubernetes **n’expose pas les Pods au monde extérieur** par défaut.
* Pour accéder à une application depuis le navigateur, un Service est **obligatoire**, au minimum de type `NodePort` ou `LoadBalancer`.

---

### **4. Communication inter-Pods limitée**

Même à l’intérieur du cluster :

* Un Pod A ne peut pas facilement **trouver ou appeler un Pod B** sans Service.
* Les requêtes doivent cibler des IPs précises au lieu d’un **nom DNS stable** (ex. : `my-app.default.svc.cluster.local`).

---

### **5. Problèmes avec les Redémarrages**

Quand un Pod est supprimé ou redémarré :

* Son IP change.
* **Tout lien direct est rompu**, sauf s’il passe par un Service qui **reste stable**.

---

### **Conclusion**

Sans `Service`, un Pod est comme un serveur **non connecté** à Internet ni au réseau de l'entreprise.
Il peut exister et fonctionner, mais **personne ne peut l’atteindre** facilement — ni les utilisateurs, ni les autres composants de l’application.

