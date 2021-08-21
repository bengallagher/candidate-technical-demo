output "this_lambda_arn" {
  value = aws_lambda_function.this.arn
}

output "this_invoke_url" {
  value = aws_api_gateway_deployment.this.invoke_url
}