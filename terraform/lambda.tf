resource "aws_lambda_function" "exif" {
  filename      = "packages/exif.zip"
  function_name = "exif_function_terraform"
  role          = aws_iam_role.exif_lambda.arn
  handler       = "lambda_function.lambda_handler"
  source_code_hash = filebase64sha256("packages/exif.zip")
  runtime = "python3.8"
}

resource "aws_lambda_permission" "allow_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.exif.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.lambda_upload_bucket.arn
}


