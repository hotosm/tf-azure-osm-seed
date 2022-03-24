variable "username" {
  type = string
}

variable "subscriptionId" {
  type = string
}

variable "mailerAddress" {
  type = string
}

variable "mailerDomain" {
  type = string
}

variable "mailerFrom" {
  type = string
}

variable "mailerUsername" {
  type = string
}

variable "mailerPassword" {
  type = string
}

variable "mailerPort" {
  type = number
}

variable "domain" {
  type = string
}
module "resources" {
  source = "../resources"

  environment          = "production"
  subscriptionId       = var.subscriptionId
  region               = "East US"
  aks_node_count       = 1
  mailerAddress        = var.mailerAddress
  mailerDomain         = var.mailerDomain
  mailerFrom           = var.mailerFrom
  mailerUsername       = var.mailerUsername
  mailerPassword       = var.mailerPassword
  mailerPort           = var.mailerPort
  admin_email          = ""
  domain               = "52.226.232.236"
}

terraform {
  backend "azurerm" {
    resource_group_name  = "osmseedterraformdev"
    storage_account_name = "tfazureosmseed"
    container_name       = "tf-azure-osm-seed"
    key                  = "production.terraform.tfstate"
  }
}

output "resources" {
  value     = module.resources
  sensitive = true
}


