output queue {
  value = {
    arn = aws_sqs_queue.main.arn
    id  = aws_sqs_queue.main.id
  }
  description = "Incoming messages queue ARN and URL."
}


output deadletter {
  value = {
    arn = aws_sqs_queue.deadletter.arn
    id = aws_sqs_queue.deadletter.id
  }
  description = "Deadletter queue ARN and URL."
}

