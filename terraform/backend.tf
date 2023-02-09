# terraform {
#   backend "remote" {
#     organization = "onyekaonu"

#     workspaces {
#       name = "terraform-cloud"
#     }
#   }
# }

terraform {
  backend "local" {
  }
}
