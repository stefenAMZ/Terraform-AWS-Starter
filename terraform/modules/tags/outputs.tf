output "common_tags" {
  value = {
    "Environment"            = var.stage
    "Deployed By"          = "terraform"
  }
}

