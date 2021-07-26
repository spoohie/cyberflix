resource "aws_s3_bucket" "input" {
  bucket = "cyberflix-input"
  force_destroy = true
  acl    = "private"

  tags = var.tags
}

resource "aws_s3_bucket" "output" {
  bucket = "cyberflix-output"
  force_destroy = true
  acl    = "private"

  tags = var.tags
}