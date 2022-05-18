remote_state {

  backend = "s3"

  generate = {
    path      = "backend.tf"
    if_exists = "overwrite"
  }

  config = {
    bucket         = "poc-std-log-terraform-state"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "ap-southeast-1"
    encrypt        = true
  }

}

include "root" {
  path = find_in_parent_folders()
}

locals {
  env = yamldecode(file(find_in_parent_folders("terragrunt-env.yaml")))
}

inputs = {
  
}