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
  acl    = "private"
}

// Creating the SQS Queue
resource "aws_sqs_queue" "upload_queue" {
  name                      = "my_upload_queue"
  delay_seconds             = 90
  max_message_size          = 2048
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10
  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.terraform_queue_deadletter.arn
    maxReceiveCount     = 4
  })

  tags = {
    Environment = "production"
  }
}

