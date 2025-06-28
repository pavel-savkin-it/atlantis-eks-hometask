variable "oidc_provider_arn" {
  type        = string
}

variable "oidc_provider_url" {
  type        = string
}

variable "subjects" {
  type        = list(string)
}
