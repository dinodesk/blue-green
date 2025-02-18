
# Lambda Function
resource "aws_lambda_function" "my_lambda" {
  function_name = "${var.lambda_name}-lambda-function"
  handler       = "lambda_function.lambda_handler"
  runtime       = "python3.9"
  role          = aws_iam_role.lambda_exec_role.arn

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  environment {
    variables = {
      SNS_TOPIC_ARN = aws_sns_topic.my_topic.arn
    }
  }
  depends_on = [
    aws_cloudwatch_log_group.lambda_log_group
  ]
}

# Lambda IAM Role
resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda-exec-role"

  assume_role_policy = file("policies/lambda_assume_role_policy.json")
}

# Attach SQS Policy to Lambda Role
resource "aws_iam_role_policy" "lambda_sqs_policy" {
  role = aws_iam_role.lambda_exec_role.id
  policy = templatefile("policies/lambda_sqs_policy.json", {
    SQS_QUEUE_ARN = aws_sqs_queue.my_queue.arn
  })
}

# Attach SNS Policy to Lambda Role
resource "aws_iam_role_policy" "lambda_sns_policy" {
  role = aws_iam_role.lambda_exec_role.id
  policy = templatefile("policies/lambda_sns_policy.json", {
    SNS_TOPIC_ARN = aws_sns_topic.my_topic.arn
  })
}

# SQS Trigger for Lambda
resource "aws_lambda_event_source_mapping" "sqs_trigger" {
  event_source_arn = aws_sqs_queue.my_queue.arn
  function_name    = aws_lambda_function.my_lambda.arn
}

# Zip Lambda Function Code
data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/lambda"
  output_path = "${path.module}/lambda/lambda_function.zip"
}