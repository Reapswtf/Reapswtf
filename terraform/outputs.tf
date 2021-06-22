output "bucket-a" {
  value = aws_s3_bucket.lambda_upload_bucket.bucket
}

output "bucket-b" {
  value = aws_s3_bucket.lambda_noexif_bucket.bucket
}