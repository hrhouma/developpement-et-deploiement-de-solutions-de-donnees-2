<h1 id="examen-pipeline-maven">Examen : Création d’un Pipeline Jenkins pour un Projet Maven</h1>

**Durée** : 2h
**Objectif** : Automatiser la compilation, les tests et la livraison d’un projet Java Maven avec Jenkins Pipeline (déclaratif)

---

## <h2 id="etape-0">Préparation du projet</h2>

1. Crée un dossier nommé `projet-pipeline-maven`.
2. À l’intérieur, crée une structure Maven minimale :

```bash
mkdir -p projet-pipeline-maven/src/main/java/com/exemple
mkdir -p projet-pipeline-maven/src/test/java/com/exemple
```


ou encore mieux !!!

## <h2 id="etape-0-alt">Étape 0 – Génération du projet Maven avec Archetype</h2>


### 1. Ouvre ton terminal et exécute :

```bash
mvn archetype:generate -DgroupId=com.exemple \
                       -DartifactId=demo-pipeline \
                       -DarchetypeArtifactId=maven-archetype-quickstart \
                       -DinteractiveMode=false
```


### 2. Résultat attendu :

Cela va créer automatiquement cette structure :

```
demo-pipeline/
├── pom.xml
├── src/
│   ├── main/java/com/exemple/App.java
│   └── test/java/com/exemple/AppTest.java
```



### 3. Vérifie le fichier `pom.xml` :

Il est déjà prêt, avec `junit` comme dépendance.



### 4. Tu peux directement exécuter :

```bash
cd demo-pipeline
mvn clean test
```








3. Crée un fichier `pom.xml` minimaliste :

```xml
<project xmlns="http://maven.apache.org/POM/4.0.0" 
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
                             http://maven.apache.org/xsd/maven-4.0.0.xsd">
  <modelVersion>4.0.0</modelVersion>

  <groupId>com.exemple</groupId>
  <artifactId>demo-pipeline</artifactId>
  <version>1.0-SNAPSHOT</version>
  <packaging>jar</packaging>

  <dependencies>
    <dependency>
      <groupId>junit</groupId>
      <artifactId>junit</artifactId>
      <version>4.13.2</version>
      <scope>test</scope>
    </dependency>
  </dependencies>
</project>
```

4. Ajoute une classe Java simple :

**Fichier :** `src/main/java/com/exemple/App.java`

```java
package com.exemple;

public class App {
    public static void main(String[] args) {
        System.out.println("Hello Jenkins + Maven");
    }

    public static int addition(int a, int b) {
        return a + b;
    }
}
```

5. Ajoute un test unitaire :

**Fichier :** `src/test/java/com/exemple/AppTest.java`

```java
package com.exemple;

import static org.junit.Assert.assertEquals;
import org.junit.Test;

public class AppTest {
    @Test
    public void testAddition() {
        assertEquals(5, App.addition(2, 3));
    }
}
```

---

## <h2 id="etape-1">Étape 1 – Crée un Jenkinsfile</h2>

1. À la racine du projet, crée un fichier nommé **`Jenkinsfile`**.
2. Écris la structure de base :

```groovy
pipeline {
  agent any

  stages {
    stage('Exemple') {
      steps {
        echo 'Bonjour depuis Jenkins'
      }
    }
  }
}
```

---

## <h2 id="etape-2">Étape 2 – Intégration Git</h2>

1. Initialise un dépôt Git :

```bash
git init
git add .
git commit -m "Initial commit"
```

2. Simule une URL Git distante :
   Remplace dans le `Jenkinsfile` :

```groovy
stage('Checkout') {
  steps {
    git url: 'https://github.com/votre-utilisateur/votre-repo.git'
  }
}
```

> Ne t’inquiète pas si le dépôt n’existe pas. On simule pour l’examen.

---

## <h2 id="etape-3">Étape 3 – Compilation Maven</h2>

1. Ajoute un stage `Build` :

```groovy
stage('Build') {
  steps {
    sh 'mvn clean compile'
  }
}
```

---

## <h2 id="etape-4">Étape 4 – Tests Maven</h2>

1. Ajoute un stage `Test` :

```groovy
stage('Test') {
  steps {
    sh 'mvn test'
  }
  post {
    always {
      junit '**/target/surefire-reports/*.xml'
    }
  }
}
```

> Cela permet à Jenkins d’afficher les résultats des tests dans l’interface.

---

## <h2 id="etape-5">Étape 5 – Packaging et Artefacts</h2>

1. Ajoute un stage `Package` :

```groovy
stage('Package') {
  steps {
    sh 'mvn package'
    archiveArtifacts artifacts: 'target/*.jar', fingerprint: true
  }
}
```

---

## <h2 id="etape-6">Étape 6 – Paramètres dynamiques</h2>

1. Permets à l’utilisateur de choisir la branche à builder :

```groovy
parameters {
  string(name: 'BRANCH_NAME', defaultValue: 'main', description: 'Branche Git à utiliser')
}
```

2. Modifie le stage `Checkout` :

```groovy
stage('Checkout') {
  steps {
    git branch: "${params.BRANCH_NAME}", url: 'https://github.com/votre-utilisateur/votre-repo.git'
  }
}
```

---

## <h2 id="etape-7">Étape 7 – Analyse statique (facultatif)</h2>

1. Ajoute une étape Checkstyle :

```groovy
stage('Analyse') {
  steps {
    sh 'mvn checkstyle:checkstyle'
    publishHTML([reportDir: 'target/site', reportFiles: 'checkstyle.html', reportName: 'Checkstyle'])
  }
}
```

---

## <h2 id="livrables">Livrables</h2>

* Fichier `Jenkinsfile` complet
* Projet Maven fonctionnel (`pom.xml`, sources et tests)
* Capture d’écran de l’interface Jenkins (si possible)
* Résultats des tests, artefacts, rapports
