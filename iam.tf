data "aws_iam_policy_document" "this" {
  # https://docs.aws.amazon.com/lambda/latest/dg/with-sqs.html#events-sqs-queueconfig
  statement {
    effect    = "Allow"
    actions   = [
      "sqs:ReceiveMessage",
      "sqs:DeleteMessage",
      "sqs:GetQueueAttributes",
    ]
    resources = [
      aws_sqs_queue.main.arn]
  }
}


resource "aws_iam_policy" "this" {
  policy      = data.aws_iam_policy_document.this.json
  description = "Grant the Lambda function the required SQS permissions."
}


resource "aws_iam_role_policy_attachment" "this" {
  policy_arn = aws_iam_policy.this.arn
  role       = var.aws_lambda_function_iam_role.name
}
