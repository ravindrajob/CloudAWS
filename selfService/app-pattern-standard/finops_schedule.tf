################################################################
# Titre: Self-Service - Custom FinOps Schedule
# Description: Override de la politique globale pour ce projet
# Auteur: Ravindra JOB | v2.0
################################################################

resource "aws_cloudwatch_event_rule" "custom_nightly_shutdown" {
  count               = var.environment != "Prod" ? 1 : 0
  name                = "rule-shutdown-${var.app_name}"
  description         = "Extinction Non-Prod personnalisée"
  schedule_expression = var.shutdown_schedule
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  count     = var.environment != "Prod" ? 1 : 0
  rule      = aws_cloudwatch_event_rule.custom_nightly_shutdown[0].name
  target_id = "FinOpsShutdownCustom"
  arn       = data.aws_lambda_function.central_shutdown.arn
}
