---
title: "Pratique 05 - Terraform Plan"
description: "Découvrez la commande `terraform plan` et son rôle dans le workflow Terraform."
emoji: "🚀"
slug: "05-terraform_plan"
sidebar_position: 5

---

# terraform plan

La commande `terraform plan` est utilisée pour générer un plan d'exécution détaillant les changements que Terraform propose d'apporter à l'infrastructure. C'est une étape cruciale pour valider les modifications avant de les appliquer.

## Fonctionnalités de `terraform plan`

- **Visualisation des changements** : `terraform plan` montre ce qui sera créé, modifié ou détruit.
- **Prévention des erreurs** : Elle permet de vérifier la configuration avant de l'appliquer, réduisant ainsi le risque d'erreurs.
- **Plan d'exécution** : La commande génère un fichier de plan d'exécution qui peut être utilisé par `terraform apply` pour appliquer les changements sans autre confirmation.

## Exemple d'utilisation

```bash
terraform plan
```

Cela affichera les changements prévus par Terraform.

## Options principales de terraform plan

*Les options principales qui sont disponibles avec la commande `terraform plan` sont listées ci-dessous :*

- `--help` : Affiche l'aide pour la commande `terraform plan` et liste toutes les options disponibles ➜ `terraform plan --help`
- `--detailed-exitcode` : Retourne un code de sortie différent en fonction de l'état du plan ➜ `terraform plan --detailed-exitcode`
- `--out=FILE` : Enregistre le plan dans un fichier au lieu de l'afficher ➜ `terraform plan --out=FILE`
- `--refresh=false` : Désactive la mise à jour des ressources avant le plan ➜ `terraform plan --refresh=false`
- `--target=resource` : Planifie uniquement les ressources spécifiées ➜ `terraform plan --target=resource`
- `--var-file=FILE` : Spécifie un fichier de variables supplémentaire ➜ `terraform plan --var-file=FILE`
- `--var=key=value` : Définit une variable supplémentaire ➜ `terraform plan --var=key=value`
- `--var-file=FILE` : Spécifie un fichier de variables supplémentaire ➜ `terraform plan --var-file=FILE`
- `--destroy` : Planifie la destruction des ressources ➜ `terraform plan --destroy`
- `--input=false` : Désactive les entrées utilisateur ➜ `terraform plan --input=false`
- `--lock=false` : Désactive le verrouillage de l'état ➜ `terraform plan --lock=false`
- `--lock-timeout=0s` : Durée d'attente pour le verrouillage de l'état ➜ `terraform plan --lock-timeout=0s`
- `--no-color` : Désactive la coloration du terminal ➜ `terraform plan --no-color`
- `--out=FILE` : Enregistre le plan dans un fichier au lieu de l'afficher ➜ `terraform plan --out=FILE`
- `--refresh=false` : Désactive la mise à jour des ressources avant le plan ➜ `terraform plan --refresh=false`
- `--target=resource` : Planifie uniquement les ressources spécifiées ➜ `terraform plan --target=resource`
- `--var=key=value` : Définit une variable supplémentaire ➜ `terraform plan --var=key=value`
- `--var-file=FILE` : Spécifie un fichier de variables supplémentaire ➜ `terraform plan --var-file=FILE`


### Exemple avec options

```bash
terraform plan --detailed-exitcode --out=plan.tfplan --refresh=false --target=resource --var-file=FILE --var=key=value
```


### Conclusion

`terraform plan` est une commande clé pour valider les changements avant leur application. Elle offre une vue claire des actions que Terraform s'apprête à effectuer sur l'infrastructure.
