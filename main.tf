resource "aws_iam_role" "iam_role" {
  name = "iamrole9389"

  assume_role_policy = jsonencode({
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
  })
  tags = local.common_tags

}

resource "aws_iam_role_policy_attachment" "policy_attachment" {
  role       = aws_iam_role.iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"
}

resource "aws_iam_instance_profile" "iam_profile" {
  name = "iam-profile9389"
  role = aws_iam_role.iam_role.name
}

resource "aws_instance" "ec2_instance" {
  ami           = "ami-830c94e3"
  instance_type = "t2.micro"
  #  "ami-0492f9e8743eb62eb" "ami-06ca3ca175f37dd66"
  iam_instance_profile = aws_iam_instance_profile.iam_profile.name
  # aws_iam_role.iam_role.name
  tags = {
    Name = "ccgc-instance"
  }
}

resource "aws_s3_bucket" "example_bucket" {
  bucket = "ccgc5501-s3-bucket"

  # policy = file(~/policy.json)
}

# resource "aws_s3_bucket_acl" "example_bucket_acl" {
#   bucket = aws_s3_bucket.example_bucket.id
#   acl = "private"
# }


resource "aws_iam_policy" "s3_bucket_policy" {


  policy = jsonencode({
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "*",
      "Resource": "arn:aws:s3:::s3-policy-bucket/*"
    }
  ]
})
}


#aws_s3_bucket_policy.example_bucket_policy
# "arn:aws:iam::aws:policy/AmazonS3ReadOnlyAccess"

 data "aws_caller_identity" "current" {}

# Disassociating Policy from the Role
resource "aws_iam_role_policy_attachment" "example_detach" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn

  depends_on = [aws_instance.ec2_instance]
  lifecycle {
    ignore_changes = [policy_arn]
  }
}

# Removing the Role
resource "aws_iam_role_policy_attachment" "example_detach_remove" {
  role       = aws_iam_role.iam_role.name
  policy_arn = aws_iam_policy.s3_bucket_policy.arn

  depends_on = [aws_instance.ec2_instance]
  lifecycle {
    ignore_changes = [policy_arn]
  }
}

