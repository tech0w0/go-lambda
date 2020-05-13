resource "aws_s3_bucket" "bucket" {
  bucket = "go-lambda2"
  acl    = "private"
}