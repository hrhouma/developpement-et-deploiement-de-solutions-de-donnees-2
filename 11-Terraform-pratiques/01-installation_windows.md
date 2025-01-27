---
title: "Pratique 01 - Installation de Terraform sur Windows"
description: "Découvrez comment installer Terraform sur Windows."
emoji: "🚀"
slug: "01-installation_windows"
---


# Installation de Terraform sur Windows


L'installation de Terraform sur Windows est un processus simple. Voici les étapes à suivre pour installer Terraform sur un système Windows :

## Étape 1 : Téléchargement de Terraform

1. Rendez-vous sur la page de téléchargement officielle de Terraform : [Terraform Downloads](https://www.terraform.io/downloads.html).
2. Sélectionnez l'option de téléchargement pour Windows. Le fichier téléchargé sera un fichier ZIP contenant l'exécutable Terraform.

## Étape 2 : Extraction de l'archive ZIP

1. Une fois le fichier ZIP téléchargé, faites un clic droit sur le fichier et sélectionnez **Extraire tout...** pour décompresser le contenu de l'archive.
2. Choisissez un emplacement sur votre disque où vous souhaitez extraire l'exécutable Terraform. Un bon emplacement pourrait être `C:\Program Files\Terraform\`.

## Étape 3 : Ajout de Terraform au PATH

Pour pouvoir exécuter Terraform depuis n'importe quel répertoire dans l'invite de commande, vous devez ajouter le chemin du répertoire contenant l'exécutable Terraform à la variable d'environnement `PATH`.

1. Cliquez avec le bouton droit sur l'icône **Ordinateur** sur le bureau ou dans l'Explorateur de fichiers, puis sélectionnez **Propriétés**.
2. Cliquez sur **Paramètres système avancés** dans le panneau de gauche.
3. Dans la boîte de dialogue **Propriétés système**, cliquez sur le bouton **Variables d'environnement**.
4. Dans la section **Variables système**, faites défiler jusqu'à trouver la variable `Path`, puis sélectionnez-la et cliquez sur **Modifier**.
5. Cliquez sur **Nouveau** et ajoutez le chemin du répertoire où vous avez extrait Terraform, par exemple `C:\Program Files\Terraform\`.
6. Cliquez sur **OK** pour fermer toutes les boîtes de dialogue ouvertes.

## Étape 4 : Vérification de l'installation

Pour vérifier que Terraform est correctement installé et ajouté au PATH :

1. Ouvrez une invite de commande en appuyant sur **Win + R**, tapez `cmd`, puis appuyez sur **Entrée**.
2. Tapez la commande suivante et appuyez sur **Entrée** :
   ```bash
   terraform --version
   ```
   Cette commande doit afficher la version de Terraform que vous avez installée, confirmant ainsi que l'installation a été effectuée avec succès.

## Mise à jour de Terraform

Pour mettre à jour Terraform à une version plus récente, téléchargez simplement la nouvelle version à partir du site officiel et remplacez l'ancien exécutable par le nouveau dans le répertoire où vous avez installé Terraform.

## Options de la commande terraform init

Pour voir toutes les options disponibles, vous pouvez utiliser la commande :



### Conclusion

Vous avez maintenant installé Terraform sur votre système Windows et vous êtes prêt à commencer à écrire et exécuter vos premières configurations d'infrastructure. N'oubliez pas de consulter la documentation officielle de Terraform pour en savoir plus sur son utilisation et ses fonctionnalités avancées.
