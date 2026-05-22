################################################################
# Titre: AWS Application Load Balancer (LB7) & WAF v2
# Description : Exposition sécurisée L7 avec protection sémantique
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/10/2025 [v1.0 | RJ]
################################################################

# 1. AWS WAF v2 Web ACL (Hardened)
resource "aws_wafv2_web_acl" "main" {
  name        = "lab-aws-waf-policy"
  description = "Protection L7 contre les injections SQL et menaces OWASP"
  scope       = "REGIONAL"

  default_action {
    allow {}
  }

  rule {
    name     = "AWS-AWSManagedRulesCommonRuleSet"
    priority = 10
    override_action {
      none {}
    }
    statement {
      managed_rule_group_statement {
        name        = "AWSManagedRulesCommonRuleSet"
        vendor_name = "AWS"
      }
    }
    visibility_config {
      cloudwatch_metrics_enabled = true
      metric_name                = "WAFCommonRule"
      sampled_requests_enabled   = true
    }
  }

  visibility_config {
    cloudwatch_metrics_enabled = true
    metric_name                = "GlobalWAF"
    sampled_requests_enabled   = true
  }
}

# 2. Application Load Balancer (ALB)
resource "aws_lb" "external" {
  name               = "lab-aws-alb-external"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_sg_id]
  subnets            = var.public_subnet_ids

  enable_deletion_protection = true

  tags = {
    Name = "lab-aws-alb"
  }
}

# Association WAF -> ALB
resource "aws_wafv2_web_acl_association" "assoc" {
  resource_arn = aws_lb.external.arn
  web_acl_arn  = aws_wafv2_web_acl.main.arn
}

# Listener HTTPS
resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.external.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.acm_certificate_arn

  default_action {
    type = "fixed-response"
    fixed_response {
      content_type = "text/plain"
      message_body = "Access Denied - Ravindra JOB Lab"
      status_code  = "403"
    }
  }
}
