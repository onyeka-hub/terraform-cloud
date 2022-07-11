terraform {
  backend "remote" {
    organization = "onyekaonu"

    workspaces {
      name = "terraform-cloud"
    }
  }
}