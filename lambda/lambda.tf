
data "archive_file" "ec2Refresh" {
  type = "zip"
  source_dir = "./refresh.py"
  output_path = "./refresh.zip"
}

resource "aws_lambda_function" "ec2Refresh" {
  filename = data.archive_file.ec2Refresh.output_path
  function_name = "ec2Refresh-tf"
  role = aws_iam_role.ec2Refresh.arn
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.8"
  timeout          = "90"
  memory_size      = "128"
#  source_code_hash = filebase64(file("${data.archive_file.ec2Refresh.output_path}"))
  publish = false
  environment {
    variables = {
      REFERRAL_DYNAMO_TABLE = "ec2Refresh"
    }
  }
}

resource "aws_iam_role" "ec2Refresh" {
  name = "ec2Refresh"
  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": [
          "lambda.amazonaws.com"
        ]
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

}


resource "aws_iam_role_policy_attachment" "ec2RefreshPolicy" {
  role = aws_iam_role.ec2Refresh.name
  policy_arn = aws_iam_policy.ec2AutoPolicy.arn
}


resource "aws_iam_policy" "ec2AutoPolicy" {
  name = "refreshPolicy"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": "autoscaling:DescribeAutoScalingGroups",
            "Resource": "*"
        },
        {
            "Sid": "VisualEditor1",
            "Effect": "Allow",
            "Action": "autoscaling:StartInstanceRefresh",
            "Resource": "arn:aws:autoscaling:*:*:autoScalingGroup:*:autoScalingGroupName/*"
        }
    ]
}
EOF
}



