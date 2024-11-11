## 📝 PRATIQUE 1 – Hello World Jenkins WINDOWS

Dans cette première pratique, nous allons configurer un projet simple dans Jenkins pour exécuter des commandes Windows de base. Nous commencerons par une configuration sans Jenkinsfile, puis nous passerons à une version avec un Jenkinsfile pour découvrir les pipelines Jenkins.

---

## 🖥️ Configuration sans Jenkinsfile

### 🡺 **Étape 1.1: Ajouter une étape de build**
1. Dans Jenkins, commencez par créer un **nouveau projet de type "Freestyle project"**.
2. Allez dans la section **"Build"** et cliquez sur **"Add build step"**.
3. Sélectionnez **"Execute Windows batch command"** pour ajouter une commande batch.

### 🡺 **Étape 1.2: Entrer les commandes batch**
Dans la boîte de texte, entrez les commandes Windows suivantes pour lister les fichiers à la racine du disque C:\ :

```batch
C:
cd \
dir
```

- **C:** : Change le lecteur actif en lecteur C: (modifiez cela si Jenkins est installé sur un autre lecteur).
- **cd \\** : Change le répertoire courant pour la racine du lecteur C:.
- **dir** : Liste les fichiers et dossiers dans le répertoire actuel.

### 🡺 **Étape 1.3: Sauvegarder et exécuter le build**
1. Cliquez sur **"Save"** pour enregistrer la configuration du projet.
2. Retournez à la page principale du projet et cliquez sur **"Build Now"** pour lancer le build.
3. Une fois le build terminé, vous pourrez voir les résultats de ces commandes dans la **console de sortie** de Jenkins.

---

## 📝 Configuration avec Jenkinsfile

Passons maintenant à la configuration d’un pipeline en utilisant un Jenkinsfile, pour un contrôle plus avancé et un meilleur suivi des étapes.

### 🡺 **Étape 2.1: Créer un Jenkinsfile**
Dans votre dépôt SCM, créez un fichier nommé **Jenkinsfile** et ajoutez le contenu suivant :

```groovy
pipeline {
    agent any

    stages {
        stage('List Files') {
            steps {
                bat '''
                C:
                cd \\
                dir
                '''
            }
        }
    }
}
```

- **agent any** : Permet à Jenkins d’exécuter le job sur n’importe quel agent disponible.
- **stages** : Définit une série d’étapes. Ici, nous avons une étape appelée "List Files".
- **bat** : Indique que nous exécutons une commande batch sous Windows.

### 🡺 **Étape 2.2: Configurer le projet Jenkins pour utiliser le Jenkinsfile**
1. Dans Jenkins, créez un **nouveau projet de type "Pipeline"**.
2. Allez dans la section **"Pipeline"** et choisissez **"Pipeline script from SCM"**.
3. Sélectionnez le type de SCM (comme **Git**) où est stocké votre Jenkinsfile et configurez les détails du dépôt.
4. Spécifiez le chemin de votre Jenkinsfile si nécessaire (par défaut, Jenkins le cherchera à la racine du dépôt).

### 🡺 **Étape 2.3: Sauvegarder et exécuter le pipeline**
1. Cliquez sur **"Save"** pour enregistrer le pipeline.
2. Retournez à la page principale du projet et cliquez sur **"Build Now"** pour démarrer le pipeline.
3. Vous pourrez voir l’exécution des étapes et les résultats des commandes batch dans la console de sortie de Jenkins.

---

## 🔍 Conclusion

Dans cette pratique, vous avez appris deux façons de configurer un projet Jenkins pour exécuter des commandes Windows :

1. **Configuration simple** avec des commandes batch sans Jenkinsfile.
2. **Pipeline avancé** avec un Jenkinsfile, offrant un meilleur contrôle et une organisation des étapes.

---

## 🌱 5 - ALLER PLUS LOIN

Explorez plus de fonctionnalités de Jenkins pour automatiser vos tâches Windows et gérer des projets plus complexes avec des étapes supplémentaires dans votre Jenkinsfile.
