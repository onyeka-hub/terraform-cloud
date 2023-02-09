################################################################################
# vpc module: this is aws vpc module that will create a vpc with its associate resources 
#like subnets, internet and nat gateway, route tables, etc
################################################################################
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.name
  cidr = var.vpc_cidr
  azs  = ["us-east-2a", "us-east-2b"]
  # private_subnets = ["10.0.3.0/24", "10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets  = ["10.0.2.0/24", "10.0.4.0/24"]
  private_subnets = [for i in range(1, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  # public_subnets  = [for i in range(2, 8, 2) : cidrsubnet(var.vpc_cidr, 8, i)]
  enable_nat_gateway     = true
  single_nat_gateway     = true
  one_nat_gateway_per_az = false

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
  vpc_tags                 = var.vpc_tags
  public_route_table_tags  = var.public_route_table_tags
  private_route_table_tags = var.private_route_table_tags
  nat_gateway_tags         = var.nat_gateway_tags
  nat_eip_tags             = var.nat_eip_tags
  public_subnet_names      = var.public_subnet_names
  private_subnet_names     = var.private_subnet_names
}


################################################################################
# rds: this is an aws rds module that will create a rds database with its associate resources
################################################################################
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = "onyi"

  engine            = "mysql"
  engine_version    = "5.7"
  instance_class    = "db.t3.micro"
  allocated_storage = 5

  db_name                = "onyekadb"
  username               = var.master-username
  password               = var.master-password
  create_random_password = false
  port                   = "3306"

  iam_database_authentication_enabled = true

  vpc_security_group_ids = [module.security.vpc_security_group_ids]

  # Enhanced Monitoring - see example for details on how to create the role
  # by yourself, in case you don't want to create it automatically
  monitoring_interval    = "30"
  monitoring_role_name   = "MyRDSMonitoringRole"
  create_monitoring_role = true

  tags = {
    Owner       = "user"
    Environment = "dev"
  }

  # DB subnet group
  create_db_subnet_group = true
  db_subnet_group_name   = "onyi-rds"
  skip_final_snapshot    = true
  subnet_ids             = [module.vpc.private_subnets[2], module.vpc.private_subnets[3]]

  # DB parameter group
  family = "mysql5.7"

  # DB option group
  major_engine_version = "5.7"

  # Database Deletion Protection
  deletion_protection = false

  parameters = [
    {
      name  = "character_set_client"
      value = "utf8mb4"
    },
    {
      name  = "character_set_server"
      value = "utf8mb4"
    }
  ]

  options = [
    {
      option_name = "MARIADB_AUDIT_PLUGIN"

      option_settings = [
        {
          name  = "SERVER_AUDIT_EVENTS"
          value = "CONNECT"
        },
        {
          name  = "SERVER_AUDIT_FILE_ROTATIONS"
          value = "37"
        },
      ]
    },
  ]
}

################################################################################
# Module for Elastic Filesystem and key management system; this is an aws efs module that will
# creat elastic file system in the webservers availablity zone and allow traffic from the webservers
################################################################################
resource "aws_kms_key" "onyi-kms" {
  description = "KMS key"

    tags = {
        Name = format("%s-kms", var.name)
      }

  policy      = <<EOF
  {
  "Version": "2012-10-17",
  "Id": "kms-key-policy",
  "Statement": [
    {
      "Sid": "Enable IAM User Permissions",
      "Effect": "Allow",
      "Principal": { "AWS": "arn:aws:iam::${var.account_no}:user/onyeka" },
      "Action": "kms:*",
      "Resource": "*"
    }
  ]
}
EOF
}

# create key alias
resource "aws_kms_alias" "alias" {
  name          = "alias/onyi-kms"
  target_key_id = aws_kms_key.onyi-kms.key_id
}

module "efs" {
  source = "cloudposse/efs/aws"
  # Cloud Posse recommends pinning every module to a specific version
  # version     = "x.x.x"

  encrypted = true
  kms_key_id = aws_kms_key.onyi-kms.arn

  name                          = "onyi-efs"
  region                        = var.region
  vpc_id                        = module.vpc.vpc_id
  subnets                       = [module.vpc.private_subnets[0], module.vpc.private_subnets[1]]
  associated_security_group_ids = [module.security.vpc_security_group_ids]
  create_security_group         = false

  access_points = {
    "wordpress" = {
      posix_user = {
        gid            = "0"
        uid            = "0"
        secondary_gids = null
      }
      creation_info = {
        gid         = "0"
        uid         = "0"
        permissions = "0755"
      }
    }
    "tooling" = {
      posix_user = {
        gid            = "0"
        uid            = "0"
        secondary_gids = null
      }
      creation_info = {
        gid         = "0"
        uid         = "0"
        permissions = "0755"
      }
    }
  }

}
