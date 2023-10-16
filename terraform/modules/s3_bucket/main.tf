resource "aws_s3_bucket" "s3_bucket" {
  bucket = var.bucket
  lifecycle {
    ignore_changes = [
      replication_configuration
    ]
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    id     = "DeleteIncompleteMultipartUploadAfter7Day"
    status = "Enabled"

    abort_incomplete_multipart_upload {
      days_after_initiation = 7
    }
  }

  rule {
    id     = "IntelligentTiering"
    status = "Enabled"

    filter {
      prefix = ""
    }

    transition {
      days          = 1
      storage_class = "INTELLIGENT_TIERING"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "s3_bucket" {
  #ts:skip=AWS.S3Bucket.EncryptionandKeyManagement.High.0405 BUG: Want's KMS key with AES256
  bucket = aws_s3_bucket.s3_bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# resource "aws_s3_bucket_logging" "s3_bucket" {
#   bucket        = aws_s3_bucket.s3_bucket.id
#   target_bucket = data.aws_s3_bucket.logging_bucket.id
#   target_prefix = "${aws_s3_bucket.s3_bucket.id}/"
# }

resource "aws_s3_bucket_versioning" "s3_bucket" {
  #ts:skip=AWS.S3Bucket.IAM.High.0370 BUG: Versioning can't scan variable, gives false flag
  bucket = aws_s3_bucket.s3_bucket.id
  versioning_configuration {
    status = var.versioning
  }
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id
  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "AutoAdd-OnlyAllowSSLAccess",
        "Effect": "Deny",
        "Principal": { 
          "AWS": "*"
        },
        "Action": "s3:*",
        "Condition": {
          "Bool": {
            "aws:SecureTransport": "false"
          }
        },
        "Resource": [
          "${aws_s3_bucket.s3_bucket.arn}",
          "${aws_s3_bucket.s3_bucket.arn}/*"
        ]
      }
    ]
}
POLICY
}

resource "aws_s3_bucket_public_access_block" "s3_bucket" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_notification" "s3_bucket" {
  bucket      = aws_s3_bucket.s3_bucket.id
  eventbridge = true
}

resource "aws_ssm_parameter" "s3_bucket_name" {
  name  = "/buckets/${aws_s3_bucket.s3_bucket.id}_name"
  type  = "String"
  value = aws_s3_bucket.s3_bucket.id
}

resource "aws_ssm_parameter" "s3_bucket_arn" {
  name  = "/buckets/${aws_s3_bucket.s3_bucket.id}_arn"
  type  = "String"
  value = aws_s3_bucket.s3_bucket.arn
}
