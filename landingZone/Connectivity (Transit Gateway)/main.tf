################################################################
# Titre: AWS Connectivity (Transit Gateway)
# Description : Hub de transit centralisé pour topologie Hub-and-Spoke
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 15/09/2025 [v1.0 | RJ] Initial TGW setup
################################################################

# 1. Transit Gateway (CAF: Connectivity Pillar)
resource "aws_ec2_transit_gateway" "main_tgw" {
  description                     = "Hub de transit central pour l'organisation ravindra-job.com"
  default_route_table_association = "enable"
  default_route_table_propagation = "enable"
  auto_accept_shared_attachments  = "enable"

  tags = {
    Name = "lab-aws-tgw-hub"
  }
}

# 2. VPC Hub (Shared Services & Transit)
resource "aws_vpc" "hub_vpc" {
  cidr_block           = "10.100.0.0/16"
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "lab-aws-hub-vpc"
  }
}

# 3. Sortie Internet Sécurisée (CAF: Infrastructure Foundation)
# Utilisation du NAT Gateway centralisé dans le Hub
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.hub_vpc.id
}

resource "aws_eip" "nat_ip" {
  vpc = true
}

resource "aws_nat_gateway" "central_nat" {
  allocation_id = aws_eip.nat_ip.id
  subnet_id     = aws_subnet.public_transit.id

  tags = {
    Name = "lab-aws-hub-nat"
  }
}
