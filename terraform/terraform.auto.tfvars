#########################################
# vpc values
#########################################
region = "us-east-2"

vpc_cidr = "10.0.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

tags = {
  Owner-Email = "onyekagodonu@yahoo.com"
  Managed-By  = "Terraform"
  #   environment = "dev"
}

name = "onyi"

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

max_subnets = 10

environment = "dev"

#########################################
# rds variables 
#########################################

identifier = "onyi"

db_name = "onyidb"

multi_az = true

master-username = "onyeka"

master-password = "12345678"

#########################################
# efs variables 
#########################################

user = "onyi"

account_no = 255913473442

#########################################
# Auto-scaling-group variables 
#########################################

ami-bastion = "ami-0a3b5051428f82636"

ami-nginx = "ami-0ee88617a32dd970c"

ami-web = "ami-0aa353454634186a5"

keypair = "onyi-ohio"

max_size = 2

min_size = 1

desired_capacity = 1

#########################################
# compute variables 
#########################################

# ami = "ami-066115603a9bcec9d"

