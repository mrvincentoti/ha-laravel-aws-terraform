#============================= PROVIDER CONFIG =================================
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
        }
    }

  backend "s3" {
    region  = "us-east-1"
    profile = "default"
    key     = "terraformstatefile"
    bucket  = "terraformstatefile-ha24102022"
    }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-west-1"
}

#============================= MODULES IMPORT ==================================
module "networking" {
  source = "./modules/networking"
}

module "application" {
  #Waits for RDS to be fully deployed in order to configure wordpress
  depends_on = [
    module.networking
    ]
  source                 = "./modules/application"
  vpc_id                = module.networking.vpc_id
  private_subnets       = module.networking.private_subnets
  public_subnets        = module.networking.public_subnets
}

output "load_balancer_dns" {
  value = module.application.alb_dns
}