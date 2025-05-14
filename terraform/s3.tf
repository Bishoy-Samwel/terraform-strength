
resource "aws_s3_bucket" "s3_bucket" {
  bucket = "${var.vpc_name}-bucket-${random_string.random_string.result}"
  # acl    = "private"
  tags = {
    Name        = "${var.vpc_name}-bucket"
    Environment = "demo"
    Terraform   = "true"
  }
}



resource "aws_s3_bucket_ownership_controls" "ownership" {
  bucket = aws_s3_bucket.s3_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced" 
  }
}

resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.s3_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

