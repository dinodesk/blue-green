# variable "environment" {}
variable "lambda_name" {
  description = "lambda name"
  default     = "heinz"
}
variable "sqs_name" {
  description = "SQS name"
  default     = "tomato"
}

variable "sns_name" {
  description = "ketchup"
  default     = "ketchup"
}
# variable "handler" {}
# variable "runtime" {}
# variable "timeout" {}

variable "aws_region" {
  description = "AWS region"
  default     = "us-east-1"
}