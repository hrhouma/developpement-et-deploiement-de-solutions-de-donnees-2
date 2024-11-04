# Workflow de CloudFormation

Le **workflow CloudFormation** décrit les étapes pour créer, mettre à jour, et supprimer des stacks dans AWS. Comprendre ce workflow est essentiel pour gérer efficacement l’infrastructure en tant que code, automatiser les déploiements, et maintenir les configurations d’infrastructure. Cette section présente les principales étapes du workflow CloudFormation, avec des explications détaillées et des exemples d’utilisation.

---

## 1. Initialisation du Template

Avant de déployer une stack CloudFormation, il est important de préparer le template. Cela inclut la définition des ressources, des paramètres, des mappages, et des sorties.

### Bonnes Pratiques :
- **Valider le Template** : Utilisez `aws cloudformation validate-template` pour vérifier la syntaxe et la validité du template avant de le déployer.
- **Organiser les Sections** : Inclure des sections comme `Parameters`, `Resources`, et `Outputs` pour une configuration flexible et lisible.

**Exemple : Validation du Template**

```bash
aws cloudformation validate-template --template-body file://my-template.yaml
```

---

## 2. Créer une Stack (`create-stack`)

La création d’une stack est la première étape dans le déploiement d’une infrastructure. En utilisant la commande `create-stack`, CloudFormation lit le template et crée toutes les ressources spécifiées.

```bash
aws cloudformation create-stack --stack-name MyStack --template-body file://my-template.yaml --parameters ParameterKey=InstanceType,ParameterValue=t2.micro
```

### Options Courantes :
- **--stack-name** : Le nom de la stack.
- **--template-body** : Le chemin vers le template CloudFormation.
- **--parameters** : Les valeurs des paramètres dynamiques définis dans le template.

> **Remarque** : Si le template est stocké sur S3, utilisez `--template-url` au lieu de `--template-body`.

---

## 3. Vérifier l’État de la Stack (`describe-stacks`)

Une fois la stack créée, vous pouvez vérifier son état pour voir si toutes les ressources ont été déployées correctement. La commande `describe-stacks` fournit des informations sur l’état et les ressources de la stack.

```bash
aws cloudformation describe-stacks --stack-name MyStack
```

### États de la Stack :
- **CREATE_IN_PROGRESS** : La stack est en cours de création.
- **CREATE_COMPLETE** : La stack a été créée avec succès.
- **CREATE_FAILED** : Une erreur est survenue lors de la création.

---

## 4. Mettre à Jour une Stack (`update-stack`)

Pour modifier une stack existante, utilisez la commande `update-stack`. Cela permet de mettre à jour les configurations, d’ajouter de nouvelles ressources ou de modifier des propriétés existantes.

```bash
aws cloudformation update-stack --stack-name MyStack --template-body file://updated-template.yaml --parameters ParameterKey=InstanceType,ParameterValue=t2.small
```

### Remarques :
- CloudFormation applique uniquement les changements nécessaires, sans recréer l’ensemble des ressources.
- En cas de mise à jour échouée, CloudFormation restaure automatiquement la stack à son état précédent.

> **Conseil** : Avant de lancer une mise à jour, utilisez `create-change-set` pour prévisualiser les changements (voir section suivante).

---

## 5. Prévisualiser les Modifications avec un Change Set (`create-change-set`)

Les **change sets** permettent de voir les modifications qu’une mise à jour va apporter à une stack avant de les appliquer. Cela est particulièrement utile pour éviter les changements inattendus.

```bash
aws cloudformation create-change-set --stack-name MyStack --template-body file://updated-template.yaml --change-set-name MyChangeSet
```

**Appliquer un Change Set**

```bash
aws cloudformation execute-change-set --change-set-name MyChangeSet --stack-name MyStack
```

> **Remarque** : Un change set vous montre quelles ressources seront ajoutées, modifiées ou supprimées avant d’exécuter les changements.

---

## 6. Supprimer une Stack (`delete-stack`)

La suppression d’une stack retire toutes les ressources associées dans AWS. Utilisez cette commande avec précaution, car elle supprime définitivement l’infrastructure.

```bash
aws cloudformation delete-stack --stack-name MyStack
```

### Remarque :
- CloudFormation supprime toutes les ressources créées par la stack, sauf si elles ont été marquées pour une conservation (par exemple, en utilisant le **Retain** pour certaines ressources comme les buckets S3).

---

## Tableau Récapitulatif des Commandes Essentielles du Workflow

```
+--------------------------+-------------------------------------------------------------+
| Commande                 | Description                                                 |
+--------------------------+-------------------------------------------------------------+
| validate-template        | Vérifier la validité syntaxique d’un template               |
+--------------------------+-------------------------------------------------------------+
| create-stack             | Créer une nouvelle stack avec un template                   |
+--------------------------+-------------------------------------------------------------+
| describe-stacks          | Afficher les détails et l'état d’une stack                  |
+--------------------------+-------------------------------------------------------------+
| update-stack             | Mettre à jour une stack existante                           |
+--------------------------+-------------------------------------------------------------+
| create-change-set        | Créer un change set pour prévisualiser les modifications    |
+--------------------------+-------------------------------------------------------------+
| execute-change-set       | Exécuter un change set pour appliquer les modifications     |
+--------------------------+-------------------------------------------------------------+
| delete-stack             | Supprimer une stack et ses ressources                       |
+--------------------------+-------------------------------------------------------------+
```

---

## Bonnes Pratiques pour le Workflow CloudFormation

1. **Valider les Templates Avant le Déploiement** : Assurez-vous que le template est valide pour éviter les erreurs lors de la création de la stack.
2. **Utiliser les Change Sets pour les Mises à Jour** : Prévisualisez les changements pour minimiser les risques de perturbations.
3. **Surveiller les États des Stacks** : Utilisez `describe-stacks` pour suivre l’état et détecter rapidement les erreurs.
4. **Planifier les Suppressions avec Précaution** : Supprimer une stack entraîne la suppression de toutes les ressources associées. Vérifiez bien avant d'exécuter `delete-stack`.

---

En suivant ce workflow, vous pouvez créer, gérer, et maintenir efficacement votre infrastructure AWS avec CloudFormation. La maîtrise de ces étapes garantit des déploiements plus fiables et une gestion facilitée de l'infrastructure en tant que code.
