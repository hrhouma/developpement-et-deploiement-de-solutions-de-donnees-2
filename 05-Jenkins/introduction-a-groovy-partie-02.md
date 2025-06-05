<h1 id="plan-laboratoire">Plan du laboratoire Groovy & Jenkinsfile</h1>

| N° | Titre                                             | Objectif pédagogique                                          |
| -- | ------------------------------------------------- | ------------------------------------------------------------- |
| 1  | LAB 1 – Premiers pas avec Groovy                  | Apprendre la syntaxe de base : variables, conditions, boucles |
| 2  | LAB 2 – Fonctions et structures de données        | Manipuler fonctions, listes, maps, closures                   |
| 3  | LAB 3 – Création d’un script Groovy autonome      | Écrire un mini script Groovy exécutable                       |
| 4  | LAB 4 – Structure d’un Jenkinsfile                | Comprendre la structure d’un pipeline Jenkins                 |
| 5  | LAB 5 – Jenkinsfile simple avec `echo`            | Construire un pipeline avec des étapes de base                |
| 6  | LAB 6 – Jenkinsfile avec conditions (`when`)      | Ajouter du contrôle de flux (branches, environnements)        |
| 7  | LAB 7 – Jenkinsfile avec scripts shell (`sh`)     | Intégrer des commandes externes dans le pipeline              |
| 8  | LAB 8 – Jenkinsfile avec paramètres               | Utiliser des variables dynamiques et paramétrées              |
| 9  | LAB 9 – Jenkinsfile avec agents et environnements | Contrôler l’environnement d’exécution                         |
| 10 | LAB 10 – Projet final : Pipeline CI/CD complet    | Créer un pipeline complet : build, test, déploiement          |

---

<h1 id="lab1">LAB 1 – Premiers pas avec Groovy</h1>

<h2>Objectif</h2>

Découvrir les bases du langage Groovy en local : variables, conditions, boucles.

---

<h2>Étape 1 – Préparer l’environnement</h2>

1. Installer Groovy sur votre machine :

   ```bash
   sdk install groovy
   ```

   ou :

   ```bash
   brew install groovy   # sur macOS
   ```

2. Vérifier l’installation :

   ```bash
   groovy --version
   ```

3. Créer un fichier de script :

   ```bash
   touch lab1.groovy
   ```

---

<h2>Étape 2 – Écrire un premier script</h2>

Contenu du fichier `lab1.groovy` :

```groovy
def nom = "Alice"
def age = 20

if (age >= 18) {
    println("${nom} est majeur(e).")
} else {
    println("${nom} est mineur(e).")
}
```

---

<h2>Étape 3 – Exécuter le script</h2>

Dans le terminal :

```bash
groovy lab1.groovy
```

Résultat attendu :

```
Alice est majeur(e).
```

---

<h2>Étape 4 – Ajouter une boucle</h2>

Ajouter ce bloc à la fin du fichier `lab1.groovy` :

```groovy
for (i in 1..5) {
    println("Message numéro ${i}")
}
```

Résultat attendu :

```
Alice est majeur(e).
Message numéro 1
Message numéro 2
Message numéro 3
Message numéro 4
Message numéro 5
```



<br/>


<h1 id="lab2">LAB 2 – Fonctions et structures de données</h1>

<h2>Objectif</h2>

Apprendre à définir et utiliser des fonctions, des listes, des maps, et des closures dans Groovy.

---

<h2>Étape 1 – Créer un nouveau fichier</h2>

```bash
touch lab2.groovy
```

---

<h2>Étape 2 – Définir une fonction simple</h2>

```groovy
def saluer(nom) {
    return "Bonjour, ${nom}"
}

println(saluer("Alice"))
```

> Résultat attendu :
> `Bonjour, Alice`

---

<h2>Étape 3 – Ajouter une fonction avec condition</h2>

```groovy
def verifierAge(age) {
    if (age >= 18) {
        return "Majeur"
    } else {
        return "Mineur"
    }
}

println(verifierAge(20))
println(verifierAge(12))
```

> Résultat attendu :
> `Majeur`
> `Mineur`

---

