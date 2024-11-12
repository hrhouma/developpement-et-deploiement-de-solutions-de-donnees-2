## 🛠️ Partie 3/15 - Introduction à Maven  - partie 02
---

# 5. Structure du projet

---

Notre projet Maven devra suivre cette structure de répertoires :

```plaintext
CalculatorProject/
|-- pom.xml
-- src/
    |-- main/
    |   -- java/
    |       -- com/
    |           -- example/
    |               -- Calculator.java
    -- test/
        -- java/
            -- com/
                -- example/
                    -- CalculatorTest.java
```


---

### 5.1. Commandes Maven couramment utilisées

Voici un ensemble de commandes Maven couramment utilisées. Ces commandes sont exécutées dans le terminal ou l'invite de commande (cmd) à la racine du projet, où se trouve le fichier `pom.xml`.

- `mvn archetype:generate`
- `mvn compile`
- `mvn test`
- `mvn package`
- `mvn verify`
- `mvn install`
- `mvn deploy`
- `mvn clean`
- `mvn site`
- `mvn dependency:analyze`
- `mvn dependency:update-snapshots`
- **`mkdir`** (Pour créer la structure de répertoires)

Créer cette structure de projet pour un projet Maven peut être effectué de deux manières : (1) manuellement ou (2) en utilisant un outil de ligne de commande comme Maven lui-même. Voici comment vous pouvez procéder dans les deux cas :

---


### 5.2. Création automatique du projet

---

**Générez un projet Maven** en utilisant la commande suivante :

   ```bash
   mvn archetype:generate -DgroupId=com.example -DartifactId=calculator -DarchetypeArtifactId=maven-archetype-quickstart -DinteractiveMode=false
   cd calculator
   ```

# IMPORTANT  !!!: 
- La commande ci-dessus doit être exécuté dans un environnement Unix-Like (par exemple Git Bash)
- Il ne faut pas utiliser la ligne de commande cmd de windows

**Ouvrez le projet dans VS Code** :

   ```bash
   code .
   ```

**Renommer les fichiers App.java et AppTest.java**
**Renommez les fichiers** suivants :
   - `App.java` → `Calculator.java`
   - `AppTest.java` → `CalculatorTest.java`


------

# 6. Calculator.java

Assurez vous d'avoir crée le fichier `Calculator.java` dans le répertoire `src/main/java/com/example/` :

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

# 7. CalculatorTest.java

Créez le fichier `CalculatorTest.java` dans le répertoire `src/test/java/com/example/` :

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

# 8. pom.xml

Fichier `pom.xml` qui configure notre projet pour utiliser JUnit 4.12 pour les tests :

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

# 9. Exécution des commandes Maven

Vous pouvez exécuter les commandes Maven mentionnées précédemment dans le terminal ou CMD à la racine du projet (`CalculatorProject`), là où se trouve le fichier `pom.xml`.

- **Compiler le projet :** `mvn compile`
- **Exécuter les tests unitaires :** `mvn test`
- **Construire le projet (incluant les tests) :** `mvn package`
- **Nettoyer le projet :** `mvn clean`
- **Installer le projet dans le référentiel local Maven :** `mvn install`
- **Générer un site pour le projet :** `mvn site`



---

# 10. Combinaison de commandes Maven

Dans les projets réels, il est courant de combiner plusieurs commandes Maven pour automatiser plusieurs étapes du cycle de vie du build en une seule commande. Par exemple, vous pouvez vouloir nettoyer le projet, compiler le code, exécuter les tests, et installer le package dans le dépôt local, le tout en une seule commande. Voici comment vous pouvez le faire :

#### Combinaison de commandes Maven

```bash
mvn clean install
```

Cette commande exécute les actions suivantes :

1. **`mvn clean`** : Supprime le répertoire `target`, nettoyant ainsi tous les fichiers générés lors des builds précédents.
2. **`mvn install`** : Compile le projet, exécute les tests unitaires, package le projet, puis l'installe dans le dépôt local Maven.

L'avantage de combiner les commandes est de pouvoir effectuer plusieurs tâches consécutives sans avoir à exécuter chaque commande individuellement, ce qui est non seulement un gain de temps, mais assure également que toutes les étapes nécessaires sont exécutées de manière cohérente.

Vous pouvez également combiner d'autres commandes selon vos besoins. Par exemple :

```bash
mvn clean compile package
```

Cela nettoie le projet, compile le code, et package le code compilé en un fichier JAR ou WAR.

Cette flexibilité de Maven vous permet d'adapter le processus de build à vos besoins spécifiques, tout en maintenant la simplicité et l'efficacité dans le développement de projets Java.

---

# Conclusion

En suivant le cycle de vie Maven, en comprenant la structure du projet, et en utilisant les commandes Maven courantes, vous pouvez gérer vos projets Java de manière plus efficace. Maven ne simplifie pas seulement le processus de build, mais impose également des bonnes pratiques et une standardisation, facilitant ainsi la collaboration au sein des équipes sur des projets complexes.


----------------------
# Annexe optionnel : 
----------------------


### 5.2. Création manuelle du projet

Pour créer manuellement la structure de dossiers, vous suivez les étapes dans l'explorateur de fichiers de votre système d'exploitation ou via le terminal/invite de commandes :

1. **Créer la structure de dossiers :**  
   Utilisez des commandes `mkdir` dans le terminal (Linux/macOS) ou l'invite de commandes (Windows) pour créer tous les dossiers nécessaires. Voici comment vous pourriez le faire sur un système Unix-like (Linux/macOS) :

   ```bash
   mkdir -p CalculatorProject/src/main/java/com/example
   mkdir -p CalculatorProject/src/test/java/com/example
   ```

   Sur Windows, vous devriez créer chaque dossier un par un via l'explorateur de fichiers ou l'invite de commandes avec `mkdir`.

2. **Créer les fichiers :**  
   Utilisez un éditeur de texte pour créer `Calculator.java` et `CalculatorTest.java` dans leurs dossiers respectifs, puis copiez-collez le code fourni. Créez également le fichier `pom.xml` à la racine du projet (`CalculatorProject/`).
