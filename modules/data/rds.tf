################################################################################
# RDS Secret key from AWS secret key manager
################################################################################
data "aws_secretsmanager_secret_version" "creds" {
  secret_id = "poll-database-secrets"
}

# Decode from json
locals {
  db_creds = jsondecode(
    data.aws_secretsmanager_secret_version.creds.secret_string
  )
}
################################################################################
# Security Groups for RDS
################################################################################
resource "aws_security_group" "laravel-db-client-sg" {
  name = "${var.prefix_name}-client-sg"

  description = "Allows laravel servers to contact Aurora DB on 3306"
  vpc_id = var.vpc_id

  egress {
    from_port = var.rds_port
    to_port   = var.rds_port
    protocol  = "tcp"

    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name        = "${var.prefix_name}-rds-client-sg"
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_security_group" "laravel-db-sg" {
  name = "${var.prefix_name}-sg"

  description = "Allow TCP connection on 3306 for Aurora DB"
  vpc_id      = var.vpc_id

  # Only MySQL in
  ingress {
    from_port = var.rds_port
    to_port   = var.rds_port
    protocol  = "tcp"
    security_groups = [aws_security_group.laravel-db-client-sg.id
    ]
  }

   egress {
    from_port = var.rds_port
    to_port   = var.rds_port
    protocol  = "tcp"
    security_groups = [aws_security_group.laravel-db-client-sg.id
    ]
  }

  tags = {
    Name        = "${var.prefix_name}-rds-sg"
    Terraform   = "true"
    Environment = "dev"
  }
}
################################################################################
# Subnet Group
################################################################################
resource "aws_db_subnet_group" "laravel-aurora" {
  name        = "${var.prefix_name}-subnets"
  subnet_ids  = var.intra_subnets
  description = "Subnet group used for Aurora DB"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
################################################################################
# RDS Database
################################################################################
resource "aws_rds_cluster" "laravel-rds-cluster" {
  cluster_identifier     = "${var.prefix_name}-rds-cluster"
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.07.2"
  /*#availability_zones     = [
        "eu-west-1a",
        "eu-west-1b"
    ] #causes every time to destroy and rebuild rds cluster*/
  database_name          = local.db_creds.database_name
  db_subnet_group_name   = aws_db_subnet_group.laravel-aurora.name
  master_username        = local.db_creds.master_username
  master_password        = local.db_creds.master_password
  vpc_security_group_ids = [aws_security_group.laravel-db-sg.id
  ]
  skip_final_snapshot    = true
  #backup_retention_period = 5
  #preferred_backup_window = "07:00-09:00"
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

#RDS Cluster Instance
resource "aws_rds_cluster_instance" "laravel-rds-instances" {
  count                = var.rds_instance_count
  identifier           = "${var.prefix_name}-rds-instance-${count.index}"
  db_subnet_group_name = aws_db_subnet_group.laravel-aurora.name
  cluster_identifier   = aws_rds_cluster.laravel-rds-cluster.id
  instance_class       = var.rds_instance_class
  engine               = aws_rds_cluster.laravel-rds-cluster.engine
  engine_version       = aws_rds_cluster.laravel-rds-cluster.engine_version
  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}