<h2>Étape 4 – Utiliser une liste</h2>

```groovy
def fruits = ["pomme", "banane", "kiwi"]

println("Premier fruit : ${fruits[0]}")

for (fruit in fruits) {
    println("Fruit : ${fruit}")
}
```

> Résultat attendu :
> `Premier fruit : pomme`
> `Fruit : pomme`
> `Fruit : banane`
> `Fruit : kiwi`

---

<h2>Étape 5 – Utiliser une map (dictionnaire)</h2>

```groovy
def personne = [nom: "Alice", age: 30]

println("Nom : ${personne.nom}")
println("Âge : ${personne['age']}")
```

> Résultat attendu :
> `Nom : Alice`
> `Âge : 30`

---

<h2>Étape 6 – Utiliser une closure (fonction anonyme)</h2>

```groovy
def doubler = { x -> x * 2 }

println(doubler(4))  // 8
println(doubler(10)) // 20
```

---

<h2>Étape 7 – Exécution du script</h2>

```bash
groovy lab2.groovy
```

---

<h2>Résumé des notions apprises</h2>

* Déclaration de fonction avec `def`.
* Passage d'arguments.
* Utilisation de listes avec boucles.
* Accès aux éléments dans une map.
* Utilisation d'une closure (fonction sans nom).



<br/>













<br/>



<h1 id="lab3">LAB 3 – Création d’un script Groovy autonome</h1>

<h2>Objectif</h2>

Écrire un script Groovy complet, exécutable en ligne de commande, avec fonctions, conditions, boucles, listes et maps.

---

<h2>Étape 1 – Créer un fichier</h2>

```bash
touch lab3.groovy
```

---

<h2>Étape 2 – Écrire un script autonome</h2>

Voici le contenu du fichier `lab3.groovy` :

```groovy
// Script : Analyse de notes d'étudiants

def notes = [85, 70, 92, 56, 78, 61, 99, 45]

def moyenne(liste) {
    def somme = 0
    for (note in liste) {
        somme += note
    }
    return somme / liste.size()
}

def afficherResultat(note) {
    if (note >= 90) {
        return "Excellent"
    } else if (note >= 75) {
        return "Très bien"
    } else if (note >= 60) {
        return "Passable"
    } else {
        return "Échec"
    }
}

// Analyse individuelle
for (note in notes) {
    println("Note : ${note} => ${afficherResultat(note)}")
}

// Analyse globale
def moy = moyenne(notes)
println("\nMoyenne générale : ${moy}")
println("Résultat global : ${afficherResultat(moy)}")
```

---

<h2>Étape 3 – Exécuter le script</h2>

```bash
groovy lab3.groovy
```

---

<h2>Résultat attendu</h2>

```
Note : 85 => Très bien
Note : 70 => Passable
Note : 92 => Excellent
Note : 56 => Échec
...
Moyenne générale : 73.25
Résultat global : Passable
```

---

<h2>Points pédagogiques</h2>

* Création de fonctions de traitement (moyenne, analyse).
* Utilisation de `if`, `else if`, `else`.
* Boucles sur des listes.
* Organisation d’un script complet de traitement.













<br/>






<br/>






<h1 id="lab4">LAB 4 – Structure d’un Jenkinsfile</h1>

<h2>Objectif</h2>

Comprendre la structure de base d’un fichier `Jenkinsfile`, ses éléments principaux, et l’organisation d’un pipeline déclaratif.

---

<h2>Étape 1 – Qu’est-ce qu’un Jenkinsfile ?</h2>

Un `Jenkinsfile` est un **fichier de configuration écrit en Groovy** qui permet de décrire un pipeline de déploiement continu dans Jenkins.

Il suit généralement la **syntaxe déclarative**, structurée autour des éléments suivants :

* `pipeline { ... }` : bloc principal.
* `agent any` : spécifie l’agent d’exécution.
* `stages { ... }` : ensemble d'étapes du pipeline.
* `stage { ... }` : une étape du processus.
* `steps { ... }` : actions à exécuter dans une étape.

---

<h2>Étape 2 – Créer un Jenkinsfile simple</h2>

