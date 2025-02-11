## **Exercice 4 - Débogage Terraform : Création d'une instance EC2 multi-régions**  

**Votre mission :**  
- Identifiez les erreurs dans les 5 configurations Terraform  
- Expliquez pourquoi ces erreurs sont problématiques  
- Proposez une correction
- Suivez les exemples des corrections des configurations 3 et 5 (Je fournis la solution). **Cependant, ces configurations ne sont pas incluses dans l'examen. Seules les configurations 1, 2 et 4 sont évaluées.**

---

## **Configuration 1**  

```hcl
provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "example" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t2.micro"
}
```

# **Questions :**  
1. Que manque-t-il dans cette configuration pour la rendre fonctionnelle ?  
2. Pourquoi cette erreur est-elle problématique ?  
3. Proposez une correction.  

---

## **Configuration 2**  


```hcl
variable "ami_id" {
  type    = string
}

resource "aws_instance" "example" {
  ami           = ami_id
  instance_type = "t2.micro"
}
```

# **Questions :**  
1. Cette configuration fonctionnera-t-elle ? Pourquoi ?  
2. Quelle erreur empêche Terraform d'exécuter ce code ?  
3. Proposez une correction.  

---

## **Configuration 3**  


```hcl
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Groupe de sécurité pour l'instance EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = "0.0.0.0/0"
  }
}
```

# **Questions :**  
1. Cette configuration de groupe de sécurité est-elle correcte ? Pourquoi ?  
2. Quelle erreur de syntaxe empêche Terraform de l'exécuter ?  
3. Proposez une correction.  

---

## **Configuration 4**  


```hcl
resource "aws_instance" "example" {
  ami           = "ami-05134c8ef96964280"
  instance_type = "t2.micro"
  key_name      = "demo-key.pem"
}
```

# **Questions :**  
1. Quel est le problème avec la clé SSH ?  
2. Pourquoi cette erreur est-elle problématique ?  
3. Comment pouvez-vous corriger cette configuration ?  

---

## **Configuration 5**  


```hcl
provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
  default = "ami-05134c8ef96964280"
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
}
```

# **Questions :**  
1. Cette configuration fonctionnera-t-elle ? Pourquoi ?  
2. Quelle est l'erreur liée aux régions AWS ?  
3. Proposez une correction en adaptant l'ID d'AMI.  

---

### **Annexe 1 - Réseau AWS utilisé dans l'exercice**

```
                          +----------------------+
                          |    Terraform CLI     |
                          |      Localhost       |
                          |  AWS Credentials OK  |
                          +----------------------+
                                     |
                                     |
        ------------------------------------------------
        |                                      |
+------------------+                 +------------------+
|  us-west-2 (Oregon) |                 |  us-east-1 (Virginia) |
|   AMI: ami-05134c.. |                 |   AMI: ami-0e86e2..   |
+------------------+                 +------------------+
```


### Annexe 2 - Correction des configurations 3 et 5

### **Correction 3 - Mauvaise configuration du groupe de sécurité**
```hcl
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Groupe de sécurité pour l'instance EC2"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  # Correction : liste
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
```

---

### **Correction 5 - Mauvaise gestion des régions et des IDs d'AMI**
```hcl
provider "aws" {
  region = "us-east-1"
}

variable "ami_id" {
  default = "ami-0e86e20dae9224db8"  # Correction : ID valide pour us-east-1
}

resource "aws_instance" "example" {
  ami           = var.ami_id
  instance_type = "t2.micro"
  key_name      = "my-key"
}
```
