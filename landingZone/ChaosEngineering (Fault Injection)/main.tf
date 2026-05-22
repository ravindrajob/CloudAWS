################################################################
# Titre: ChaosEngineering (Fault Injection Simulator)
# Description : Scénarios de pannes managées (Stop instances, Throttle API)
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

# 1. AWS FIS Template (CAF: Reliability Pillar)
resource "aws_fis_experiment_template" "node_failure" {
  description = "Simulation de perte de nœuds EKS"
  role_arn    = var.fis_role_arn

  stop_condition {
    source = "none"
  }

  action {
    name      = "stop-eks-nodes"
    action_id = "aws:ec2:stop-instances"
    
    target {
      key   = "Instances"
      value = "eks-node-target"
    }
    
    parameter {
      key   = "startInstancesAfterDuration"
      value = "PT5M"
    }
  }

  target {
    name           = "eks-node-target"
    resource_type  = "aws:ec2:instance"
    selection_mode = "PERCENT(50)"
    
    resource_tag {
      key   = "Environment"
      value = "Lab"
    }
  }
}
