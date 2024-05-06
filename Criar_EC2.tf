terraform {
required_providers {
aws = {
source = "hashicorp/aws"
version = "5.48.0"
        }
    }
}

provider "aws" {
region = "us-east-1"
}

# Definição do script de inicialização
variable "custom_data_script" {
default = <<EOF
#!/bin/bash
sudo apt update
docker pull lucasgbueno/itops
# Atualiza os pacotes do sistema para obter o Docker
sudo apt update
# Instalação do Docker Engine
sudo apt install docker-ce docker-ce-cli containerd.io -y
# Gerenciar o Docker como um usuário não root
sudo usermod -aG docker $USER
docker run -p 8080:8080 apicontainer
EOF
}
# Criar EC2 Linux
resource "aws_instance" "linux-docker" {
ami           = "ami-04b70fa74e45c3917" # ubuntu
instance_type = "t2.micro"
key_name      = "vockey" # Não esqueca de gerar a chave  pública e privada para este nome!
associate_public_ip_address = true
user_data = var.custom_data_script
tags = {
    Name = "Linux-Docker"
    }
}