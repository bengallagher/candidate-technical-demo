# IAM Role for Lambda function.
resource "aws_iam_role" "lambda" {
  assume_role_policy = data.aws_iam_policy_document.lambda_assume.json
}

# Assume Role Policy for Lamba Function
data "aws_iam_policy_document" "lambda_assume" {
  statement {
    sid     = "LambdaAssumesThisRole"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

# Policy Document for Lambda Function
data "aws_iam_policy_document" "lambda_permission" {
  statement {
    actions = [
      "sts:*"
    ]

    resources = ["*"]
  }

  statement {

    actions = [
      "logs:CreateLogGroup"
    ]

    resources = [
      "arn:aws:logs:*:*:*"
    ]
  }

  statement {
    sid = "LambdaAllowAccessToCloudWatchEvents"

    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]

    resources = [
      "${aws_cloudwatch_log_group.this.arn}:*"
    ]
  }
}

# Attach Policy to Role.
resource "aws_iam_role_policy" "lambda" {
  role   = aws_iam_role.lambda.id
  policy = data.aws_iam_policy_document.lambda_permission.json
}