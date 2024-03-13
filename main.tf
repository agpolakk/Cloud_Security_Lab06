resource "aws_iam_role" "iam_role" {
  name = "iamrole"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam_profile"
  role = aws_iam_role.iam_role.name
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-06ca3ca175f37dd66"
  instance_type = "t2.micro"
  
  iam_instance_profile = aws_iam_instance_profile.iam_profile.name

  tags = {
    Name = "ec2instance"
  }
}

resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = "s3-policy-bucket"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "AWS": "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${aws_iam_role.iam_role.name}"
        },
        "Action": [
          "s3:GetObject",
          "s3:ListBucket"
        ],
        "Resource": [
          "arn:aws:s3:::s3-policy-bucket",
          "arn:aws:s3:::s3-policy-buckett/*"
        ]
      }
    ]
  })
}

#aws_s3_bucket_policy.example_bucket_policy

 data "aws_caller_identity" "current" {}

# Disassociating Policy from the Role
resource "aws_iam_role_policy_attachment" "example_detach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

  depends_on = [aws_instance.ec2_instance]
  lifecycle {
    ignore_changes = [policy_arn]
  }
}

# Removing the Role
resource "aws_iam_role_policy_attachment" "example_detach_remove" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

  depends_on = [aws_instance.ec2_instance]
  lifecycle {
    ignore_changes = [policy_arn]
  }
}

