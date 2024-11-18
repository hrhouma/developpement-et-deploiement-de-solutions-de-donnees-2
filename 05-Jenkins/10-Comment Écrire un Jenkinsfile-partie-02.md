## 📝  🐧 Partie 10/15 - Comment Écrire un Jenkinsfile
##### 🛠️ Résumé et guide complet : Comment écrire un Jenkinsfile


Un **Jenkinsfile** est un fichier texte contenant la définition d'un pipeline Jenkins.  
Il peut être écrit de deux façons principales :

---

## 📝 Les deux types de Jenkinsfile

### 1️⃣ Méthode Scriptée
- 🕰️ **Ancienne méthode** : Utilise un DSL basé sur Groovy.
- 📜 **Moins lisible** : Requiert beaucoup de logique manuelle.

### 2️⃣ Méthode Déclarative
- 🌟 **Méthode moderne** : Fournit des fonctionnalités intégrées.
- 🧩 **Plus simple et lisible** : Idéal pour la collaboration.

➡️ **Nous allons nous concentrer sur la méthode déclarative.**

---

## 🌟 Syntaxe d'un pipeline déclaratif

Un pipeline déclaratif commence par un **bloc `pipeline`**. Ce bloc est obligatoire et contient d'autres blocs essentiels.

### Structure minimale d’un Jenkinsfile :
```groovy
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Hello, World!'
            }
        }
    }
}
```

### 📚 Description des blocs
1. **`pipeline`** : Conteneur principal du pipeline.
2. **`agent`** : Indique où exécuter le pipeline (ex. : machine Jenkins ou un nœud spécifique).
3. **`stages`** : Regroupe une série d'étapes (ou tâches).
4. **`stage`** : Définit une étape spécifique.
5. **`steps`** : Contient les commandes à exécuter dans le stage.

---

## 🔹 Bloc `agent`

Le bloc **`agent`** spécifie l'environnement d'exécution.  
Par exemple, pour exécuter sur n'importe quelle machine Jenkins, utilisez :

```groovy
agent any
```

### Autres options pour `agent` :
- **Machine spécifique** :
  ```groovy
  agent { label 'linux' }
  ```
- **Docker** :
  ```groovy
  agent {
      docker {
          image 'maven:3.8.5'
      }
  }
  ```

---

## 🔹 Bloc `stages` et `steps`

Un pipeline contient un ou plusieurs **`stages`**, qui regroupent les **`steps`**.  
Chaque **step** exécute une tâche, comme afficher un message ou exécuter une commande.

### Exemple de plusieurs stages :
```groovy
pipeline {
    agent any
    stages {
        stage('Build') {
            steps {
                echo 'Compilation du projet...'
                sh 'mvn clean install'
            }
        }
        stage('Test') {
            steps {
                echo 'Lancement des tests...'
                sh 'mvn test'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Déploiement du projet...'
                sh './deploy.sh'
            }
        }
    }
}
```

---

## 🔹 Bloc `post`

Le bloc **`post`** contient des actions à effectuer après le pipeline, quelles que soient les étapes précédentes.  
Il contient trois sections principales :

1. **`always`** : Toujours exécuté, succès ou échec.
2. **`success`** : Exécuté uniquement si tout est réussi.
3. **`failure`** : Exécuté en cas d'échec.

### Exemple avec un bloc `post` :
```groovy
pipeline {
    agent any
    stages {
        stage('Example') {
            steps {
                echo 'Exécution du pipeline...'
            }
        }
    }
    post {
        always {
            echo 'Pipeline terminé.'
        }
        success {
            echo 'Succès 🎉'
        }
        failure {
            echo 'Échec ❌'
        }
    }
}
```

---

## 🔹 Bloc `triggers`

Le bloc **`triggers`** redéclenche automatiquement le pipeline selon certains critères.

### Types de triggers :
1. **`cron`** : Planification avec une syntaxe de type CRON.
   ```groovy
   triggers {
       cron('H/15 * * * *') // Toutes les 15 minutes
   }
   ```
2. **`pollSCM`** : Vérifie les changements dans un dépôt Git.
   ```groovy
   triggers {
       pollSCM('* * * * *') // Toutes les minutes
   }
   ```

---

## 🔹 Bloc `parameters`

Le bloc **`parameters`** permet de passer des variables dynamiques au pipeline.

### Types courants de paramètres :
- **`string`** : Une chaîne de caractères.
- **`choice`** : Une liste de choix.
- **`booleanParam`** : Une valeur booléenne.
- **`password`** : Un champ pour un mot de passe.

### Exemple :
```groovy
parameters {
    choice(name: 'ENV', choices: ['dev', 'uat', 'prod'], description: 'Environnement cible')
}
```

---

## 🔹 Bloc `environment`

Le bloc **`environment`** définit des variables d'environnement utilisées dans le pipeline.

### Exemple global :
```groovy
pipeline {
    agent any
    environment {
        APP_NAME = 'MyApp'
    }
    stages {
        stage('Build') {
            steps {
                echo "Application : $APP_NAME"
            }
        }
    }
}
```

### Exemple spécifique à un stage :
```groovy
stage('Deploy') {
    environment {
        DEPLOY_ENV = 'production'
    }
    steps {
        echo "Déploiement sur : $DEPLOY_ENV"
    }
}
```

---

## 🏆 Meilleures pratiques pour écrire un Jenkinsfile

1. **Préférez la méthode Déclarative** :  
   Plus lisible et facile à maintenir.

2. **Organisez vos stages** :  
   Séparez les tâches logiques (ex. : Build, Test, Deploy).

3. **Utilisez des variables globales** :  
   Centralisez les valeurs importantes pour éviter les répétitions.

4. **Incluez des notifications** :  
   Ajoutez un bloc `post` pour des messages en cas de succès ou d'échec.

5. **Versionnez vos Jenkinsfiles** :  
   Placez-les dans votre dépôt Git pour suivre les modifications.

---

## 📂 Exemple complet de Jenkinsfile

```groovy
pipeline {
    agent any

    environment { 
        APP_NAME = 'MyApp'
    }

    parameters {
        choice(name: 'ENV', choices: ['dev', 'uat', 'prod'], description: 'Choisissez l\'environnement')
    }

    triggers {
        cron('H/15 * * * *')
    }

    stages {
        stage('Build') {
            steps {
                echo "Construction de $APP_NAME dans l'environnement ${params.ENV}"
                sh 'mvn clean install'
            }
        }

        stage('Test') {
            steps {
                echo "Tests unitaires pour $APP_NAME"
                sh 'mvn test'
            }
        }

        stage('Deploy') {
            steps {
                echo "Déploiement de $APP_NAME dans ${params.ENV}"
                sh './deploy.sh'
            }
        }
    }

    post {
        always {
            echo "Pipeline terminé pour $APP_NAME"
        }
        success {
            echo "Déploiement réussi 🎉"
        }
        failure {
            echo "Une erreur s'est produite ❌"
        }
    }
}
```

---

## 📖 Ressources supplémentaires

- 📘 [Documentation officielle Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
- 📘 [Guide complet sur Groovy DSL](https://groovy-lang.org/)
- 📘 [Exemples pratiques de Jenkinsfiles](https://devopspilot.com)

