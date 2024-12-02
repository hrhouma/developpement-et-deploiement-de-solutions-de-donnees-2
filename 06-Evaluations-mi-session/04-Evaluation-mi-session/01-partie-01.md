# Partie 1 : (20% de la note finale)

# **Instructions :**  
- **Pour toutes les questions, choisissez une seule réponse correcte**, sauf pour la question **6**, où **deux réponses sont correctes**. Lisez attentivement chaque question avant de répondre.

---

**1. Quelle section de la configuration d’un projet Jenkins permet de définir comment un pipeline est déclenché automatiquement ?**  
a) Source Code Management  
b) Build Triggers  
c) Post-build Actions  
d) Build Environment  

---

**2. Quels sont les points forts principaux de Jenkins dans un projet d’automatisation ?**  
a) Interface simple, intégration continue, gestion de plugins.  
b) Hébergement cloud, gestion des données sensibles et une meilleure compatibilité avec les environnements Microsoft.  
c) Création de serveurs de base de données.  
d) Développement d’applications mobiles.  

---

**3. Lors de la configuration d’un webhook GitHub, quelle URL devez-vous fournir pour connecter Jenkins et déclencher automatiquement un pipeline ?**  
a) `http://your-jenkins-server/github-webhook/`  
b) `http://github.com/jenkins-webhook/`  
c) `http://localhost:8080/jenkins-webhook/`  
d) `http://your-repository/jenkins-trigger/`  

---

**4. Si un webhook ne peut pas être configuré, quelle méthode alternative permet à Jenkins de détecter des changements dans un dépôt GitHub ?**  
a) Utiliser le polling SCM.  
b) Créer un VPN entre Jenkins et GitHub.  
c) Héberger Jenkins sur le cloud GitHub.  
d) Ajouter un plugin supplémentaire pour chaque fichier.  

---

**5. Quel type d’expression utilisez-vous pour configurer le polling SCM dans Jenkins ?**  
a) JSON  
b) CRON  
c) YAML  
d) Bash Script  

---

**6. Dans Jenkins, comment configurez-vous un pipeline pour qu'il se déclenche automatiquement après un push sur GitHub ?**  
*(Note : Cette question comporte deux réponses correctes.)*

a) En configurant un **webhook** dans GitHub et en activant "Build Triggers" avec l’option **GitHub hook trigger for GITScm polling** dans Jenkins.  
b) En configurant le **SCM polling** dans Jenkins pour vérifier les changements à intervalles réguliers.  
c) En ajoutant un fichier `.jenkinsignore` pour surveiller les modifications.  
d) En activant une tâche cron dans Jenkins toutes les 5 minutes pour surveiller le dépôt.

---

**7. Lorsque vous configurez un pipeline Jenkins multibranches, comment détecte-t-il les nouvelles branches dans un dépôt GitHub ?**  
a) En scannant les branches automatiquement via les webhooks.  
b) En configurant une tâche cron dans Jenkins.  
c) En ajoutant manuellement chaque branche au pipeline.  
d) En activant l’option “Discover Branches” dans la configuration du pipeline.  

---

**8. Quel est le rôle principal de Jenkins dans un projet d’automatisation ?**  
a) Gérer des dépôts GitHub.  
b) Automatiser des tâches comme la construction, les tests et le déploiement.  
c) Héberger des bases de données.  
d) Surveiller l’utilisation des ressources du serveur.  

---

**9. Pourquoi est-il important d’ajouter des variables d’environnement dans Jenkins lors de la configuration d’un pipeline ?**  
a) Pour stocker des données sensibles comme des clés API.  
b) Pour permettre aux utilisateurs GitHub de gérer les branches.  
c) Pour simplifier l’interface Jenkins.  
d) Pour exécuter plusieurs tâches manuelles indépendantes.  

---

**10. Quel type de configuration permet de déclencher un pipeline Jenkins uniquement lors des modifications effectuées sur une branche spécifique d’un dépôt GitHub ?**  
a) Configurer les règles SCM pour la branche souhaitée.  
b) Créer un webhook distinct pour chaque branche.  
c) Utiliser une tâche manuelle pour chaque branche.  
d) Héberger Jenkins directement sur GitHub Actions.  