Dans votre projet, créez un fichier nommé exactement `Jenkinsfile` :

```bash
touch Jenkinsfile
```

Ajoutez le contenu suivant :

```groovy
pipeline {
    agent any

    stages {
        stage('Préparation') {
            steps {
                echo 'Préparation du pipeline...'
            }
        }

        stage('Compilation') {
            steps {
                echo 'Compilation du code...'
            }
        }

        stage('Tests') {
            steps {
                echo 'Lancement des tests...'
            }
        }

        stage('Déploiement') {
            steps {
                echo 'Déploiement terminé.'
            }
        }
    }
}
```

---

<h2>Étape 3 – Exécution dans Jenkins</h2>

1. Ouvrir Jenkins.
2. Créer un nouveau projet multibranch ou pipeline.
3. Lier le dépôt Git contenant le `Jenkinsfile`.
4. Jenkins détectera automatiquement le fichier et exécutera le pipeline.

---

<h2>Étape 4 – Interprétation ligne par ligne</h2>

| Ligne                    | Rôle                                                            |
| ------------------------ | --------------------------------------------------------------- |
| `pipeline {`             | Début du pipeline déclaratif                                    |
| `agent any`              | Choisir n’importe quel agent Jenkins disponible                 |
| `stages {`               | Début de la définition des étapes                               |
| `stage('...') { steps {` | Chaque étape (ex: préparation, tests) contient des instructions |
| `echo '...'`             | Affiche un message dans la console de Jenkins                   |

---

<h2>Résultat attendu</h2>

Le pipeline doit s’exécuter avec 4 étapes visibles dans Jenkins :

* Préparation
* Compilation
* Tests
* Déploiement

Chaque étape affiche le message correspondant.

---

<h2>Résumé des notions introduites</h2>

* Syntaxe déclarative de Jenkins Pipeline.
* Organisation en étapes séquentielles.
* Utilisation de `echo` pour simuler des tâches.
* Fichier de configuration lisible, versionnable et automatisé.








<br/>



<h1 id="lab4">LAB 4 – Structure d’un Jenkinsfile</h1>

<h2>Objectif</h2>

Comprendre la structure de base d’un fichier `Jenkinsfile`, ses éléments principaux, et l’organisation d’un pipeline déclaratif.

---

<h2>Étape 1 – Qu’est-ce qu’un Jenkinsfile ?</h2>

Un `Jenkinsfile` est un **fichier de configuration écrit en Groovy** qui permet de décrire un pipeline de déploiement continu dans Jenkins.

Il suit généralement la **syntaxe déclarative**, structurée autour des éléments suivants :

* `pipeline { ... }` : bloc principal.
* `agent any` : spécifie l’agent d’exécution.
* `stages { ... }` : ensemble d'étapes du pipeline.
* `stage { ... }` : une étape du processus.
* `steps { ... }` : actions à exécuter dans une étape.

---

<h2>Étape 2 – Créer un Jenkinsfile simple</h2>

Dans votre projet, créez un fichier nommé exactement `Jenkinsfile` :

```bash
touch Jenkinsfile
```

Ajoutez le contenu suivant :

```groovy
pipeline {
    agent any

    stages {
        stage('Préparation') {
            steps {
                echo 'Préparation du pipeline...'
            }
        }

        stage('Compilation') {
            steps {
                echo 'Compilation du code...'
            }
        }

        stage('Tests') {
            steps {
                echo 'Lancement des tests...'
            }
        }

        stage('Déploiement') {
            steps {
                echo 'Déploiement terminé.'
            }
        }
    }
}
```

---

<h2>Étape 3 – Exécution dans Jenkins</h2>

1. Ouvrir Jenkins.
2. Créer un nouveau projet multibranch ou pipeline.
3. Lier le dépôt Git contenant le `Jenkinsfile`.
4. Jenkins détectera automatiquement le fichier et exécutera le pipeline.

---

<h2>Étape 4 – Interprétation ligne par ligne</h2>

