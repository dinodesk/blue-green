provider "aws" {
  region = var.aws_region
}

resource "aws_cloudwatch_log_group" "lambda_log_group" {
  name              = "/aws/lambda/heinz-lambda-function"
  retention_in_days = 7
}

resource "aws_iam_role_policy" "lambda_logs_policy" {
  role = aws_iam_role.lambda_exec_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}


# resource "null_resource" "send_test_message" {
#   provisioner "local-exec" {
#     command = <<EOT
#       aws sqs send-message \
#         --queue-url ${aws_sqs_queue.my_queue.url} \
#         --message-body '{"key": "value"}'
#     EOT
#   }

#   depends_on = [aws_sqs_queue.my_queue]
# }