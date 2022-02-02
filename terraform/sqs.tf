resource "aws_sqs_queue" "queue" {
  name                        = "test-queue.fifo"
  fifo_queue                  = true
  content_based_deduplication = true
}
