# Create archive of local source code.
data "archive_file" "this" {
  type        = "zip"
  output_path = "/tmp/lambda.zip"
  source_dir  = "${path.module}/src"
}

# Create random id to use with S3 object id.
resource "random_id" "id" {
  byte_length = 10
}

# Upload code archive to S3.
resource "aws_s3_bucket_object" "this" {
  key    = random_id.id.b64_url
  bucket = aws_s3_bucket.this.id
  source = data.archive_file.this.output_path
  etag   = data.archive_file.this.output_base64sha256
}

# Create lambda function from uploaded source code.
resource "aws_lambda_function" "this" {
  s3_bucket        = aws_s3_bucket.this.id
  s3_key           = aws_s3_bucket_object.this.id
  source_code_hash = data.archive_file.this.output_base64sha256

  function_name = var.unique_identifier
  handler       = "app.lambda_handler"
  role          = aws_iam_role.lambda.arn
  runtime       = "python3.9"
  timeout       = "5"
}

# Log group with minimum retention.
resource "aws_cloudwatch_log_group" "this" {
  name              = "/aws/lambda/${var.unique_identifier}"
  retention_in_days = 1
}