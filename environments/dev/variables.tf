variable "aws_region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "github_token" {
  type      = string
  sensitive = true
}

variable "webhook_secret" {
  type      = string
  sensitive = true
}

variable "github_owner" {
  type = string
}
