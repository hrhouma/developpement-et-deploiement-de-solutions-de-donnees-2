# Principes de Base de CloudFormation

CloudFormation est un service AWS puissant qui permet de gérer l'infrastructure sous forme de code (Infrastructure as Code - IaC), facilitant ainsi le déploiement, la gestion et la mise à jour des ressources AWS de manière cohérente et automatisée. Avant d'approfondir les concepts spécifiques, il est essentiel de comprendre les principes de base de CloudFormation, qui incluent la structure des templates, la logique de déploiement d'infrastructure et la gestion des ressources.

### Objectifs des Principes de Base

1. **Comprendre le Déploiement d'Infrastructure en tant que Code** :
   - Appréhender le concept de stacks et comment CloudFormation regroupe les ressources AWS dans une entité unique pour simplifier la gestion de l’infrastructure.

2. **Découvrir les Templates CloudFormation** :
   - Apprendre la structure et la syntaxe des templates CloudFormation (YAML ou JSON), qui sont les fondations de toute stack.

3. **Appliquer les Bonnes Pratiques de Configuration** :
   - Structurer les templates pour garantir leur adaptabilité, leur maintenance et leur réutilisation, avec une gestion facilitée des configurations complexes.

### Concepts Clés

- **Stacks** : Une stack est un ensemble de ressources AWS définies par un template CloudFormation et déployées ensemble. Les stacks permettent de créer, mettre à jour et supprimer des ressources en une seule action.
  
- **Templates** : Les templates décrivent la configuration de l’infrastructure. Ils incluent des sections essentielles comme Parameters, Resources et Outputs, permettant de personnaliser les déploiements et d’exporter des informations vers d'autres services.

Ces bases sont fondamentales pour maîtriser CloudFormation et en tirer le meilleur parti dans la gestion de l'infrastructure AWS.
