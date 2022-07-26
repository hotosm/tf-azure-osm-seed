resource "helm_release" "osmseed" {
  name  = "osmseed-helm"
  repository = "https://devseed.com/osm-seed-chart"
  chart = "osm-seed"
  version = "0.1.0-n687.h1279a34"
  wait = false
  depends_on = [

  ]

  values = [
    "${file("${path.module}/values.yaml")}"
  ]

  set {
    name = "web.env.MAILER_ADDRESS"
    value = var.mailerAddress
  }

  set {
    name = "web.env.MAILER_DOMAIN"
    value = var.mailerDomain
  }

  set {
    name = "web.env.MAILER_USERNAME"
    value = var.mailerUsername
  }

  set_sensitive {
    name = "web.env.MAILER_PASSWORD"
    value = var.mailerPassword
  }

  set {
    name = "web.env.MAILER_FROM"
    value = var.mailerFrom
  }

  set {
    name = "web.env.MAILER_PORT"
    value = var.mailerPort
  }

  set {
    name = "db.persistenceDisk.AZURE_diskName"
    value = azurerm_managed_disk.osmseed_db.name
  }

  set {
    name = "db.persistenceDisk.AZURE_diskURI"
    value = azurerm_managed_disk.osmseed_db.id
  }

  set {
    name = "db.persistenceDisk.AZURE_diskSize"
    value = var.osmseed_db_disk_size
  }

}