| Ligne                    | Rôle                                                            |
| ------------------------ | --------------------------------------------------------------- |
| `pipeline {`             | Début du pipeline déclaratif                                    |
| `agent any`              | Choisir n’importe quel agent Jenkins disponible                 |
| `stages {`               | Début de la définition des étapes                               |
| `stage('...') { steps {` | Chaque étape (ex: préparation, tests) contient des instructions |
| `echo '...'`             | Affiche un message dans la console de Jenkins                   |

---

<h2>Résultat attendu</h2>

Le pipeline doit s’exécuter avec 4 étapes visibles dans Jenkins :

* Préparation
* Compilation
* Tests
* Déploiement

Chaque étape affiche le message correspondant.

---

<h2>Résumé des notions introduites</h2>

* Syntaxe déclarative de Jenkins Pipeline.
* Organisation en étapes séquentielles.
* Utilisation de `echo` pour simuler des tâches.
* Fichier de configuration lisible, versionnable et automatisé.





<br/>










<br/>


<h1 id="lab6">LAB 6 – Jenkinsfile avec conditions (`when`) et gestion de branches</h1>

<h2>Objectif</h2>

* Ajouter des conditions pour exécuter certaines étapes uniquement dans certaines branches
* Comprendre la directive `when` dans un `Jenkinsfile`

---

<h2>Étape 1 – Créer un Jenkinsfile</h2>

```bash
touch Jenkinsfile
```

---

<h2>Étape 2 – Script de base avec `when`</h2>

Voici un pipeline conditionnel :

```groovy
pipeline {
    agent any

    environment {
        NOM_PROJET = "ProjetConditionnel"
    }

    stages {
        stage('Build') {
            steps {
                echo "Compilation de ${env.NOM_PROJET}"
            }
        }

        stage('Tests unitaires') {
            steps {
                echo "Exécution des tests..."
            }
        }

        stage('Déploiement vers développement') {
            when {
                branch 'develop'
            }
            steps {
                echo "Déploiement automatique vers l'environnement de développement"
            }
        }

        stage('Déploiement vers production') {
            when {
                branch 'main'
            }
            steps {
                echo "Déploiement approuvé vers l’environnement de production"
            }
        }
    }
}
```

---

<h2>Étape 3 – Explication</h2>

| Élément                               | Rôle                                                      |
| ------------------------------------- | --------------------------------------------------------- |
| `when { branch '...' }`               | Exécute une étape uniquement si la branche Git correspond |
| `branch 'main'` ou `branch 'develop'` | Filtres selon le nom de branche                           |

---

<h2>Étape 4 – Test dans Jenkins</h2>

1. Pousser ce `Jenkinsfile` dans une branche `develop` puis `main`.
2. Créer un projet Jenkins de type "Multibranch Pipeline".
3. Observer les étapes exécutées :

   * Sur `develop` → seule l’étape *Déploiement vers développement* s’exécute.
   * Sur `main` → seule l’étape *Déploiement vers production* s’exécute.

---

<h2>Étape 5 – Résultat attendu (dans develop)</h2>

```
Compilation de ProjetConditionnel
Exécution des tests...
Déploiement automatique vers l'environnement de développement
```

<h2>Résultat attendu (dans main)</h2>

```
Compilation de ProjetConditionnel
Exécution des tests...
Déploiement approuvé vers l’environnement de production
```

---

<h2>Résumé des notions introduites</h2>

* Utilisation de la directive `when` pour exécuter des étapes conditionnelles
* Contrôle basé sur le nom de la branche Git
* Début d’une logique CI/CD différenciée selon les environnements (développement, production)

<br/>


Voici la suite avec **LAB 7 – Jenkinsfile avec `sh` pour exécuter des commandes shell**, afin de permettre à vos étudiants d’interagir avec le système de fichiers, compiler du code ou lancer des tests via le terminal dans le pipeline Jenkins.

---

<h1 id="lab7">LAB 7 – Jenkinsfile avec exécution de commandes `sh`</h1>

<h2>Objectif</h2>

* Utiliser l’instruction `sh` pour exécuter des commandes shell dans les étapes du pipeline Jenkins
* Simuler des étapes réelles de compilation ou de test

---

<h2>Étape 1 – Créer un nouveau Jenkinsfile</h2>

