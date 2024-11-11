# Qu'est-ce que Jenkins ?
Jenkins est un outil open-source utilisé pour automatiser les processus CI/CD (intégration et déploiement continus). Il facilite le déploiement rapide et fiable des logiciels en orchestrant les étapes du pipeline CI/CD, y compris la construction, le test et le déploiement. Jenkins utilise une architecture maître-esclave, où le nœud maître orchestre les travaux tandis que les agents (ou nœuds esclaves) exécutent les tâches spécifiques. Il prend en charge différents types de pipelines, comme le **pipeline simple** pour gérer un seul projet et le **pipeline multi-branches** pour automatiser le CI/CD sur plusieurs branches dans un dépôt de code.

### Annexe : Exécution de Jenkins dans un conteneur Docker
1. **Installation Docker** : Installez Docker sur votre machine locale.
2. **Démarrage du conteneur Jenkins** :
   ```bash
   docker pull jenkins/jenkins
   docker run -d -p 8080:8080 -v jenkins_volume:/var/jenkins_home --name my_jenkins jenkins/jenkins
   ```
   - Le port 8080 est exposé pour accéder à Jenkins.
   - Le volume `jenkins_volume` stocke les fichiers Jenkins pour préserver la configuration.
3. **Connexion initiale** : Utilisez le mot de passe initial fourni dans les logs Docker pour configurer Jenkins via `docker logs my_jenkins`.

Jenkins, en automatisant le pipeline CI/CD, réduit les erreurs manuelles, garantit une livraison plus rapide et améliore la qualité du logiciel produit.


--------------------
# Annexe 1 - Figure 01 
--------------------

![Untitled Project](https://github.com/user-attachments/assets/ba7bc0c5-f4bc-4893-95b1-0f4b3ce4e594)

*La figure ci-bas illustre les pipelines CI/CD avec Jenkins, un outil d'automatisation largement utilisé en DevOps pour orchestrer les étapes de construction, test et déploiement du code.*

# **Explication :**
Cette image présente un pipeline CI/CD où le processus se divise en plusieurs étapes :
1. **Commit** : Les développeurs commettent leurs modifications dans le système de contrôle de version (VCS).
2. **Build Job** : Jenkins surveille le VCS pour détecter les changements. Lorsqu'un changement est détecté, il initie un travail de construction (build job), qui extrait le code et le construit.
3. **Déploiement vers des environnements de test** : Le code construit est déployé vers différents environnements de test, notamment des environnements pour les tests fonctionnels et de performance.
4. **Tests** : Des tests fonctionnels et non fonctionnels (performance) sont exécutés pour valider le code.
5. **Déploiement en production** : Une fois les tests passés avec succès, le code est déployé dans l'environnement de production.


--------------------
# Annexe 1 - Figure 02 
--------------------

![0 - C'EST QUOI JENKINS-11](https://github.com/user-attachments/assets/65ac94ce-44d8-49a5-847c-7c37632d96d8)

**Explication :**

Cette image montre un pipeline CI/CD avec Jenkins, mettant en avant les interactions entre le développeur, le dépôt de code source et Jenkins :
1. **Dépôt de code** : Le développeur enregistre son code dans le dépôt (par exemple, Git).
2. **Jenkins** : Il extrait la dernière version du code, la construit et génère des artefacts (comme des exécutables ou sites web).
3. **Tests** : Des tests sont exécutés (comme NUnit, MSTest, etc.) après la construction.
4. **Déploiement et publication** : Jenkins déploie les artefacts dans un environnement de production, puis retourne un rapport de réussite ou d’échec.
