################################################################
# Titre: AWS Direct Connect (Hybrid Connectivity)
# Description : Liaison privée dédiée pour le Cloud AWS
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

# 1. Direct Connect Connection (CAF: Connectivity Foundation)
resource "aws_dx_connection" "on_prem" {
  name            = "dx-lab-connection"
  bandwidth       = "1Gbps"
  location        = "EqPa2" # Equinix Paris
  provider_name   = "Equinix"
}

# 2. Direct Connect Gateway (Orchestration multi-VPC)
resource "aws_dx_gateway" "main" {
  name            = "dx-gw-lab"
  amazon_side_asn = "64512"
}

# 3. Association vers le Transit Gateway (TGW)
resource "aws_dx_gateway_association" "tgw" {
  dx_gateway_id         = aws_dx_gateway.main.id
  associated_gateway_id = var.transit_gateway_id
}
