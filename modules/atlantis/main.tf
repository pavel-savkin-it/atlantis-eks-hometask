provider "helm" {
  kubernetes {
    host                   = var.kubeconfig_data["host"]
    cluster_ca_certificate = base64decode(var.kubeconfig_data["cluster_ca_certificate"])
    token                  = var.kubeconfig_data["token"]
  }
}

resource "helm_release" "atlantis" {
  name       = "atlantis"
  repository = "https://runatlantis.github.io/helm-charts"
  chart      = "atlantis"
  namespace  = "atlantis"
  create_namespace = true

  values = [
    yamlencode({
      ingress = {
        enabled = true
        className = "nginx"
        annotations = {
          "kubernetes.io/ingress.class" : "nginx"
          "cert-manager.io/cluster-issuer" : "letsencrypt"
        }
        hosts = [{
          host = var.atlantis_hostname
          paths = [{ path = "/", pathType = "Prefix" }]
        }]
        tls = [{
          hosts = [var.atlantis_hostname]
          secretName = "atlantis-tls"
        }]
      }

      vcsSecretName = "atlantis-vcs"
      environment = {
        ATLANTIS_REPO_ALLOWLIST = var.repo_allowlist
      }
    })
  ]
}

resource "kubernetes_secret" "atlantis_vcs" {
  metadata {
    name      = "atlantis-vcs"
    namespace = "atlantis"
  }

  data = {
    github_token   = base64encode(var.github_token)
    webhook_secret = base64encode(var.webhook_secret)
  }

  type = "Opaque"
}
