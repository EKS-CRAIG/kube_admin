locals {
  aws_region  = "us-east-1"
  domain_name = "k8s.staging.golobomantics.com"
  tags = {
    ops_env              = "staging"
    ops_managed_by       = "terraform",
    ops_source_repo      = "kubernetes-ops",
    ops_source_repo_path = "terraform-environments/aws/staging/5-route53-hostedzone",
    ops_owners           = "devops",
  }
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.37.0"
    }
  }

  backend "remote" {
    # Update to your Terraform Cloud organization
    organization = "kubernetes-op-867"

    workspaces {
      name = "kubernetes-op-route53"
    }
  }
}

provider "aws" {
  region = local.aws_region
}

#
# Route53 Hosted Zone
#
module "route53-hostedzone" {
  source = "./hosted-zone"

  domain_name = local.domain_name
  tags        = local.tags
}
