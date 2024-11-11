

## 🧮 Partie 5/6 - Tuto Maven pour un Projet de Calculatrice  

---

# Étape 1 : Création du projet Maven

---


1. **Ouvrez une ligne de commande** et naviguez vers le répertoire où vous souhaitez créer votre projet, par exemple dans le dossier `Documents` :
   ```bash
   cd Documents
   ```

2. **Générez un projet Maven** en utilisant la commande suivante :
   ```bash
   mvn archetype:generate -DgroupId=com.example -DartifactId=calculator -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
   ```

---

# Étape 2 : Navigation dans le répertoire du projet

---

1. **Accédez au répertoire du projet** créé :
   ```bash
   cd calculator
   ```

2. **Ouvrez le projet dans VS Code** :
   ```bash
   code .
   ```

---

# Étape 3 : Renommer les fichiers App.java et AppTest.java

---

1. **Renommez les fichiers** suivants :
   - `App.java` → `Calculator.java`
   - `AppTest.java` → `CalculatorTest.java`


---
# Étape 4 : Créez et collez le code pour `Calculator.java`
---

1. **Créez un nouveau fichier** `Calculator.java` dans le répertoire `src/main/java/com/example/`.
2. **Collez le code suivant** dans `Calculator.java` :

   ```java
   package com.example;

   public class Calculator {
       public int add(int a, int b) {
           return a + b;
       }

       public int subtract(int a, int b) {
           return a - b;
       }

       public int multiply(int a, int b) {
           return a * b;
       }

       public double divide(int a, int b) {
           if (b == 0) {
               throw new IllegalArgumentException("Division by zero.");
           }
           return (double) a / b;
       }
   }
   ```


---

# Étape 5 : Créez et collez le code pour `CalculatorTest.java`

---

1. **Créez un nouveau fichier** `CalculatorTest.java` dans le répertoire `src/test/java/com/example/`.
2. **Collez le code suivant** dans `CalculatorTest.java` :

   ```java
   package com.example;
   import org.junit.Assert;
   import org.junit.Test;

   public class CalculatorTest {
       private Calculator calculator = new Calculator();

       @Test
       public void testAdd() {
           Assert.assertEquals(5, calculator.add(2, 3));
       }

       @Test
       public void testSubtract() {
           Assert.assertEquals(1, calculator.subtract(3, 2));
       }

       @Test
       public void testMultiply() {
           Assert.assertEquals(6, calculator.multiply(2, 3));
       }

       @Test
       public void testDivide() {
           Assert.assertEquals(2.0, calculator.divide(4, 2), 0);
       }

       @Test(expected = IllegalArgumentException.class)
       public void testDivideByZero() {
           calculator.divide(1, 0);
       }
   }
   ```

---

# Étape 6 : Configuration du fichier `pom.xml`

---

1. **Ouvrez le fichier `pom.xml`** situé à la racine de votre projet.
2. **Remplacez le contenu** du fichier `pom.xml` par le code suivant :

   ```xml
   <project xmlns="http://maven.apache.org/POM/4.0.0"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
            xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 http://maven.apache.org/xsd/maven-4.0.0.xsd">
       <modelVersion>4.0.0</modelVersion>

       <groupId>com.example</groupId>
       <artifactId>calculator</artifactId>
       <version>1.0-SNAPSHOT</version>

       <properties>
           <maven.compiler.source>1.8</maven.compiler.source>
           <maven.compiler.target>1.8</maven.compiler.target>
       </properties>

       <dependencies>
           <!-- JUnit dependency -->
           <dependency>
               <groupId>junit</groupId>
               <artifactId>junit</artifactId>
               <version>4.12</version>
               <scope>test</scope>
           </dependency>
       </dependencies>
   </project>
   ```

---

# Étape 7 : Exécutez les tests

---

1. **Compilez le projet et exécutez les tests** pour vérifier que tout fonctionne correctement :
   ```bash
   mvn clean test
   ```

---


# Étape 8 : Nettoyage du projet avec `mvn clean`

---

1. **Exécutez la commande `mvn clean`** pour nettoyer votre projet Maven :
   ```bash
   mvn clean
   ```
2. **Vérifiez que le répertoire `target` a été supprimé** :
   - Après avoir exécuté `mvn clean`, Maven supprimera le répertoire `target` où sont stockés les fichiers compilés et les résultats des tests. Pour vérifier, allez dans le répertoire de votre projet `calculator` et assurez-vous que le dossier `target` n'existe plus.

---

# Étape 9 : Construction du projet avec `mvn package`

---

1. **Exécutez la commande `mvn package`** pour compiler le projet et créer un fichier JAR exécutable :
   ```bash
   mvn package
   ```
2. **Vérifiez la création du fichier JAR** :
   - Après l'exécution de `mvn package`, Maven compilera le code source et créera un fichier JAR dans le répertoire `target`. Accédez à `target` et vérifiez que le fichier `calculator-1.0-SNAPSHOT.jar` a bien été créé.

---

# Étape 10 : Génération du site de documentation avec `mvn site`

---

1. **Exécutez la commande `mvn site`** pour générer la documentation du projet :
   ```bash
   mvn site
   ```
2. **Vérifiez la génération du site Javadoc** :
   - Après avoir exécuté `mvn site`, Maven génère un site web de documentation dans le répertoire `target/site`. Pour visualiser la documentation Javadoc, ouvrez le fichier `index.html` situé dans `target/site` dans votre navigateur.

---



# Étape 11 : Modifier le test pour introduire une erreur

---

1. **Modifiez le fichier `CalculatorTest.java`** pour introduire une erreur :
   - Changez la valeur du test `testAdd` pour qu'il vérifie que `3 + 5` est égal à `50` au lieu de `8`.
   - Trouvez la méthode `testAdd()` dans `CalculatorTest.java` et remplacez cette ligne :
     ```java
     Assert.assertEquals(8, calculator.add(3, 5));
     ```
     par :
     ```java
     Assert.assertEquals(50, calculator.add(3, 5));
     ```
2. **Exécutez les tests avec la commande `mvn test`** :
   ```bash
   mvn test
   ```
3. **Vérifiez l'échec du test** :
   - Vous verrez que le test `testAdd` échoue, car le résultat attendu est incorrect. Ceci montre comment Maven vous aide à identifier les erreurs dans votre code.

---

# Étape 12 : Corriger l'erreur et re-tester

---

1. **Corrigez l'erreur** en remettant la valeur correcte dans `CalculatorTest.java` :
   - Remplacez :
     ```java
     Assert.assertEquals(50, calculator.add(3, 5));
     ```
     par :
     ```java
     Assert.assertEquals(8, calculator.add(3, 5));
     ```
2. **Recompilez le projet et exécutez les tests** pour vérifier que tout fonctionne correctement :
   ```bash
   mvn compile test
   ```

---

# Étape 13 : Combiner plusieurs commandes Maven

---

1. **Combinez plusieurs commandes Maven** pour compiler, tester, et empaqueter le projet en une seule ligne :
   - Vous pouvez exécuter les commandes `mvn clean compile test package` en une seule fois pour effectuer toutes ces étapes d'un coup, comme cela se fait souvent dans la vraie vie :
     ```bash
     mvn clean compile test package
     ```
2. **Vérifiez les résultats** :
   - Après l'exécution de cette commande, assurez-vous que les tests réussissent, le projet est compilé et le fichier JAR est généré dans le répertoire `target`.
