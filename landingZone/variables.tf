################################################################
# Titre: AWS Variables Baseline
# Description : Variables communes pour la Landing Zone
# Auteur: Ravindra JOB
# Source: https://github.com/ravindrajob/
# Update: 22/05/2026 [v1.0 | RJ]
################################################################

variable "vpc_id" { type = string }
variable "region" { default = "eu-west-3" }
variable "private_subnet_ids" { type = list(string) }
variable "public_subnet_ids" { type = list(string) }
variable "n8n_private_ip" { type = string }
variable "alb_sg_id" { type = string }
variable "acm_certificate_arn" { type = string }
variable "ssm_endpoint_sg_id" { type = string }
