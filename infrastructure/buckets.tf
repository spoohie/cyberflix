resource "aws_s3_bucket" "input" {
  bucket = "kplatkow-workshop-input"
  acl    = "private"

  tags = var.tags
}

resource "aws_s3_bucket" "destination" {
  bucket = "kplatkow-workshop-destination"
  acl    = "private"

  tags = var.tags
}