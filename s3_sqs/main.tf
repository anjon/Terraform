// Creating S3 Bucket
module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket = "upload-queue"
  acl    = "private"
}

