variable "user_region" {
  type        = string
  description = "AWS region to use for all resources"
  default     = "us-east-1"
}

variable "user_profile" {
  type        = string
  description = "This is the AWS profile name as set in the shared credentials file"
  default     = "dev"
}

variable "stage" {
  type    = string
  default = "dev"
}