resource "aws_iam_policy" "lambda_logging" {
  name        = "lambda_logging"
  path        = "/"
  description = "IAM policy for lambda"

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [{
        "Action": [
            "logs:*",
            "sns:*",
            "states:*",
            "s3:*",
            "sqs:*",
            "ec2:*",
            "lambda:InvokeFunction",
            "iam:ListRoles",
            "iam:ListInstanceProfiles",
            "iam:PassRole",
            "cloudwatch:GetMetricStatistics"
        ],
        "Effect": "Allow",
        "Resource": "*"
    }]
}
EOF

}

resource "aws_iam_role" "iam_for_lambda" {
  name = "iam_for_lambda"

  assume_role_policy = <<EOF
{ "Version": "2012-10-17",
  "Statement": [
      {
      "Action": "sts:AssumeRole",
      "Principal": {
          "Service": "lambda.amazonaws.com",
          "Service": "states.amazonaws.com"
      },
      "Effect": "Allow"
  }]
}
EOF
}

resource "aws_iam_role_policy_attachment" "lambda_logs" {
  role       = aws_iam_role.iam_for_lambda.name
  policy_arn = aws_iam_policy.lambda_logging.arn
}

########### Lambda ###########
resource "aws_lambda_function" "step-validate" {
  function_name    = "${var.environment_prefix}-step-validate"
  handler          = "com.github.demo.aws.lambda.ValidateLambda::handleRequest"
  runtime          = "java8"
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = "${path.module}/target/${var.jar_file}"
  source_code_hash = filebase64sha256("${path.module}/target/${var.jar_file}")
  memory_size      = 512
  timeout          = 300

  environment {
    variables = {
      sns_topic = "${var.sns_topic}",
      DD_JMXFETCH_ENABLED = false,
      DD_TRACE_ENABLED = true,
      DD_LOGS_INJECTION = true
      DD_SITE = "https://app.datadoghq.com",
      DD_API_KEY = var.api_key
    }
  }

  tags = {
    "env" = "ccoe-poc",
    "service" = "lambda",
    "version" = 1
  }
}

resource "aws_lambda_function" "step-process" {
  function_name    = "${var.environment_prefix}-step-process"
  handler          = "com.github.demo.aws.lambda.ProcessLambda::handleRequest"
  runtime          = "java8"
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = "${path.module}/target/${var.jar_file}"
  source_code_hash = filebase64sha256("${path.module}/target/${var.jar_file}")
  memory_size      = 512
  timeout          = 300

  environment {
    variables = {
      sns_topic = "${var.sns_topic}",
      DD_JMXFETCH_ENABLED = false,
      DD_TRACE_ENABLED = true,
      DD_LOGS_INJECTION = true
      DD_SITE = "https://app.datadoghq.com",
      DD_API_KEY =  var.api_key
    }
  }

  tags = {
    "env" = "ccoe-poc",
    "service" = "lambda",
    "version" = 1
  }
}

resource "aws_lambda_function" "step-exception" {
  function_name    = "${var.environment_prefix}-step-exception"
  handler          = "com.github.demo.aws.lambda.ExceptionLambda::handleRequest"
  runtime          = "java8"
  role             = aws_iam_role.iam_for_lambda.arn
  filename         = "${path.module}/target/${var.jar_file}"
  source_code_hash = filebase64sha256("${path.module}/target/${var.jar_file}")

  memory_size      = 512
  timeout          = 300

  environment {
    variables = {
      sns_topic = "${var.sns_topic}",
      DD_JMXFETCH_ENABLED = false,
      DD_TRACE_ENABLED = true,
      DD_LOGS_INJECTION = true
      DD_SITE = "https://app.datadoghq.com",
      DD_API_KEY =  var.api_key
    }
  }

  tags = {
    "env" = "ccoe-poc",
    "service" = "aws.lambda",
    "version" = 1
  }
}