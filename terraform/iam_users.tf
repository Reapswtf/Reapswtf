#• User A can Read/Write to Bucket A
#• User B can Read from Bucket B

resource "aws_iam_user" "usera" {
  name = "UserA"
  path = "/"
}

resource "aws_iam_user" "userb" {
  name = "UserB"
  path = "/"
}

resource "aws_iam_user_policy" "usera_read-write_bucketa" {
  name = "read-write-bucket-a"
  user = aws_iam_user.usera.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:Get*",
		"s3:Describe*",
		"s3:List*",
		"s3:PutObject",
		"s3:DeleteObject"
      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::bucket-images-exif",
                "arn:aws:s3:::bucket-images-exif/*"
            ]
    }
  ]
}
EOF
}
  
resource "aws_iam_user_policy" "usera_read-only_bucketb" {
  name = "read-only-bucket-b"
  user = aws_iam_user.userb.name

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:GetObject*",
		"s3:Describe*",
		"s3:List*"

      ],
      "Effect": "Allow",
      "Resource": [
                "arn:aws:s3:::bucket-images-noexif",
                "arn:aws:s3:::bucket-images-noexif/*"
            ]
    }
  ]
}
EOF
}  
  