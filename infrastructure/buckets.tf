resource "aws_s3_bucket" "input" {
  bucket = "kplatkow-workshop-input"
  force_destroy = true
  acl    = "private"

  tags = var.tags
}

resource "aws_s3_bucket" "destination" {
  bucket = "kplatkow-workshop-destination"
  force_destroy = true
  acl    = "private"

  tags = var.tags
}