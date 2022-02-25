variable "username" {
  type = string
}

variable "subscriptionId" {
  type = string
}

module "resources" {
  source = "../resources"

  environment          = "dev"
  subscriptionId       = var.subscriptionId
  region               = "West Europe"
  aks_node_count       = 1
  admin_email          = ""
  domain               = ""
}

terraform {
  backend "azurerm" {
    resource_group_name  = "osmseedterraformdev"
    storage_account_name = "osmseedterraformstate"
    container_name       = "osmseed-dev"
    key                  = "dev.terraform.tfstate"
  }
}

# terraform {
#   backend "local" {
#     path = "terraform.tfstate"
#   }
# }

output "resources" {
  value     = module.resources
  sensitive = true
}


