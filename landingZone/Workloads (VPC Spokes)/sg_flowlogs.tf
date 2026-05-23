################################################################
# Titre: Workloads - Security Groups & VPC Flow Logs
# Auteur: Ravindra JOB | v1.3
# Update: 23/05/2026
################################################################

# 1. Security Groups (Micro-segmentation)
resource "aws_security_group" "web_sg" {
  name        = "sg-web-tier-lab"
  description = "Security Group pour le tier Web"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow HTTP from ALB"
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.alb_sg_id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "db_sg" {
  name        = "sg-db-tier-lab"
  description = "Security Group pour le tier DB"
  vpc_id      = var.vpc_id

  ingress {
    description     = "Allow SQL from Web Tier"
    from_port       = 5432
    to_port         = 5432
    protocol        = "tcp"
    security_groups = [aws_security_group.web_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# 2. VPC Flow Logs (Observability)
resource "aws_flow_log" "spoke_flow_logs" {
  iam_role_arn    = var.flow_log_role_arn
  log_destination = var.cloudwatch_log_group_arn
  traffic_type    = "ALL"
  vpc_id          = var.vpc_id
}
