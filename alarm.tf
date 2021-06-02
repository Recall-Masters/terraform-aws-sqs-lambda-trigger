resource "aws_cloudwatch_metric_alarm" "deadletter_queue_not_empty" {
  alarm_name          = "${var.aws_sqs_queue_name}-deadletter-queue-non-empty"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  threshold           = "0"
  alarm_description   = "${var.aws_sqs_queue_name} is not empty."
  alarm_actions       = var.alarm_actions

  metric_name = "NumberOfMessagesSent"
  namespace   = "AWS/SQS"
  period      = "300"
  statistic   = "Sum"
  unit        = "Count"
  dimensions = {
    QueueName = "${aws_sqs_queue.deadletter.name}"
  }
}
