# aws-sqs-lambda-s3-localstack-prototype
Prototype project for demonstrating using terraform to set up SQS, Lambda, and S3 resources in a Localstack environment, and doling some basic processing.

## Dependancies
* Docker/Docker Compose
* Localstack
* Terraform

## How to use

Start docker:

```
docker-compose up
```

Init Terraform:

```
cd terraform/
terraform init
```

Create resources

```
terraform apply
```

Invoke s3_reader Lambda

```
aws --region=us-east-1 --endpoint-url=http://localhost:4566 lambda invoke --function=s3_reader outputfile.txt
```

View logs

```
aws --region=us-east-1 --endpoint-url=http://localhost:4566 logs tail /aws/lambda/test_lambda
aws --region=us-east-1 --endpoint-url=http://localhost:4566 logs tail /aws/lambda/s3_reader
```