```bash
touch Jenkinsfile
```

---

<h2>Étape 2 – Contenu du Jenkinsfile avec `sh`</h2>

```groovy
pipeline {
    agent any

    environment {
        NOM_PROJET = "MonProjetShell"
    }

    stages {
        stage('Initialisation') {
            steps {
                sh 'echo "Démarrage du pipeline pour ${NOM_PROJET}"'
                sh 'mkdir -p workspace'
            }
        }

        stage('Compilation simulée') {
            steps {
                sh 'echo "Compilation..."'
                sh 'touch workspace/app.jar'
            }
        }

        stage('Tests simulés') {
            steps {
                sh '''
                    echo "Test 1 : OK"
                    echo "Test 2 : OK"
                '''
            }
        }

        stage('Nettoyage') {
            steps {
                sh 'rm -rf workspace'
                sh 'echo "Dossier temporaire supprimé."'
            }
        }
    }
}
```

---

<h2>Étape 3 – Explication</h2>

| Instruction            | Description                                                  |
| ---------------------- | ------------------------------------------------------------ |
| `sh 'commande'`        | Exécute une commande shell dans l’environnement de l’agent   |
| `mkdir`, `rm`, `touch` | Commandes Unix standard simulant build, artefacts, nettoyage |
| Bloc `'''`             | Permet d’exécuter plusieurs lignes shell                     |

---

<h2>Étape 4 – Exécution dans Jenkins</h2>

1. Pousser ce Jenkinsfile dans un dépôt Git.
2. Lier ce dépôt à un projet pipeline dans Jenkins.
3. Lancer l’exécution manuellement ou via une branche.

---

<h2>Résultat attendu</h2>

Dans la console Jenkins, vous devez voir une sortie comme :

```
Démarrage du pipeline pour MonProjetShell
Compilation...
Test 1 : OK
Test 2 : OK
Dossier temporaire supprimé.
```

---

<h2>Résumé des notions apprises</h2>

* Utilisation de `sh` pour exécuter des commandes système
* Simulation d’actions réelles : création de fichiers, tests, nettoyage
* Introduction à la gestion d’artefacts simples dans Jenkins

---

Souhaitez-vous que je vous prépare **LAB 8 – Jenkinsfile avec paramètres d’entrée (`parameters`)**, pour permettre à vos étudiants de créer des pipelines interactifs ?


<br/>


Voici la suite avec **LAB 8 – Jenkinsfile avec paramètres (`parameters`)**, afin de permettre aux étudiants d’ajouter de l’interactivité aux pipelines Jenkins. Ce laboratoire montre comment déclencher un pipeline avec des choix dynamiques (texte, liste, booléen, etc.).

---

<h1 id="lab8">LAB 8 – Jenkinsfile avec paramètres d’entrée</h1>

<h2>Objectif</h2>

* Ajouter des paramètres d’entrée (`parameters`) à un pipeline Jenkins
* Utiliser les valeurs saisies pour contrôler le comportement du pipeline

---

<h2>Étape 1 – Créer un Jenkinsfile</h2>

```bash
touch Jenkinsfile
```

---

<h2>Étape 2 – Pipeline avec paramètres</h2>

```groovy
pipeline {
    agent any

    parameters {
        string(name: 'NOM_UTILISATEUR', defaultValue: 'Alice', description: 'Entrez votre nom')
        booleanParam(name: 'EXECUTER_TESTS', defaultValue: true, description: 'Voulez-vous exécuter les tests ?')
        choice(name: 'ENV_DEPLOIEMENT', choices: ['dev', 'staging', 'prod'], description: 'Choisissez l’environnement')
    }

    stages {
        stage('Accueil') {
            steps {
                echo "Bonjour ${params.NOM_UTILISATEUR}"
                echo "Vous avez choisi : ${params.ENV_DEPLOIEMENT}"
            }
        }

        stage('Tests') {
            when {
                expression { return params.EXECUTER_TESTS == true }
            }
            steps {
                echo "Exécution des tests unitaires..."
                sh 'echo "Tous les tests sont OK"'
            }
        }

        stage('Déploiement') {
            steps {
                echo "Déploiement vers l’environnement : ${params.ENV_DEPLOIEMENT}"
            }
        }
    }
}
```

