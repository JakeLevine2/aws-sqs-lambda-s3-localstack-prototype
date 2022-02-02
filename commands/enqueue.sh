aws --region=us-east-1 --endpoint-url=http://localhost:4566 sqs send-message --queue-url="http://localhost:4566/000000000000/test-queue.fifo" --message-body='{"test":"blah"}' --message-group-id=123
