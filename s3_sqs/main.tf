// Creating S3 Bucket
resource "aws_s3_bucket" "upload_queue" {
  bucket = "upload-queue-anjon"

  tags = {
    Name = "Upload Queue"
  }
}

// Adding S3 Bucket ACL Policy
resource "aws_s3_bucket_acl" "upload_acl" {
  bucket = aws_s3_bucket.upload_queue.id
  acl = "private"
}

