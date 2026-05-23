################################################################
# Titre: AWS Network Firewall - Observability
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

resource "aws_networkfirewall_logging_configuration" "nfw_logs" {
  firewall_arn = var.firewall_arn
  
  logging_configuration {
    log_destination_config {
      log_destination = {
        logGroup = var.cloudwatch_log_group_name
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "FLOW"
    }

    log_destination_config {
      log_destination = {
        logGroup = var.cloudwatch_log_group_name_alerts
      }
      log_destination_type = "CloudWatchLogs"
      log_type             = "ALERT"
    }
  }
}
