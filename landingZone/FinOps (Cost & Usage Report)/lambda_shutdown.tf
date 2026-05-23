################################################################
# Titre: FinOps - Auto-Shutdown (Non-Prod)
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# Fonction Lambda pour arrêter les EC2 et RDS Non-Prod
resource "aws_lambda_function" "finops_shutdown" {
  filename         = "shutdown_payload.zip"
  function_name    = "lambda-finops-shutdown-lab"
  role             = aws_iam_role.lambda_exec_role.arn
  handler          = "index.handler"
  runtime          = "python3.10"
  timeout          = 300

  environment {
    variables = {
      TARGET_TAG = "Non-Prod"
    }
  }
}

# EventBridge pour déclencher la Lambda tous les soirs à 20h
resource "aws_cloudwatch_event_rule" "nightly_shutdown" {
  name                = "rule-nightly-shutdown"
  description         = "Déclenche l'extinction Non-Prod à 20h"
  schedule_expression = "cron(0 20 * * ? *)"
}

resource "aws_cloudwatch_event_target" "trigger_lambda" {
  rule      = aws_cloudwatch_event_rule.nightly_shutdown.name
  target_id = "FinOpsShutdown"
  arn       = aws_lambda_function.finops_shutdown.arn
}