---

<h2>Étape 3 – Explication des types de paramètres</h2>

| Type           | Syntaxe                                     | Exemple de valeur        |
| -------------- | ------------------------------------------- | ------------------------ |
| `string`       | `string(name: ..., defaultValue: ..., ...)` | "Alice"                  |
| `booleanParam` | `booleanParam(name: ..., ...)`              | true / false             |
| `choice`       | `choice(name: ..., choices: [...])`         | "dev", "staging", "prod" |

---

<h2>Étape 4 – Résultat attendu</h2>

Lorsque le pipeline démarre, Jenkins affiche un **formulaire d’entrée** demandant :

* Nom de l'utilisateur
* Exécution des tests (cocher ou décocher)
* Environnement de déploiement (menu déroulant)

En fonction des réponses :

* Si `EXECUTER_TESTS` est vrai → les tests sont affichés
* Sinon → l'étape "Tests" est ignorée

---

<h2>Résumé des notions introduites</h2>

* Utilisation du bloc `parameters` pour créer des pipelines interactifs
* Accès aux paramètres via `params.nom_du_paramètre`
* Utilisation conditionnelle des étapes avec `when { expression { ... } }`

---

Souhaitez-vous que je continue avec **LAB 9 – Jenkinsfile avec agents personnalisés et environnements Docker** ?


<br/>


Voici la suite avec **LAB 9 – Jenkinsfile avec agents personnalisés et environnements Docker**, pour introduire l'exécution contrôlée du pipeline sur des environnements spécifiques, comme un conteneur Docker.

---

<h1 id="lab9">LAB 9 – Jenkinsfile avec agents personnalisés et Docker</h1>

<h2>Objectif</h2>

* Comprendre la directive `agent` et ses options
* Exécuter un pipeline dans un conteneur Docker
* Apprendre à isoler des étapes dans des environnements ciblés

---

<h2>Étape 1 – Définition de l’agent global Docker</h2>

Créez un fichier nommé `Jenkinsfile` :

```bash
touch Jenkinsfile
```

Ajoutez ce contenu :

```groovy
pipeline {
    agent {
        docker {
            image 'python:3.10'
            args '-u root'
        }
    }

    stages {
        stage('Affichage de l’environnement') {
            steps {
                sh 'python --version'
                sh 'pip --version'
            }
        }

        stage('Script Python') {
            steps {
                sh 'echo "print(\\"Bonjour depuis Python dans Docker\\")" > script.py'
                sh 'python script.py'
            }
        }
    }
}
```

---

<h2>Explication</h2>

| Élément                            | Description                                                    |
| ---------------------------------- | -------------------------------------------------------------- |
| `agent { docker { image '...' } }` | Définit l’image Docker dans laquelle exécuter tout le pipeline |
| `args '-u root'`                   | Permet de forcer l’utilisateur root dans le conteneur          |
| `sh`                               | Exécute des commandes Linux dans le conteneur Docker           |

---

<h2>Étape 2 – Isolation par étape (agents différents par étape)</h2>

Voici un pipeline avec des agents différents selon l'étape :

```groovy
pipeline {
    agent none

    stages {
        stage('NodeJS') {
            agent {
                docker { image 'node:20' }
            }
            steps {
                sh 'node -v'
                sh 'npm -v'
            }
        }

        stage('Python') {
            agent {
                docker { image 'python:3.11' }
            }
            steps {
                sh 'python --version'
                sh 'echo "print(\\"Hello Python\\")" > script.py'
                sh 'python script.py'
            }
        }
    }
}
```

---

<h2>Résultat attendu</h2>

* Chaque étape s’exécute dans son propre conteneur
* NodeJS est utilisé uniquement pour la première étape
* Python est utilisé uniquement pour la deuxième

---

<h2>Résumé des notions apprises</h2>

* Utilisation de l’option `docker` dans `agent` pour exécuter un pipeline dans un conteneur
* Possibilité de changer d’agent entre les étapes (pipeline avec `agent none`)
* Capacité à exécuter des scripts dans un environnement isolé


