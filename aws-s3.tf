# Create bucket to store packaged code for lambda function.
resource "aws_s3_bucket" "this" {
  acl           = "private"
  force_destroy = true

  versioning {
    enabled = true
  }
}

data "aws_iam_policy_document" "bucket_policy" {
  statement {

    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    resources = [
      aws_s3_bucket.this.arn,
      "${aws_s3_bucket.this.arn}/*",
    ]
  }
}

resource "aws_s3_bucket_policy" "s3_bucket" {
  bucket = aws_s3_bucket.this.id
  policy = data.aws_iam_policy_document.bucket_policy.json
}
