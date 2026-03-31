terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1" # Regiunea Stocholm
}

# --- GENERARE CHEIE SSH LOCALĂ ---

resource "tls_private_key" "vm_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key-vms"
  public_key = tls_private_key.vm_key.public_key_openssh
}

resource "local_file" "private_key" {
  content         = tls_private_key.vm_key.private_key_pem
  filename        = "${path.module}/aws_vms.pem"
  file_permission = "0600"
}

# --- CONFIGURARE REȚEA (VPC, Subnet, IGW, Route Table) ---

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_hostnames = true
  tags                 = { Name = "terraform-vpc" }
}

resource "aws_subnet" "public" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags                    = { Name = "public-subnet" }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public_assoc" {
  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public_rt.id
}

# --- SECURITATE (Firewall) ---

resource "aws_security_group" "web_ssh_sg" {
  name        = "allow_web_and_ssh"
  description = "Permite SSH si HTTP"
  vpc_id      = aws_vpc.main.id

  # SSH (Port 22)
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # HTTP (Port 80) pentru Nginx
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Outbound (Acces total la internet pentru instalari)
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# --- DEFINIRE INSTANȚE (VMS) ---

locals {
  vms = {
    "prod-host"      = { type = "t3.small" }
    "stage-host"     = { type = "t3.small" }
    "automation-host" = { type = "t3.small" }
  }
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"] # Debian Official
  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }
}

resource "aws_instance" "vm" {
  for_each               = local.vms
  ami                    = data.aws_ami.debian.id
  instance_type          = each.value.type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web_ssh_sg.id]
  key_name               = aws_key_pair.deployer.key_name

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  # SCRIPT AUTOMATIZARE (Cloud-init)
  user_data = <<-EOF
    #cloud-config
    hostname: ${each.key}
    package_update: true
    package_upgrade: true
    packages:
      - curl
      - nginx
    
    runcmd:
      # Instalare Docker
      - curl -fsSL https://get.docker.com -o get-docker.sh
      - sh get-docker.sh
      - usermod -aG docker admin
      
      # Start servicii
      - systemctl enable --now nginx
      - systemctl enable --now docker

      # Pagina custom de test
      - echo "<h1>Host: ${each.key}</h1><p>Docker & Nginx instalate prin Terraform.</p>" > /var/www/html/index.html
  EOF

  tags = { Name = each.key }
}

# --- DATE DE IEȘIRE ---

output "instante_active" {
  description = "Detalii despre instanțele create"
  value = {
    for name, instance in aws_instance.vm :
    name => {
      public_ip = instance.public_ip
      ssh_cmd   = "ssh -i aws_vms.pem admin@${instance.public_ip}"
      url       = "http://${instance.public_ip}"
    }
  }
}