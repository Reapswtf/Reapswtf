resource "aws_s3_bucket" "lambda_upload_bucket" {
  bucket = "bucket-images-exif"
  acl    = "private"
  force_destroy = true
}

resource "aws_s3_bucket" "lambda_noexif_bucket" {
  bucket = "bucket-images-noexif"
  acl    = "private"
  force_destroy = true
}

resource "aws_s3_bucket_object" "images_folder" {
    bucket = aws_s3_bucket.lambda_upload_bucket.id
    acl    = "private"
    key    = "images/"
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.lambda_upload_bucket.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.exif.arn
    events              = ["s3:ObjectCreated:*"]
    filter_prefix       = "images/"
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_bucket]
}

resource "aws_s3_bucket_object" "images_test_item" {
    bucket = aws_s3_bucket.lambda_upload_bucket.id
    acl    = "private"
    key    = "images/poker.jpg"
	source = "s3objects/poker.jpg"
	
	depends_on = [aws_s3_bucket_notification.bucket_notification]
}
