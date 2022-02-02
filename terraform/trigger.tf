resource "aws_lambda_event_source_mapping" "test-lambda-trigger" {
  event_source_arn = "${aws_sqs_queue.queue.arn}"
  function_name    = "test_lambda"
  batch_size       = 2
}
