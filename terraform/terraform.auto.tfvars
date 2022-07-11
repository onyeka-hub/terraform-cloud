region = "us-east-2"

vpc_cidr = "10.0.0.0/16"

enable_dns_support = "true"

enable_dns_hostnames = "true"

enable_classiclink = "false"

enable_classiclink_dns_support = "false"

tags = {
  Owner-Email = "onyekagodonu@yahoo.com"
  Managed-By  = "Terraform"
}

name = "onyi"

ami = "ami-0ba4b09be1ba8a163"

ami-bastion = "ami-011da3ac5f39a4b76"

ami-nginx = "ami-0683b0d6ff0442368"

ami-web = "ami-04346a849886e7cbd"

keypair = "devops"

master-username = "onyeka"

master-password = "12345678"

account_no = 590323966468

preferred_number_of_public_subnets = 2

preferred_number_of_private_subnets = 4

environment = "dev"

multi_az = true

max_size = 2

min_size = 1

desired_capacity =1

max_subnets = 10
