/* 
    This configuration block setups up the initial s3 bucket 
    and dynamodb table needed for s3 remote state support. 
    The backend configuration should be commented on initial init
    and then uncommented after the first run of terraform. 
    Once ready please execute terraform init -reconfigure
  */


module "terraform_config" {
  source     = "../modules/s3_bucket"
  bucket     = "configs-${var.stage}"
  versioning = "Enabled"
}

module "deployment_config" {
  source     = "../modules/s3_bucket"
  bucket     = "deployment-configs-${var.stage}"
  versioning = "Enabled"
}

resource "aws_dynamodb_table" "terraform_state_lock" {
  name           = "tf-lock-${var.stage}"
  read_capacity  = 1
  write_capacity = 1
  hash_key       = "LockID"
  point_in_time_recovery {
    enabled = true
  }
  attribute {
    name = "LockID"
    type = "S"
  }
  server_side_encryption {
    enabled = true
  }
}
