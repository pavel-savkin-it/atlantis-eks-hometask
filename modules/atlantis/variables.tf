variable "github_token" {
  type        = string
  sensitive   = true
}

variable "webhook_secret" {
  type        = string
  sensitive   = true
}

variable "atlantis_hostname" {
  type        = string
}

variable "repo_allowlist" {
  type        = string
}

variable "kubeconfig_data" {
  type = object({
    host                   = string
    cluster_ca_certificate = string
    token                  = string
  })
}
