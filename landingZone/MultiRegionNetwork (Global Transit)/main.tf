################################################################
# Titre: Multi-Region Network (Global Transit)
# Description : Mesh global (Netflix style) entre régions AWS
# Auteur: Ravindra JOB | v2.0
# Update: 23/05/2026
################################################################

provider "aws" {
  alias  = "eu_west_1"
  region = "eu-west-1" # Paris
}

provider "aws" {
  alias  = "eu_central_1"
  region = "eu-central-1" # Francfort (DRP)
}

# TGW Region 1
resource "aws_ec2_transit_gateway" "tgw_primary" {
  provider    = aws.eu_west_1
  description = "TGW Primary Region"
  amazon_side_asn = 65001
}

# TGW Region 2
resource "aws_ec2_transit_gateway" "tgw_drp" {
  provider    = aws.eu_central_1
  description = "TGW DRP Region"
  amazon_side_asn = 65002
}

# Peering Inter-Region (Chiffrement natif sur le backbone AWS)
resource "aws_ec2_transit_gateway_peering_attachment" "global_mesh" {
  provider                = aws.eu_west_1
  peer_account_id         = var.account_id
  peer_region             = "eu-central-1"
  peer_transit_gateway_id = aws_ec2_transit_gateway.tgw_drp.id
  transit_gateway_id      = aws_ec2_transit_gateway.tgw_primary.id

  tags = {
    Name = "Global-TGW-Mesh"
  }
}
