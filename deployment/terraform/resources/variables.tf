variable "environment" {
  type = string
}

variable "domain" {
  type = string
  default = "osmseed-test.ds.io"
}

variable "admin_email" {
  type = string
}

variable "letsencrypt_email" {
  type = string
  default = "" #FIXME
}

variable "region" {
  type = string
}

variable "aks_node_count" {
  type = number
  default = 1
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

# -----------------
# Attach ACR
# Defaults to common resources

variable "osmseed_test_resources_acr" {
  type    = string
  default = "osmseedterraformacr"
}

variable "osmseed_test_resources_rg" {
  type = string
  default = "osmseedterraformdev"
}

variable "osmseed_db_disk_size" {
  type = string
  default = "2048"
}

# -----------------
# Local variables

locals {
  stack_id              = "osmseed"
  # change this to whoever is hosting.
  # this is used to make the storage account unique
  owner                 = "hot"
  location              = lower(replace(var.region, " ", ""))
  prefix                = "${local.stack_id}-${var.environment}"
  prefixnodashes        = "${local.stack_id}${var.environment}"
  storage               = "${local.stack_id}${local.stack_id}${var.environment}"
  deploy_secrets_prefix = "${local.stack_id}-${var.environment}"
}
