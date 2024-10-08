variable "aws_sqs_queue_name" {
  type        = string
  description = "Name of the AWS SQS queue to create and to listen to."
}

variable "aws_lambda_function_to_trigger" {
  # to avoid "data" directive usage which is causing 404 error for resources
  # add additional fields here if needed
  type        = object({
    function_name = string
    timeout       = number
  })
  description = "AWS Lambda function to trigger."
}

variable "aws_lambda_function_iam_role" {
  type        = object({
    name = string
  })
  description = "IAM role attached to Lambda function."
}


variable "visibility_timeout_seconds" {
  type        = number
  default     = null
  description = "The visibility timeout for the queue. An integer from 0 to 43200 (12 hours). Default value will be calculated as 6 * timeout of provided AWS Lambda function."
}

variable "delay_seconds" {
  type        = number
  default     = 0
  description = "The time in seconds that the delivery of all messages in the queue will be delayed. An integer from 0 to 900 (15 minutes)."
}


variable "batch_size" {
  type        = number
  default     = 10
  description = "The largest number of records that Lambda will retrieve from your event source at the time of invocation, from 1 to 10,000."
}


variable "maximum_batching_window_in_seconds" {
  type        = number
  default     = 0
  description = "The maximum amount of time to gather records before invoking the function, in seconds (between 0 and 300). Records will continue to buffer (or accumulate in the case of an SQS queue event source) until either maximum_batching_window_in_seconds expires or batch_size has been met. For a batch size over 10, you must also set the maximum_batching_window_in_seconds parameter to at least 1 second."
}


variable "enabled" {
  type        = bool
  default     = true
  description = "Determines if the mapping will be enabled on creation."
}


variable "deadletter_max_receive_count" {
  type        = number
  default     = 5
  description = "Max number of retries which will happen before the message will be sent to Deadletter queue."
}


variable "tags" {
  default     = {}
  description = "Tags to use for each of the created resources."
}


variable "aws_sqs_queue_policy" {
  description = "AWS SQS Queue Access Policy as a JSON string. Usable, say, to allow an S3 bucket to send notifications to this queue."
  type        = string
  default     = null
}


variable "alarm_actions" {
  type    = list(string)
  default = []
}
