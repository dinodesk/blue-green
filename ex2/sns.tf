
# SNS Topic
resource "aws_sns_topic" "my_topic" {
  name = "${var.sns_name}-sns-topic"
}
