# Adding AWS us-east-1 provider
provider "aws" {
  region = "us-east-1"
}

# s3 bucket
resource "aws_s3_bucket" "my_website_bucket" {
  bucket = "kjb-portfolio-project-bucket"

  tags = {
    Name = "My Website Bucket"
    Environment = "Production"
  }
}

# Ownership Control
resource "aws_s3_bucket_ownership_controls" "my_website_bucket_ownership_controls" {
  bucket = aws_s3_bucket.my_website_bucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

# s3 bucket website configuration
resource "aws_s3_bucket_website_configuration" "my_website_web_config" {
  bucket = my_website_bucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}

# block public access
resource "aws_s3_bucket_public_access_block" "my_public_access_block" {
  bucket = aws_s3_bucket.my_website_bucket.id

  block_public_acls = false
  block_public_policy = false
  ignore_public_acls = false
  restrict_public_buckets = false
}

# acl
resource "aws_s3_bucket_acl" "my_acl" {
  bucket = aws_s3_bucket.my_website_bucket.id
  acl = "public-read"

  depends_on = [
    aws_s3_bucket_ownership_controls.my_website_bucket_ownership_controls,
    aws_s3_bucket_public_access_block.my_public_access_block
  ]
}

# bucket policy
resource "aws_s3_bucket_policy" "my_website_bucket_policy" {
  bucket = aws_s3_bucket.my_website_bucket.id

  policy = data.aws_iam_policy_document.my_website_bucket_policy_document.json
}

data "aws_iam_policy_document" "my_website_bucket_policy_document" {
  statement {
    sid = "PublicReadGetObject"
    effect = "Allow"
    principals {
      type = "*"
      identifiers = ["*"]
    }
    actions = [
      "s3:GetObject"
    ]
    resources = [
      aws_s3_bucket.my_website_bucket.arn, 
      "${aws_s3_bucket.my_website_bucket.arn}/*"
    ]
  }
}
