resource "aws_cloudwatch_metric_alarm" "deadletter_queue_not_empty" {
  alarm_name                = "${var.aws_sqs_queue_name}-deadletter-queue-non-empty"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  threshold                 = "0"
  alarm_description         = "${var.aws_sqs_queue_name} is not empty."
  alarm_actions             = var.alarm_actions

  metric_query {
    id          = "e1"
    expression  = "m1+m2"
    label       = "Messages available"
    return_data = "true"
  }

  metric_query {
    id = "m1"

    metric {
      metric_name = "ApproximateNumberOfMessagesVisible"
      namespace   = "AWS/SQS"
      period      = "600"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        QueueName = "${aws_sqs_queue.deadletter.name}"
      }
    }
  }

  metric_query {
    id = "m2"

    metric {
      metric_name = "ApproximateNumberOfMessagesNotVisible"
      namespace   = "AWS/SQS"
      period      = "600"
      stat        = "Sum"
      unit        = "Count"
      dimensions = {
        QueueName = "${aws_sqs_queue.deadletter.name}"
      }
    }
  }
}
