
data "archive_file" "ec2Refresh" {
  type = "zip"
  source_file = "./refresh.py"
  output_path = "./refresh.zip"
}

resource "aws_lambda_function" "ec2Refresh" {
  filename = data.archive_file.ec2Refresh.output_path
  source_code_hash = data.archive_file.ec2Refresh.output_base64sha256
  function_name = "ec2Refresh-tf"
  role = aws_iam_role.ec2Refresh.arn
  handler          = "refresh.main_handler"
  runtime          = "python3.8"
  timeout          = "90"
  memory_size      = "512"
  #  source_code_hash = filebase64(file("${data.archive_file.ec2Refresh.output_path}"))
  publish = false
  environment {
    variables = {
      asgNames = "asgName1 asgName2"
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

resource "aws_lambda_permission" "allow_cloudwatch_to_call" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.check_foo.function_name
    principal = "events.amazonaws.com"
    source_arn = aws_cloudwatch_event_rule.every_five_minutes.arn
}
resource "aws_cloudwatch_event_rule" "refreshEC2" {
  name = "every-fifteen-minutes"
  description = "Fires every fifteen minutes"
  schedule_expression = "0/15 * * * ? *"
}

resource "aws_cloudwatch_event_target" "refreshEC2" {
  rule = aws_cloudwatch_event_rule.refreshEC2.name
  target_id = "refreshEC2"
  arn = aws_lambda_function.ec2Refresh.arn
}

resource "aws_lambda_permission" "allow_cloudwatch_to_call_ec2Refresh" {
  statement_id = "AllowExecutionFromCloudWatch"
  action = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ec2Refresh.function_name
  principal = "events.amazonaws.com"
  source_arn = aws_cloudwatch_event_rule.refreshEC2.arn
}
