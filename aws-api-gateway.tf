resource "aws_api_gateway_rest_api" "this" {
  name = var.unique_identifier

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_method" "this" {
  rest_api_id      = aws_api_gateway_rest_api.this.id
  resource_id      = aws_api_gateway_rest_api.this.root_resource_id
  http_method      = "GET"
  authorization    = "NONE"
  api_key_required = false
}

resource "aws_api_gateway_integration" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  resource_id = aws_api_gateway_method.this.resource_id
  http_method = aws_api_gateway_method.this.http_method

  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.this.invoke_arn
}

resource "aws_api_gateway_deployment" "this" {
  rest_api_id = aws_api_gateway_rest_api.this.id
  stage_name  = "prod"

  # Changes to the following values will cause the API stage to be redeployed.
  triggers = {
    redeployment = sha1(
      jsonencode([
        aws_api_gateway_method.this.id,
        aws_api_gateway_integration.this.id
        ]
      )
    )
  }

  lifecycle {
    create_before_destroy = true
  }

  depends_on = [
    # aws_api_gateway_integration.proxy_integration,
    aws_api_gateway_integration.this
  ]
}

# Allow this API Gateway to invoke/execute specified Lambda function.
resource "aws_lambda_permission" "permission" {
  statement_id  = "AllowPublicAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.this.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "${aws_api_gateway_rest_api.this.execution_arn}/*/*"
}
