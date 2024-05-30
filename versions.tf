terraform {
  required_version = ">= 1.0"

  backend "remote" {
    hostname     = "app.terraform.io"
    organization = var.tfc_company
    token        = var.tfc_token
    workspaces {
      name = local.namespace
    }
  }

  required_providers {
    random = {
      source  = "hashicorp/random"
      version = ">= 3.5.1"
    }
    aws = {
      source  = "hashicorp/aws"
      version = ">= 5.24.0"
    }
  }
}
