terraform {
  backend "remote" {
    organization = "onyeka-org"

    workspaces {
      name = "terraform-cloud"
    }
  }
}

# terraform {
#   backend "local" {
#   }
# }
