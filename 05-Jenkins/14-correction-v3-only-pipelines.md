### **Exemples de Pipelines**

*Ces pipelines couvrent plusieurs scénarios et plateformes, et vous pouvez les adapter en fonction de vos besoins.*

---

# **Pipeline 1 : Jenkinsfile Générique**
```groovy
pipeline {
    agent any
    environment {
        PATH = "${env.PATH}:/usr/bin/python3" // Linux : Inclure Python 3 dans le PATH
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
            }
        }
        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        sh 'echo "Running on Unix"'
                        // Add your Unix-specific build commands here
                    } else {
                        bat 'echo "Running on Windows"'
                        // Add your Windows-specific build commands here
                    }
                }
            }
        }
    }
}
```

---

# **Pipeline 2 : Version Windows**
```groovy
pipeline {
    agent any
    environment {
        JAVA_HOME = 'C:\\Program Files\\Java\\jdk1.8.0_202'
        PYTHON_HOME = 'C:\\Users\\rehou\\AppData\\Local\\Microsoft\\WindowsApps'
        PATH = "${env.PATH};${JAVA_HOME}\\bin;${PYTHON_HOME}"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
            }
        }
        stage('Build') {
            steps {
                script {
                    bat 'echo "Running on Windows"'
                    bat 'javac HelloWorld.java'
                    bat 'java HelloWorld'
                    bat 'python hello.py'
                }
            }
        }
    }
}
```

---

# **Pipeline 3 : Version Linux**
```groovy
pipeline {
    agent any
    environment {
        JAVA_HOME = '/usr/lib/jvm/java-8-openjdk-amd64'
        PATH = "${env.PATH}:${JAVA_HOME}/bin:/usr/bin"
    }
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
            }
        }
        stage('Build') {
            steps {
                script {
                    sh 'echo "Running on Unix"'
                    sh 'javac HelloWorld.java'
                    sh 'java HelloWorld'
                    sh 'python3 hello.py'
                }
            }
        }
    }
}
```

---

# **Pipeline 4 : Versions Linux et Windows (2-en-1)**
```groovy
pipeline {
    agent any
    stages {
        stage('Checkout') {
            steps {
                git branch: 'main', url: 'https://github.com/hrhouma/hello-python.git'
            }
        }
        stage('Build') {
            steps {
                script {
                    if (isUnix()) {
                        withEnv([
                            "JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64",
                            "PYTHON_HOME=/usr/bin",
                            "PATH=${env.PATH}:${JAVA_HOME}/bin:${PYTHON_HOME}"
                        ]) {
                            sh 'echo "Running on Unix"'
                            sh 'javac HelloWorld.java'
                            sh 'java HelloWorld'
                            sh 'python3 hello.py'
                        }
                    } else {
                        withEnv([
                            "JAVA_HOME=C:\\Program Files\\Java\\jdk1.8.0_202",
                            "PYTHON_HOME=C:\\Users\\rehou\\AppData\\Local\\Microsoft\\WindowsApps",
                            "PATH=${env.PATH};${JAVA_HOME}\\bin;${PYTHON_HOME}"
                        ]) {
                            bat 'echo "Running on Windows"'
                            bat 'javac HelloWorld.java'
                            bat 'java HelloWorld'
                            bat 'python hello.py'
                        }
                    }
                }
            }
        }
    }
}
``` 


