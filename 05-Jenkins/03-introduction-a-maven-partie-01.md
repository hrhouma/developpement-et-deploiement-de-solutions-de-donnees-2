
## 🛠️ Partie 3/15 - Introduction à Maven  

---

# 1. Qu'est-ce que Maven ?

---


Maven est un outil d'automatisation de build principalement utilisé pour les projets Java, mais il peut également être utilisé avec d'autres langages. Il simplifie le processus de build, la gestion des dépendances, et la gestion du cycle de vie des projets en fournissant une méthode standard pour décrire un projet, ses dépendances, et les étapes de build. Pour quelqu'un qui connaît Java mais qui est nouveau avec Maven, pensez à Maven comme un outil qui automatise la compilation de votre code Java, son empaquetage dans un fichier JAR, la gestion des bibliothèques tierces, et bien plus encore—tout cela avec seulement quelques commandes.

---

# 2. Pourquoi avons-nous besoin de Maven ?

---


Lorsque vous travaillez sur des projets Java, en particulier des projets de grande envergure, la gestion des dépendances, la garantie de builds cohérents entre différents environnements, et la gestion de structures de projets complexes peuvent devenir des défis importants. Maven répond à ces défis en offrant :

- **Structure de projet standardisée :** Tous les projets Maven suivent une structure de répertoires standardisée.
- **Gestion des dépendances :** Télécharge automatiquement et gère les bibliothèques et plugins dont votre projet dépend à partir d'un dépôt central comme Maven Central.
- **Cycle de vie du build :** Simplifie le processus de compilation, de test, d'empaquetage et de déploiement de votre application.
- **Reproductibilité :** Assure que les builds sont cohérents dans différents environnements, grâce à la gestion centralisée des dépendances.

---

# 3. Comprendre le cycle de vie Maven

---


![image](https://github.com/user-attachments/assets/59a966be-07e8-4cc8-9946-e3702cfe2072)

(FIGURE 1 : Cycle de vie d'un livrable Maven)

Le cycle de vie d'un projet Maven peut être compris à travers les phases clés suivantes :

1. **Compile :** Convertit le code source en bytecode, placé dans le répertoire `target`.
2. **Test :** Exécute les tests unitaires, assurant que votre code se comporte comme prévu.
3. **Package :** Regroupe le code compilé dans un format distribuable, tel qu'un fichier JAR ou WAR.
4. **Install :** Installe le package dans le dépôt local, le rendant disponible pour d'autres projets.
5. **Deploy :** Déploie le package dans un dépôt distant pour le partager entre plusieurs développeurs ou projets.

Les phases du cycle de vie de Maven vous permettent d'automatiser l'ensemble du processus de build, de la compilation au déploiement, assurant ainsi la cohérence et réduisant les erreurs manuelles.

---

# 4. Structure d'un projet Maven

---


![image](https://github.com/user-attachments/assets/db695659-6a0b-4533-b126-e04214ddb0f4)

(FIGURE 2 : Structure d'un livrable Maven)

Chaque projet Maven possède une structure spécifique, qui inclut :

- **POM.xml (Project Object Model) :** Le cœur du projet Maven, ce fichier XML décrit le projet, ses dépendances, et ses plugins. Il définit également divers détails de configuration et les instructions de build.
- **Dépendances :** Les bibliothèques externes dont votre projet dépend, telles que les frameworks de logging ou les outils de test.
- **GroupID :** Identifie de manière unique votre projet au sein d'une organisation (par exemple, `com.example`).
- **ArtifactID :** Le nom de votre projet (par exemple, `calculator`).
- **VersionID :** La version de votre projet (par exemple, `1.0-SNAPSHOT`).
