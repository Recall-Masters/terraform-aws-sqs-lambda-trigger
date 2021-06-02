resource "aws_sqs_queue" "deadletter" {
  name = "${var.aws_sqs_queue_name}-deadletter"
  tags = merge(var.tags, {
    deadletter = true
  })
}
