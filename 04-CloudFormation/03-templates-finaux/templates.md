

Ces templates sont rédigés en **YAML** et sont utilisés pour déployer différents composants de l’infrastructure du café.



##  **1. Template S3 simple — `S3.yaml`**

> Objectif : Créer un bucket S3 pour un site statique.

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: "cafe S3 template"

Resources:
  S3Bucket:
    Type: AWS::S3::Bucket
    Properties:
      WebsiteConfiguration:
        IndexDocument: index.html
        ErrorDocument: error.html
    DeletionPolicy: Retain

Outputs:
  WebsiteURL:
    Value: !GetAtt S3Bucket.WebsiteURL
    Description: URL of the static website
```

---

## 🔹 **2. Template réseau — `cafe-network.yaml`**

> Objectif : Créer un VPC, une subnet publique, etc. Déclenché automatiquement via **CodePipeline**.

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Network layer for the café

Resources:
  VPC:
    Type: AWS::EC2::VPC
    Properties:
      CidrBlock: 10.0.0.0/16
      Tags:
        - Key: Name
          Value: Cafe VPC

  PublicSubnet:
    Type: AWS::EC2::Subnet
    Properties:
      VpcId: !Ref VPC
      CidrBlock: 10.0.1.0/24
      MapPublicIpOnLaunch: true
      Tags:
        - Key: Name
          Value: Cafe Public Subnet

Outputs:
  PublicSubnet:
    Description: The subnet ID to use for public web servers
    Value: !Ref PublicSubnet
    Export:
      Name: !Sub "${AWS::StackName}-SubnetID"

  VpcId:
    Description: The VPC ID
    Value: !Ref VPC
    Export:
      Name: !Sub "${AWS::StackName}-VpcID"
```



##  **3. Template application — `cafe-app.yaml`**

> Objectif : Déployer un serveur EC2 configuré pour héberger une application web dynamique.

```yaml
AWSTemplateFormatVersion: "2010-09-09"
Description: Deploy the Cafe dynamic website

Parameters:
  LatestAmiId:
    Type: AWS::SSM::Parameter::Value<AWS::EC2::Image::Id>
    Default: /aws/service/ami-amazon-linux-latest/amzn2-ami-hvm-x86_64-gp2

  CafeNetworkParameter:
    Type: String
    Default: update-cafe-network

  InstanceTypeParameter:
    Type: String
    Default: t2.small
    Description: EC2 instance types available
    AllowedValues:
      - t2.micro
      - t2.small
      - t3.micro
      - t3.small

Mappings:
  RegionMap:
    us-east-1:
      keypair: vockey
    us-west-2:
      keypair: cafe-oregon

Resources:
  CafeSG:
    Type: AWS::EC2::SecurityGroup
    Properties:
      GroupDescription: Enable HTTP and SSH
      VpcId: !ImportValue 
        'Fn::Sub': '${CafeNetworkParameter}-VpcID'
      SecurityGroupIngress:
        - IpProtocol: tcp
          FromPort: 22
          ToPort: 22
          CidrIp: 0.0.0.0/0
        - IpProtocol: tcp
          FromPort: 80
          ToPort: 80
          CidrIp: 0.0.0.0/0
      Tags:
        - Key: Name
          Value: CafeSG

  CafeInstance:
    Type: AWS::EC2::Instance
    Properties:
      ImageId: !Ref LatestAmiId
      InstanceType: !Ref InstanceTypeParameter
      KeyName: !FindInMap [RegionMap, !Ref "AWS::Region", keypair]
      IamInstanceProfile: CafeRole
      NetworkInterfaces:
        - DeviceIndex: '0'
          AssociatePublicIpAddress: 'true'
          SubnetId: !ImportValue 
            'Fn::Sub': '${CafeNetworkParameter}-SubnetID'
          GroupSet:
            - !Ref CafeSG
      Tags:
        - Key: Name
          Value: Cafe Web Server
      UserData:
        Fn::Base64: !Sub |
          #!/bin/bash
          yum -y update
          yum install -y httpd mariadb-server wget
          amazon-linux-extras install -y lamp-mariadb10.2-php7.2 php7.2
          systemctl enable httpd
          systemctl start httpd
          systemctl enable mariadb
          systemctl start mariadb
          wget https://aws-tc-largeobjects.s3.us-west-2.amazonaws.com/CUR-TF-200-ACACAD-2-91555/14-lab-mod10-challenge-CFn/s3/cafe-app.sh
          chmod +x cafe-app.sh
          ./cafe-app.sh

Outputs:
  WebServerPublicIP:
    Description: Public IP of the EC2 instance
    Value: !GetAtt CafeInstance.PublicIp
```



##  Résumé des templates utilisés :

| Nom du template     | Objectif principal                   | Type de déploiement    |
| ------------------- | ------------------------------------ | ---------------------- |
| `S3.yaml`           | Bucket S3 pour site statique         | CLI (`create-stack`)   |
| `cafe-network.yaml` | VPC, Subnet, exports                 | CI/CD via CodePipeline |
| `cafe-app.yaml`     | Serveur EC2 avec LAMP et script café | CI/CD via CodePipeline |

Souhaites-tu que je te fournisse les **fichiers `.yaml` prêts à copier** ou un dépôt Git avec tous les templates ?