<br/>


Voici la dernière étape de la série avec **LAB 10 – Projet final : pipeline CI/CD complet**, qui rassemble tout ce que vos étudiants ont appris : paramètres, conditions, agents, exécution shell et déploiement contrôlé.

---

<h1 id="lab10">LAB 10 – Projet final CI/CD complet avec Jenkinsfile</h1>

<h2>Objectif</h2>

Créer un pipeline Jenkins complet comprenant :

* Déclaration de paramètres
* Étapes conditionnelles selon la branche ou les paramètres
* Compilation simulée
* Tests conditionnels
* Déploiement simulé (développement ou production)
* Exécution dans un environnement Docker

---

<h2>Structure du projet</h2>

```bash
projet-ci-cd/
├── Jenkinsfile
└── app/
    └── main.py
```

---

<h2>Contenu du fichier `app/main.py`</h2>

```python
def dire_bonjour():
    print("Bonjour depuis l'application !")

if __name__ == "__main__":
    dire_bonjour()
```

---

<h2>Contenu du `Jenkinsfile`</h2>

```groovy
pipeline {
    agent any

    environment {
        NOM_PROJET = "ProjetFinal"
    }

    parameters {
        choice(name: 'ENV_DEPLOIEMENT', choices: ['develop', 'staging', 'prod'], description: 'Choisissez l’environnement cible')
        booleanParam(name: 'EXECUTER_TESTS', defaultValue: true, description: 'Exécuter les tests ?')
    }

    stages {

        stage('Initialisation') {
            steps {
                echo "Pipeline pour : ${env.NOM_PROJET}"
                echo "Cible de déploiement : ${params.ENV_DEPLOIEMENT}"
            }
        }

        stage('Compilation (simulée)') {
            steps {
                sh 'echo "Compilation du projet..."'
                sh 'mkdir -p build && touch build/app.jar'
            }
        }

        stage('Tests') {
            when {
                expression { return params.EXECUTER_TESTS }
            }
            steps {
                echo "Lancement des tests automatisés"
                sh 'echo "Test A : OK"'
                sh 'echo "Test B : OK"'
            }
        }

        stage('Déploiement') {
            when {
                anyOf {
                    branch 'main'
                    branch 'develop'
                }
            }
            steps {
                script {
                    if (params.ENV_DEPLOIEMENT == 'prod') {
                        echo "Déploiement vers la production sécurisé"
                    } else {
                        echo "Déploiement vers l’environnement de test (${params.ENV_DEPLOIEMENT})"
                    }
                }
            }
        }

        stage('Exécution Docker') {
            agent {
                docker { image 'python:3.10' }
            }
            steps {
                sh 'python app/main.py'
            }
        }

        stage('Nettoyage') {
            steps {
                sh 'rm -rf build'
                echo "Nettoyage terminé."
            }
        }
    }
}
```

---

<h2>Étapes pédagogiques validées</h2>

| Fonctionnalité                            | Implémentée |
| ----------------------------------------- | ----------- |
| Paramètres utilisateur (`parameters`)     | ✔️          |
| Variables d’environnement (`environment`) | ✔️          |
| Commandes shell (`sh`)                    | ✔️          |
| Étapes conditionnelles (`when`)           | ✔️          |
| Branche conditionnelle                    | ✔️          |
| Agents Docker par étape                   | ✔️          |
| Nettoyage et gestion des artefacts        | ✔️          |

---

<h2>Résultat attendu</h2>

* Le pipeline s’exécute selon les choix utilisateur
* Les tests peuvent être désactivés
* Le déploiement est contrôlé selon la branche et l’environnement
* L’application Python est exécutée dans un conteneur Docker
* Un nettoyage final supprime les artefacts simulés

---

<h2>Conclusion</h2>

Vous avez bien appris à : 

* Écrire du Groovy pour Jenkins
* Utiliser les blocs `pipeline`, `agent`, `stages`, `steps`, `parameters`, `environment`, `when`, `script`, `docker`
* Mettre en place un pipeline CI/CD modulaire, lisible, réutilisable




