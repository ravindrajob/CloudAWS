################################################################
# Titre: Self-Service - AWS App Pattern Standard
# Description: Modèle "Golden Path" pour une application AWS
# Auteur: Ravindra JOB | v2.0
################################################################

# 1. Isolation VPC Optionnelle (ou utilisation du Shared VPC)
resource "aws_vpc" "app_vpc" {
  cidr_block = "10.100.0.0/16"
  tags = {
    Name        = "vpc-${var.app_name}-${lower(var.environment)}"
    Environment = var.environment
    ManagedBy   = "SelfServicePortal"
    AutoStop    = var.environment == "Prod" ? "False" : "True"
  }
}

# 2. KMS Key Dédiée pour l'App
resource "aws_kms_key" "app_cmk" {
  description             = "CMK pour ${var.app_name} ${var.environment}"
  deletion_window_in_days = 30
  enable_key_rotation     = true
}

# 3. Bucket S3 chiffré et verrouillé
resource "aws_s3_bucket" "app_bucket" {
  bucket = "s3-${var.app_name}-${lower(var.environment)}-${var.random_suffix}"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "app_crypto" {
  bucket = aws_s3_bucket.app_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = aws_kms_key.app_cmk.arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# 4. Modules Optionnels
module "eks_cluster" {
  source = "../../landingZone/Kubernetes (EKS Private)"
  count  = var.enable_eks ? 1 : 0
  
  vpc_id = aws_vpc.app_vpc.id
}

module "rds_database" {
  source = "../../landingZone/Workloads (VPC Spokes)" # Représentation DB tier
  count  = var.enable_database ? 1 : 0
  
  vpc_id = aws_vpc.app_vpc.id
}
