resource "aws_iam_role" "exif_lambda" {
  name = "exif_execution_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}


resource "aws_iam_policy" "lambda_exif_policy" {
  name = "lambda_exif_policy"
  path = "/"
  description = "lambda invocation policy"
  policy = jsonencode({

    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": "logs:CreateLogGroup",
            "Resource": "arn:aws:logs:eu-west-1:${data.aws_caller_identity.current.account_id}:*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents"
            ],
            "Resource": [
                "arn:aws:logs:eu-west-1:${data.aws_caller_identity.current.account_id}:log-group:/aws/lambda/stripExif:*"
            ]
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:GetObject"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-images-exif",
                "arn:aws:s3:::bucket-images-exif/*"
            ]
        },
		{
            "Effect": "Allow",
            "Action": [
                "s3:PutObject"
            ],
            "Resource": [
                "arn:aws:s3:::bucket-images-noexif",
                "arn:aws:s3:::bucket-images-noexif/*"
            ]
        }
    ]
  })
}


resource "aws_iam_policy_attachment" "lambda_invocation_policy_attachment" {
  name       = "lambda_invocation_policy_attachment"
  roles      = [aws_iam_role.exif_lambda.name]
  policy_arn = aws_iam_policy.lambda_exif_policy.arn
}