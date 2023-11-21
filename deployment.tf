resource "aws_api_gateway_deployment" "dev" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id

#  triggers = {
#    redeployment = sha1(jsonencode(aws_api_gateway_rest_api.main_api.body))
#  }
#
#  depends_on = [
#    aws_api_gateway_method.methodproxy,
#    aws_api_gateway_integration.apilambda
#  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "dev" {
  deployment_id = aws_api_gateway_deployment.dev.id
  rest_api_id   = aws_api_gateway_rest_api.main_api.id
  stage_name    = "dev"
}
