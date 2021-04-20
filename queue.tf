locals {
  # https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html#events-sqs-queueconfig
  # To allow your function time to process each batch of records, set the source queue's visibility timeout to at least 6 times the timeout that you configure on your function. The extra time allows for Lambda to retry if your function execution is throttled while your function is processing a previous batch.
  visibility_timeout_seconds = coalesce(
    # Use whatever the user provided if it is not null
    var.visibility_timeout_seconds,
    # But if it is - calculate our own value
    data.aws_lambda_function.lambda.timeout * 6,
  )
}


resource aws_sqs_queue main {
  name = var.aws_sqs_queue_name
  visibility_timeout_seconds = local.visibility_timeout_seconds
  delay_seconds = var.delay_seconds

  redrive_policy = jsonencode({
    deadLetterTargetArn = aws_sqs_queue.deadletter.arn
    maxReceiveCount = var.deadletter_max_receive_count
  })

  tags = var.tags
}
