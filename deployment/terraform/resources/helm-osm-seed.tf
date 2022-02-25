resource "helm_release" "osmseed" {
  name  = "osmseed-helm"
  repository = "https://devseed.com/osm-seed-chart"
  chart = "osm-seed"
  version = "0.1.0-n625.h614bf1d"
  wait = false
  depends_on = [
    helm_release.osmseed-ingress-nginx,
    helm_release.osmseed-cert-manager
  ]

  #FIXME: many more values to add
  set {
    name  = "environment"
    value = var.environment
  }

  set {
    name  = "domain"
    value = var.domain
  }

  set {
    name = "adminEmail"
    value = var.admin_email
  }

  
}
