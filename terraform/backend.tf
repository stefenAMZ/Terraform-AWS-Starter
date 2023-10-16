#=================
# Terraform Config
#=================

terraform {
  backend "s3" {
    bucket         = "configs-dev"
    key            = "terraform/dev/mim/terraform.tfstate"
    dynamodb_table = "tf-lock-dev"
    profile        = "dev"

    encrypt = true
    region  = "us-east-1"
  }
}