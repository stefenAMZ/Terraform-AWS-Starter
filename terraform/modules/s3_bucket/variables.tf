variable "bucket" {
  description = "Name of the s3 bucket to prefix with env. Must be unique."
  type        = string
}

variable "versioning" {
  description = "Map containing versioning configuration."
  type        = string
  default     = "Disabled"
}