################################################################
# Titre: Self-Service - AWS App Pattern Standard
# Description: Variables d'entrée pour le portail développeur
# Auteur: Ravindra JOB | v2.0
################################################################

variable "app_name" {
  description = "Nom du projet/application"
  type        = string
}

variable "environment" {
  description = "Environnement (Sandbox, Dev, Prod)"
  type        = string
}

variable "shutdown_schedule" {
  description = "Heure d'extinction quotidienne (CRON format)"
  type        = string
  default     = "cron(0 20 * * ? *)"
}

variable "random_suffix" {
  type = string
  default = "12345"
}

variable "enable_eks" {
  type    = bool
  default = false
}

variable "enable_database" {
  type    = bool
  default = false
}
