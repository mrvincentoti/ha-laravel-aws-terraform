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

module "data" {
  source          = "./modules/data"
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  public_subnets  = module.networking.public_subnets
  intra_subnets   = module.networking.intra_subnets

  #rds_port              = 
  #prefix_name           =
  #rds_instance_class    =
  #cluster_username      =
  #cluster_dbname        =
  #cluster_password      =
  #rds_instance_count    =

  #memcached_port        = 
  #memcached_node_type   = 
  #memcached_nodes_count =

  #efs_port              =
}

module "application" {
  #Waits for RDS to be fully deployed in order to configure wordpress
  depends_on = [
    module.data,
    module.networking
  ]
  source          = "./modules/application"
  vpc_id          = module.networking.vpc_id
  private_subnets = module.networking.private_subnets
  public_subnets  = module.networking.public_subnets
  intra_subnets   = module.networking.intra_subnets

  #efs_dns_name          = module.data.efs_dns_name
  db_name     = module.data.db_name
  db_hostname = module.data.db_hostname
  db_username = module.data.db_username
  db_password = module.data.db_password
  clients_sg  = module.data.clients_sg
}

output "load_balancer_dns" {
  value = module.application.alb_dns
}