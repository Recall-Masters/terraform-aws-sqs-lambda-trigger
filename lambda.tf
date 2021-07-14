data "aws_lambda_function" "lambda" {
  function_name = var.aws_lambda_function_to_trigger.name

  depends_on = [
    var.aws_lambda_function_to_trigger
  ]
}
