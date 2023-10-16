provider "aws" {
  region  = var.user_region
  profile = var.user_profile
  default_tags {
    tags = module.tags.common_tags
  }
}

module "tags" {
  source = "../modules/tags"
  stage  = var.stage
}