resource "aws_sfn_state_machine" "main-workflow" {
  name       = "${var.environment_prefix}-main-workflow"
  role_arn   = aws_iam_role.iam_for_lambda.arn
  definition = <<EOF
{
  "StartAt": "Validate",
  "States": {
    "Validate": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-validate.arn}",
      "Next": "Process",
      "TimeoutSeconds": 120,
      "Catch" : [{
        "ErrorEquals" : ["States.ALL"],
        "ResultPath": "$.error",
        "Next" : "Exception"
      }]
    },
    "Process": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-process.arn}",
      "Next": "Succeeded",
      "TimeoutSeconds": 120,
      "Catch" : [{
        "ErrorEquals" : ["States.ALL"],
        "ResultPath": "$.error",
        "Next" : "Exception"
      }]
    },
    "Exception" : {
      "Type": "Task",
      "Resource": "${aws_lambda_function.step-exception.arn}",
      "ResultPath": "$.error.exception_handled",
      "Next" : "Failed"
    },
    "Succeeded" : {
      "End" : true,
      "Type" : "Pass"
    },
    "Failed": {
      "Type": "Fail"
    }
  }
}
EOF

 tags = {
    "env" = "ccoe-poc",
    "service" = "lambda",
    "version" = 1
 }

 logging_configuration {
    log_destination        = "${aws_cloudwatch_log_group.std.arn}:*"
    include_execution_data = true
    level                  = "ALL"
  }

}


resource "aws_cloudwatch_log_group" "std" {
  name = "std-log-lambda"

  tags = {
    "env" = "ccoe-poc",
    "service" = "lambda",
    "version" = 1
 }
}