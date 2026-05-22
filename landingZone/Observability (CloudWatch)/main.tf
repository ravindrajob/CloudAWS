################################################################
# Titre: Observability (CloudWatch)
# Description : Monitoring centralisé et VPC Flow Logs
# Auteur: Ravindra JOB | v1.3
# Update: 22/05/2026
################################################################

resource "aws_cloudwatch_log_group" "lab_central_logs" {
  name              = "/lab-aws/central-audit-logs"
  retention_in_days = 30
}

resource "aws_flow_log" "tgw_flow_logs" {
  iam_role_arn    = var.iam_role_arn
  log_destination = aws_cloudwatch_log_group.lab_central_logs.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
}
