provider "aws" {
  region = "us-east-1" # change to your preferred region
}

# S3 Bucket
resource "aws_s3_bucket" "bucket" {
  bucket = "my-demo-s3-bucket-123456" # must be globally unique
  force_destroy = true # allows deletion even if the bucket is not empty

  tags = {
    Environment = "Dev"
    Name        = "MyDemoBucket"
  }
}

# Block Public Access
resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# Enable Versioning
resource "aws_s3_bucket_versioning" "versioning" {
  bucket = aws_s3_bucket.bucket.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Server-Side Encryption (SSE-S3)
resource "aws_s3_bucket_server_side_encryption_configuration" "encryption" {
  bucket = aws_s3_bucket.bucket.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Output Bucket Name
output "bucket_name" {
  value = aws_s3_bucket.bucket.id
}
