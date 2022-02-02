resource "aws_s3_bucket" "b" {
  bucket = "test-bucket"
  acl    = "public-read"
}

# Upload an object
resource "aws_s3_bucket_object" "object" {
  bucket = aws_s3_bucket.b.id
  key    = "testdata.json"
  acl    = "public-read"
  source = "../data/testdata.json"
}
