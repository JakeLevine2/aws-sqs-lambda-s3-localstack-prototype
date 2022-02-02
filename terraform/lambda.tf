data "archive_file" "lambda_zip" {
  type        = "zip"
  source_file = "../lambda/index.js"
  output_path = "lambda/lambda_function.zip"
}

resource "aws_lambda_function" "test_lambda" {
  filename         = "lambda/lambda_function.zip"
  function_name    = "test_lambda"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "index.handler"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs8.10"
}

resource "aws_lambda_function" "s3_reader" {
  filename         = "lambda/lambda_function.zip"
  function_name    = "s3_reader"
  role             = aws_iam_role.iam_for_lambda_tf.arn
  handler          = "index.s3reader"
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256
  runtime          = "nodejs8.10"
}

resource "aws_iam_policy" "lambda_policy" {
  name        = "lambda_policy"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:ListBucket",
        "s3:GetObject",
        "s3:CopyObject",
        "s3:HeadObject"
      ],
      "Effect": "Allow",
      "Resource": [
        "arn:aws:s3:::test-bucket/*"
      ]
    }
  ]
}
EOF
}

resource "aws_iam_role" "iam_for_lambda_tf" {
  name = "iam_for_lambda_tf"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "lambda.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "terraform_lambda_iam_policy_basic_execution" {
 role = "${aws_iam_role.iam_for_lambda_tf.id}"
 policy_arn = "${aws_iam_policy.lambda_policy.arn}"
}
