resource "aws_sqs_queue" "deadletter" {
  name = "${var.aws_sqs_queue_name}-deadletter"

  ##Enabling  SQS encryption at rest to resolve Security Hub finding
  sqs_managed_sse_enabled = true

  tags = merge(var.tags, {
    deadletter = true
  })
}
