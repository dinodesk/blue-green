# SQS Queue
resource "aws_sqs_queue" "my_queue" {
  name = "${var.sqs_name}-sqs-queue"
}
