provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "../../modules/vpc"
  name   = var.project_name
}

module "eks" {
  source        = "../../modules/eks"
  cluster_name  = var.project_name
  vpc_id        = module.vpc.vpc_id
  subnet_ids    = module.vpc.subnet_ids
}

module "rbac" {
  source              = "../../modules/rbac"
  oidc_provider_arn   = module.eks.oidc_provider_arn
  oidc_provider_url   = module.eks.oidc_provider_url
  subjects            = ["system:serviceaccount:atlantis:default"]
}

module "atlantis" {
  source           = "../../modules/atlantis"
  github_token     = var.github_token
  webhook_secret   = var.webhook_secret
  atlantis_hostname = module.eks.atlantis_ingress_hostname
  repo_allowlist   = "github.com/${var.github_owner}/*"
  kubeconfig_data = {
    host                   = module.eks.cluster_endpoint
    cluster_ca_certificate = module.eks.cluster_ca
    token                  = module.eks.auth_token
  }
}
