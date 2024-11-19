## 📝 Partie 7/15 - PRATIQUE 1 – Hello World Jenkins WINDOWS

Dans cette première pratique, nous allons configurer un projet simple dans Jenkins pour exécuter des commandes Windows de base. Nous commencerons par une configuration sans Jenkinsfile, puis nous passerons à une version avec un Jenkinsfile pour découvrir les pipelines Jenkins.

---
---
---

# Méthode 01 (Freestyle)

## 🖥️ Configuration sans Jenkinsfile

### 🡺 **Étape 1.1: Ajouter une étape de build**
1. Dans Jenkins, commencez par créer un **nouveau projet de type "Freestyle project"**.

![image](https://github.com/user-attachments/assets/8ddcb30f-de77-4f5e-af74-ebc4440fd4b1)

![image](https://github.com/user-attachments/assets/d6927b06-b285-4a65-801b-0fd87d883a30)

2. Ajoutez ue description du projet

![image](https://github.com/user-attachments/assets/36636d1e-a20f-4f9e-823f-df1c311315b5)

3. Choisir construire périodiquement et mettre * * * * * ==­­­> https://crontab.guru/#*_*_*_*_*

![image](https://github.com/user-attachments/assets/9f755d41-4a82-4ba6-8d08-12e4ac191fcd)


4. Allez dans la section **"Build"** et cliquez sur **"Add build step"**.
5. Sélectionnez **"Execute Windows batch command"** pour ajouter une commande batch.

![image](https://github.com/user-attachments/assets/fabb5186-d34f-4627-915c-6265cef0c0ad)


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

![image](https://github.com/user-attachments/assets/7e51519a-bd0f-423c-bbc8-f19a3de9ba8e)


### 🡺 **Étape 1.3: Sauvegarder et exécuter le build**
1. Cliquez sur **"Save"** pour enregistrer la configuration du projet.

![image](https://github.com/user-attachments/assets/81f500fc-4bce-4898-af71-961b4059bdef)


2. Retournez à la page principale du projet et cliquez sur **"Build Now"** pour lancer le build.

![image](https://github.com/user-attachments/assets/8d31c972-7067-477f-833f-a2a33b3ee273)

![image](https://github.com/user-attachments/assets/06ea14f7-64be-47c9-9dea-d3008a9cd3e5)

![image](https://github.com/user-attachments/assets/44dc1a4c-c31d-4596-b4e0-0c180944501b)

![image](https://github.com/user-attachments/assets/b39bef63-dfa0-4057-9271-26c4a92829e2)

![image](https://github.com/user-attachments/assets/1a7eba01-8924-4f7c-b07a-5d0febda62ae)


4. Une fois le build terminé, vous pourrez voir les résultats de ces commandes dans la **console de sortie** de Jenkins.

---


---
---
---

# Méthode 02 ( Pipeline)

## 📝 Configuration avec une pipeline Groovy

1. Choisir pipeline
![image](https://github.com/user-attachments/assets/46125fca-a2e3-49c7-a108-1f5f483360f9)

2. Refaire les mêmes étapes (Build Triggers ==> Construire périodiquement ==> * * * * * )
3. Remplir le script de la pipeline

### Oups erreur 
![image](https://github.com/user-attachments/assets/85a4ceb3-dc6b-42a7-a890-2abaad3f7975)

## Solution ==> Groovy

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

4. Retournez à la page principale du projet et cliquez sur **"Build Now"** pour lancer le build.

5. Une fois le build terminé, vous pourrez voir les résultats de ces commandes dans la **console de sortie** de Jenkins.



---
---
---

# Méthode 03 (SCM + JenkinsFile)


## 📝 Configuration avec Jenkinsfile

- Passons maintenant à la configuration d’un pipeline en utilisant un Jenkinsfile, pour un contrôle plus avancé et un meilleur suivi des étapes.
- _ Il s'agit des mêmes étapes que la méthode 2 à l'exception que nous avons choisi l'option SCM (Source Code Mangement = Gestion des versions ==> Il faut configurer Git pour pointer sur un projet contenant un certain Jenkinsfile)


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
