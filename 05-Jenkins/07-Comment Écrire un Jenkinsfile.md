## 📝  🐧 Partie 7/15 - Comment Écrire un Jenkinsfile

Un Jenkinsfile est un script utilisé pour définir les étapes d’un pipeline CI/CD dans Jenkins. Dans ce guide, nous allons explorer les concepts de base et nous concentrer sur la syntaxe **Déclarative**, la méthode recommandée pour sa simplicité et ses fonctionnalités.

### ✍️ Deux Méthodes pour Écrire un Jenkinsfile
Dans Jenkins, vous pouvez écrire un Jenkinsfile en utilisant deux syntaxes différentes :

- **Méthode Scriptée** 🧑‍💻 : Plus ancienne, cette méthode utilise le DSL Groovy pour écrire des logiques avancées.
- **Méthode Déclarative** 📜 : Plus récente et simple, elle offre une syntaxe plus riche et des fonctions intégrées, facilitant l'écriture et la lisibilité du code.

Nous allons nous concentrer sur la **méthode Déclarative** pour sa facilité d’utilisation, idéale pour les débutants.

---

### 🔹 Structure de Base d’un Pipeline Déclaratif

Un Jenkinsfile en méthode Déclarative commence toujours par le **bloc pipeline**, qui est obligatoire. Voici un exemple de structure basique :

```groovy
pipeline {
    agent any
    stages {
        stage('Print') {
            steps {
                echo "Bonjour Ingénieurs Devops"
            }
        }
    }
}
```

- **Bloc pipeline** : Le point de départ du Jenkinsfile.
- **Bloc agent** : Définit l’environnement d’exécution. Ici, `agent any` signifie que Jenkins peut exécuter ce job sur n’importe quel nœud disponible.
- **Bloc stages** : Contient les différentes étapes (ou stages) de votre pipeline.
- **Bloc steps** : Contient les actions spécifiques à exécuter dans chaque stage.

---

### 🧩 Les Différents Blocs d’un Jenkinsfile Déclaratif

#### 1️⃣ **Bloc agent**
Le bloc **agent** indique à Jenkins où exécuter le job. Vous pouvez spécifier `agent any` pour exécuter sur n’importe quel nœud, ou assigner un agent spécifique.

#### 2️⃣ **Bloc stage**
Le bloc **stage** permet de regrouper un ensemble de tâches logiques. Chaque stage peut contenir un ou plusieurs **steps**.

#### 3️⃣ **Bloc steps**
Dans le bloc **steps**, vous pouvez utiliser des commandes spécifiques, comme `sh` pour exécuter des commandes shell, ou `echo` pour afficher des messages.

---

### 📄 Exemple Complet avec Blocs post, triggers, parameters et environment

Voici un exemple avancé intégrant différents blocs pour un pipeline plus complet :

```groovy
pipeline {
    agent any
    
    triggers {
        cron('H/15 * * * *') // Relance toutes les 15 minutes
    }
    
    parameters {
        choice(name: 'environment', choices: ['dev', 'uat', 'prod'], description: 'Sélectionnez l’environnement')
    }
    
    environment {
        NAME = 'vignesh'
    }
    
    stages {
        stage('Print') {
            environment { 
                MESSAGE = 'Bonjour Ingénieurs Devops'
            }
            steps {
                echo "$MESSAGE"
            }
        }
    }
    
    post {
        always { 
            echo 'Je dirai toujours Bonjour à nouveau !'
        }
        success {
            echo 'Je dirai Bonjour seulement si le travail est un succès'
        }
        failure {
            echo 'Je dirai Bonjour seulement si le travail est un échec'
        }
    }
}
```

- **Bloc triggers** : Configure les déclencheurs pour exécuter automatiquement le pipeline.
- **Bloc parameters** : Permet de définir des paramètres dynamiques pour personnaliser le pipeline.
- **Bloc environment** : Définit des variables d'environnement qui sont accessibles dans tout le pipeline.
- **Bloc post** : Exécute des actions à la fin du pipeline, en fonction du résultat (succès, échec, etc.).

---

### 🌟 Explications des Blocs Avancés

- **Bloc post** :
  - `always` : S’exécute toujours, que le job réussisse ou échoue.
  - `success` : S’exécute uniquement si le job est un succès.
  - `failure` : S’exécute uniquement si le job échoue.

- **Bloc triggers** :
  - `cron` : Déclenche le pipeline à intervalle régulier (ex. : toutes les 15 minutes).
  - `pollSCM` : Vérifie les nouvelles modifications dans le dépôt à intervalles réguliers.

- **Bloc parameters** :
  - `choice` : Permet à l’utilisateur de sélectionner parmi plusieurs options (ex. : environnement `dev`, `uat`, `prod`).

- **Bloc environment** :
  - Définissez des variables globales ou spécifiques à un stage pour personnaliser les messages, l'environnement d'exécution, etc.

---

### 🚀 Conclusion

Écrire un Jenkinsfile en syntaxe Déclarative est simple et puissant. Avec des blocs bien structurés comme **agent**, **stages**, **steps**, **post**, et **triggers**, vous pouvez créer un pipeline CI/CD automatisé, lisible et évolutif. Que vous débutiez ou que vous soyez déjà familier avec Jenkins, ce guide vous offre une base solide pour écrire et optimiser vos Jenkinsfiles.
