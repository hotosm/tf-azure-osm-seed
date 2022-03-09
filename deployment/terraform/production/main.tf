variable "username" {
  type = string
}

variable "subscriptionId" {
  type = string
}

module "resources" {
  source = "../resources"

  environment          = "production"
  subscriptionId       = var.subscriptionId
  region               = "East US"
  aks_node_count       = 1

  admin_email          = ""

  domain = ""
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


