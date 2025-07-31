resource "aws_s3_bucket" "ingestion" {
  bucket = local.environment.cron.s3
}

resource "aws_s3_bucket_ownership_controls" "ingestion" {
  bucket = aws_s3_bucket.ingestion.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

output "s3_bucket_arn" {
  value = aws_s3_bucket.ingestion.arn
  description = "ARN of the ingestion S3 bucket"
}
