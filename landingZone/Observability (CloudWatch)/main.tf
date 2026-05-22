################################################################
# Titre: Observability (CloudWatch)
# Description : Monitoring centralisé, Bedrock Guardrails et VPC Flow Logs
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.2 | RJ]
################################################################

# 1. CloudWatch Log Group central (CAF: SRE Pillar)
resource "aws_cloudwatch_log_group" "lab_central_logs" {
  name              = "/lab-aws/central-audit-logs"
  retention_in_days = 30
}

# 2. AI Monitoring : Audit Amazon Bedrock
# Capture des violations de Guardrails et des logs d'invocation A2A
resource "aws_bedrock_model_invocation_logging_configuration" "ai_audit" {
  logging_config {
    embedding_data_delivery_enabled = true
    image_data_delivery_enabled     = true
    text_data_delivery_enabled      = true
    s3_config {
      bucket_name = var.security_s3_bucket
      key_prefix  = "bedrock-audit-logs"
    }
    cloudwatch_config {
      log_group_name = aws_cloudwatch_log_group.lab_central_logs.name
      role_arn       = var.iam_role_arn
    }
  }
}

# 3. Network Observability : VPC Flow Logs
# Activation sur le Transit Gateway pour auditer la connectivité Hub-and-Spoke
resource "aws_flow_log" "tgw_flow_logs" {
  iam_role_arn    = var.iam_role_arn
  log_destination = aws_cloudwatch_log_group.lab_central_logs.arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
}

# 4. CloudWatch Metric Streams (Kinesis Data Firehose)
# Pour un export temps-réel vers le OTel Collector central
resource "aws_cloudwatch_metric_stream" "main" {
  name          = "lab-aws-metric-stream"
  role_arn      = var.iam_role_arn
  firehose_arn  = var.firehose_arn
  output_format = "opentelemetry0.7" # CNCF Standard
}
