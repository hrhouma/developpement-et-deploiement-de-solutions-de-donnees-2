<h1 id="examen-mi-session-jenkins-aws">Examen de Mi-Session – Jenkins, AWS (CloudFormation, CodeCommit, CodePipeline) et Git</h1>

**Durée :** 90 minutes
**Type :** Théorique (QCM + courts développements)
**Pondération :** 20 % de la note finale
**Matériel autorisé :** Notes personnelles et documentation en ligne

---

<h2 id="partie-1-qcm-jenkins-et-aws-40-points">Partie 1 – QCM (40 points)</h2>

**Instructions :**
Cochez **une seule réponse correcte par question**, sauf indication contraire. Lisez attentivement chaque énoncé.

---

**1. Dans Jenkins, quel plugin est utilisé pour exécuter un fichier Jenkinsfile défini dans un dépôt Git ?**

a) Git Publisher Plugin

b) Pipeline Plugin

c) NodeJS Plugin

d) SSH Agent Plugin


---

**2. Quel est le rôle principal d’AWS CodeCommit ?**

a) Orchestrer des tâches CI/CD sur le cloud

b) Fournir une base de données NoSQL pour Git

c) Héberger des dépôts Git privés dans AWS

d) Déclencher des alarmes CloudWatch

---

**3. Dans AWS CodePipeline, quelle étape permet l’automatisation du déploiement vers un environnement cible ?**

a) Source

b) Build

c) Deploy

d) Approval

---

**4. Quel fichier est essentiel pour exécuter automatiquement une stack CloudFormation ?**

a) `deploy.sh`

b) `template.yml`

c) `main.tf`

d) `aws.config`

---

**5. Quelle commande Git permet de relier un dépôt local à un dépôt CodeCommit distant ?**

a) `git connect aws`

b) `git remote add origin <url>`

c) `aws codecommit link`

d) `git clone s3://bucket`

---

**6. Quelle ressource est définie dans un template CloudFormation pour créer un repository Git ?**

a) `AWS::CodePipeline::Repository`

b) `AWS::CodeCommit::Repository`

c) `AWS::EC2::GitRepo`

d) `AWS::DevTools::GitService`

---

**7. Dans Jenkins, quel type de déclencheur permet de surveiller automatiquement les commits dans AWS CodeCommit ?**

a) Poll SCM

b) GitHub webhook

c) CloudWatch Event trigger

d) AWS CodeCommit plugin + webhook

---

**8. Quelle option de `git` permet de cloner un seul *branch* spécifique d’un dépôt ?**

a) `git branch --only`

b) `git clone -b <branch> --single-branch <url>`

c) `git fetch branch=<branch>`

d) `git pull branch <branch>`

---

**9. Lequel des services suivants permet de déclencher un pipeline CI/CD sans serveur ?**

a) Jenkins installé sur EC2

b) AWS CodePipeline

c) AWS Lambda uniquement

d) Amazon ECS

---

**10. Parmi les éléments suivants, lesquels peuvent figurer dans un template CloudFormation ?**
(2 bonnes réponses)

a) `Resources`

b) `Modules`

c) `Outputs`

d) `Events`

---

<h2 id="partie-2-analyse-et-conception-60-points">Partie 2 – Analyse et Conception (60 points)</h2>

**Consignes :**
Vous devez expliquer, concevoir ou compléter des extraits liés à un pipeline CI/CD avec Jenkins, AWS CodePipeline, Git et CloudFormation.

---

**11. (10 pts)** Expliquez en 3 à 5 lignes la différence entre **Jenkins** et **AWS CodePipeline** en termes de CI/CD. Donnez un avantage et un inconvénient pour chacun.

---

**12. (10 pts)** Fournissez un exemple simplifié de fichier CloudFormation (`template.yml`) qui permet de créer :

* Un repository CodeCommit
* Un rôle IAM avec permission de pull/push sur ce repository

---

**13. (15 pts)** Complétez le diagramme de déploiement suivant en indiquant l’ordre d’exécution :

* [ ] Déclenchement via commit sur CodeCommit
* [ ] Étape de build Jenkins
* [ ] Déploiement via CloudFormation
* [ ] Validation du commit dans CodePipeline
* [ ] Tests automatisés

Indiquez l’ordre exact (1, 2, 3, etc.) et justifiez les transitions.

---

**14. (15 pts)** Fournissez un extrait de Jenkinsfile qui :

* Clone un dépôt depuis CodeCommit
* Lance une build Node.js
* Déploie via un script CloudFormation

Vous devez inclure les étapes `checkout`, `build` et `deploy`.

---

**15. (10 pts)** Expliquez en quelques lignes pourquoi il est important de versionner les templates d'infrastructure (comme les fichiers `.yml` de CloudFormation) dans un dépôt Git et comment cela s’intègre dans une logique DevOps.



