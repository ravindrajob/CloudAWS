################################################################
# Titre: ALB & WAF v2 - Observability
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# 1. WAF v2 Logging
resource "aws_wafv2_web_acl_logging_configuration" "waf_logs" {
  log_destination_configs = [var.cloudwatch_log_group_arn_waf]
  resource_arn            = var.waf_acl_arn

  logging_filter {
    default_behavior = "KEEP"

    filter {
      behavior    = "DROP"
      requirement = "MEETS_ANY"
      condition {
        action_condition {
          action = "ALLOW"
        }
      }
    }
  }
}
