---
title: "Pratique 11 - Création d'une instance EC2"
description: "Découvrez comment créer une instance EC2 dans deux régions différentes avec Terraform."
emoji: "💻"
slug: "11-creation-instance-ec2"
sidebar_position: 11
---

# Création d'une instance EC2

## 01 - Objectif : 
Dans cette pratique, nous allons créer une instance EC2 dans deux régions différentes avec Terraform. Nous allons aborder plusieurs points importants :

- L'importance des paramètres régionaux et leur impact sur le déploiement
- La spécificité des IDs d'AMI qui ne sont valides que dans leur région d'origine
- Les bonnes pratiques concernant l'utilisation des caractères spéciaux (é, è, à, etc.) dans les descriptions
- La nécessité d'ajouter et de configurer correctement les clés SSH
- La gestion des erreurs courantes liées aux configurations régionales

Cette pratique vous permettra de maîtriser les bases du déploiement multi-régions avec Terraform tout en évitant les pièges classiques.


Dans cette section, nous allons :

1. Commencer par déployer une instance EC2 dans la région `us-west-2` (Oregon)
2. Reproduire ensuite le même déploiement dans la région `us-east-1` (Virginie du Nord)

Cette approche multi-régions nous permettra de :
- Comprendre les spécificités de chaque région
- Maîtriser la gestion des AMIs qui diffèrent selon les régions
- Appliquer les bonnes pratiques de déploiement Terraform

:::tip Conseil
Pensez à bien vérifier les IDs des AMIs qui sont uniques à chaque région avant de déployer.
:::

## 02 - Création du fichier de configuration main.tf
```hcl
provider "aws" {
  region = "us-west-2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-05134c8ef96964280"  
}

variable "instance_name" {
  default = "MyExampleInstance"
}

resource "aws_security_group" "haythem_sg" {
  name        = "haythem-sg"
  description = "Groupe de securite pour linstance EC2 example"

  # Autoriser l'acces SSH depuis n'importe quelle adresse IP
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le trafic HTTP depuis n'importe quelle adresse IP
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Autoriser le trafic HTTPS depuis n'importe quelle adresse IP
  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Regle de sortie par defaut (tout autoriser)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Ressource d'instance EC2
resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = "demo2"

  # Associer le groupe de securite à l'instance
  vpc_security_group_ids = [aws_security_group.haythem_sg.id]

  # Nom de l'instance
  tags = {
    Name = var.instance_name
  }

  # Indiquer à Terraform d'attendre que l'instance soit entierement lancee
  provisioner "local-exec" {
    command = "echo ${self.public_ip} > instance_ip.txt"
  }
}

# Sortie pour afficher l'adresse IP publique
output "instance_ip" {
  description = "L'adresse IP publique de l'instance EC2"
  value       = aws_instance.example.public_ip
}

# Sortie pour afficher l'ID de l'instance
output "instance_id" {
  description = "L'ID de l'instance EC2"
  value       = aws_instance.example.id
}

# Sortie pour afficher l'URL d'acces HTTP
output "instance_url" {
  description = "L'URL HTTP pour acceder à l'instance EC2"
  value       = "http://${aws_instance.example.public_ip}"
}
```

## 03 - Déploiement de l'instance EC2 dans la région us-west-2

➜ *Pour déployer l'instance EC2 dans la région us-west-2, exécutez les commandes suivantes :*

```bash
terraform init
terraform apply --auto-approve
```
➜ *Pour détruire l'instance EC2 dans la région us-west-2, exécutez la commande suivante :*
```bash
terraform destroy --auto-approve
```

:::tip
```bash
terraform init
terraform apply --auto-approve
terraform destroy --auto-approve
```
:::

# ⚠️ Troubleshooting ⚠️
:::danger clé
- Il faut créer une clé et l'ajouter dans le même dossier.
- Assurez-vous que la clé SSH est présente dans le répertoire de travail
- Vérifiez que les permissions de la clé sont correctes (chmod 400)
- Confirmez que le nom de la clé correspond à celui spécifié dans la configuration
- Validez que la clé est au format approprié (.pem pour AWS)
:::
:::danger id ami
- Il faut changer l'id de l'ami par un id valide.
:::

:::danger code non ASCII
- Il faut faire attention par rapport à l'utilisation du code non ASCII 
comme (' é , è, etc ..) surtout dans les descriptions.
:::
:::danger clé sans extension dans le fichier de configuration
- Il faut spécifier la clé sans l'extension .pem
:::
:::danger bucket s3
- Si vous travaillez avec un bucket s3, il faut que le nom soit unique.
:::
:::danger région
- être prudent par rapport à la région (clé)
:::
:::danger id ami
- ami-0e86e20dae9224db8 ➜ ubuntu us-east-1
- ami-05134c8ef96964280 ➜ ubuntu us-west-2
:::


# Commandes essentielles

Les commandes principales pour gérer votre infrastructure Terraform sont :

- `terraform init` 
- `terraform apply --auto-approve` : Applique les changements sans confirmation
- `terraform destroy --auto-approve` : Détruit l'infrastructure sans confirmation




