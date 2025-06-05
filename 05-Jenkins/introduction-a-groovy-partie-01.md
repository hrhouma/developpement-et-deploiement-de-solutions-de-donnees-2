<h1 id="intro-groovy">1. Introduction à Groovy</h1>

Groovy est un **langage de script orienté objet** pour la plateforme Java. Il est **concis**, **dynamique**, et **interopérable avec Java**. Il est souvent utilisé dans les scripts Jenkins (`Jenkinsfile`), dans les tests, et dans l’automatisation.

### 1.1. Caractéristiques principales

* **Syntaxe proche de Java**, mais plus concise.
* Possède des **types dynamiques** (pas besoin de tout typer comme en Java).
* Compatible avec toutes les bibliothèques Java.
* Prise en charge des **closures** (fonctions anonymes).
* Utilisé dans Jenkins pour décrire les pipelines CI/CD.

---

<h1 id="bases-groovy">2. Bases du langage Groovy</h1>

### 2.1. Variables

```groovy
def nom = "Alice"        // variable dynamique
int age = 30             // variable typée (facultatif)
```

### 2.2. Fonctions

```groovy
def direBonjour(nom) {
    return "Bonjour, ${nom}"
}

println(direBonjour("Alice"))
```

### 2.3. Conditions

```groovy
def age = 20

if (age >= 18) {
    println("Majeur")
} else {
    println("Mineur")
}
```

### 2.4. Boucles

```groovy
for (i in 1..5) {
    println(i)
}
```

### 2.5. Listes et Maps

```groovy
def fruits = ["pomme", "banane", "kiwi"]
println(fruits[1])  // "banane"

def personne = [nom: "Alice", age: 30]
println(personne.nom)  // "Alice"
```

### 2.6. Closures (fonctions anonymes)

```groovy
def doubler = { x -> x * 2 }
println(doubler(4))  // 8
```

---

<h1 id="jenkinsfile">3. Introduction à Jenkinsfile</h1>

Un `Jenkinsfile` est un **script Groovy** qui décrit les étapes d’un pipeline CI/CD dans Jenkins.

### 3.1. Syntaxe de base

```groovy
pipeline {
    agent any  // exécuter sur n’importe quel agent

    stages {
        stage('Compilation') {
            steps {
                echo 'Compilation du code...'
            }
        }

        stage('Tests') {
            steps {
                echo 'Exécution des tests...'
            }
        }

        stage('Déploiement') {
            steps {
                echo 'Déploiement de l’application...'
            }
        }
    }
}
```

---

<h1 id="structure-jenkinsfile">4. Structure d’un Jenkinsfile</h1>

| Élément    | Description                                      |
| ---------- | ------------------------------------------------ |
| `pipeline` | Bloc principal du pipeline.                      |
| `agent`    | Détermine où les étapes sont exécutées.          |
| `stages`   | Contient une liste d’étapes (`stage`).           |
| `stage`    | Une étape du pipeline (ex: Build, Test, Deploy). |
| `steps`    | Les actions à exécuter dans chaque étape.        |

---

<h1 id="exemple-complet">5. Exemple complet d’un Jenkinsfile</h1>

```groovy
pipeline {
    agent any

    environment {
        NOM_PROJET = "MonApp"
    }

    stages {
        stage('Préparation') {
            steps {
                echo "Nom du projet : ${env.NOM_PROJET}"
                sh 'echo "Installation des dépendances..."'
            }
        }

        stage('Build') {
            steps {
                sh './gradlew build'
            }
        }

        stage('Tests') {
            steps {
                sh './gradlew test'
            }
        }

        stage('Déploiement') {
            when {
                branch 'main'
            }
            steps {
                sh 'echo "Déploiement en production..."'
            }
        }
    }
}
```

---

<h1 id="ressources">6. Ressources complémentaires</h1>

* [Documentation officielle de Groovy](https://groovy-lang.org/)
* [Pipeline syntax generator – Jenkins](https://www.jenkins.io/doc/book/pipeline/syntax/)
* [Jenkins Pipeline DSL Reference](https://www.jenkins.io/doc/pipeline/steps/)

