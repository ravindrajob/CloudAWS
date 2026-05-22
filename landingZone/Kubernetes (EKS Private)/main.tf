################################################################
# Titre: EKS Private Cluster (Hardened)
# Description : Cluster Kubernetes managé sans IP publique pour les nœuds
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ] Initial EKS setup
################################################################

resource "aws_eks_cluster" "primary" {
  name     = "lab-eks-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false # Zéro exposition Internet directe
  }

  # CAF Reference: Control Plane Logging
  enabled_cluster_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  tags = {
    Environment = "Lab"
    ManagedBy   = "Terraform"
  }
}

resource "aws_eks_node_group" "primary_nodes" {
  cluster_name    = aws_eks_cluster.primary.name
  node_group_name = "lab-node-pool"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]

  # CNCF Compliance: Remote Access via Session Manager (No SSH port open)
  remote_access {
    ec2_ssh_key = var.ssh_key_name
  }

  tags = {
    Name = "lab-eks-nodes"
  }
}
