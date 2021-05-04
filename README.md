# sqs-lambda-trigger

Terraform module which accepts a Lambda function name and a few parameters. Based on those inputs, it constructs:

- SQS queue for incoming events;
- Event source mapping to trigger the provided Lambda from the aforementioned queue;
- Deadletter queue to house messages on which Lambda failed.

## Usage

```hcl
module trigger-execution-logger {
  source = "../sqs-lambda-trigger"
  aws_sqs_queue_name = "${var.application_name}-events"

  aws_lambda_function_name = aws_lambda_function.this.function_name
  aws_lambda_function_iam_role_name = aws_iam_role.this.name
  batch_size = 100
  maximum_batching_window_in_seconds = 20
}
```

## Outputs

- `module.trigger-execution-logger.queue.arn` is the ARN of the queue that will trigger the Lambda,
- `module.trigger-execution-logger.queue.id` is its URL,
- `module.trigger-execution-logger.deadletter.arn` is the ARN for deadletter queue,
- `module.trigger-execution-logger.deadletter.id` is obviously deadletter queue URL.

## Decisions

### Create the incoming messages SQS queue inside the module

Originally, I intended to accept a parameter named `aws_sqs_queue_arn` so that the user might create their own queue, but that makes impossible to configure `redrive_policy` for dead letter functionality. Thus, I had to resort to creation of the queue inside the module.


## Motivation

The pattern of linking an SQS queue to a Lambda function is something that happens very often in our work. There are some best practices to follow:

- Lambda function must have certain permissions to the SQS queue;
- Visibility timeout of the queue must be >= 6 * lambda function timeout;
- There *should* be a dead letter queue - that will be a safety measure against a Lambda that's continuously failing and burning money like crazy.

## Future developments

There should be a way to notify the development team (via Slack directly, or via Sentry which then will post to Slack) about non-empty deadletter queues. That is always something to investigate.

## Alternatives

### Not useful

- [terraform-aws-lambda](https://github.com/terraform-aws-modules/terraform-aws-lambda) handles creation of an Event Source Mapping plus a lot of other stuff which is, to my opinion, much too monstrous.
- [event-source-mapping example](https://github.com/terraform-aws-modules/terraform-aws-lambda/blob/v1.47.0/examples/event-source-mapping/main.tf) is just an example, not reusable at all.
- [queue-driven-lambda](https://registry.terraform.io/modules/bmd/queue-driven-lambda/aws/latest) is **almost** the same as this module but not quite: it takes on the responsibility of *creating* the Lambda which I wanted to avoid.
- [serverless-common-sqs-lambda](https://registry.terraform.io/modules/vladcar/serverless-common-sqs-lambda/aws/latest?tab=inputs) the same as in previous item.

### Useful

- [sqs-with-dlq](https://registry.terraform.io/modules/damacus/sqs-with-dlq/aws/latest?tab=inputs) - this one is nice and supports CloudWatch Alarms when deadletter queue has messages in it. Can be used. 
