data "aws_lambda_function" "auth_lambda" {
  function_name = "api_gateway_auth_dev_for_tf"
}
resource "aws_api_gateway_authorizer" "hwahae_authorizer" {
  name                   = "auth-dev"
  rest_api_id            = aws_api_gateway_rest_api.main_api.id
  authorizer_uri         = data.aws_lambda_function.auth_lambda.invoke_arn # 콘솔에서 얻을 수 있는 값이 아님. data를 선언해서 invoke_arn으로 가져올 것.
  authorizer_credentials = "arn:aws:iam::345616581939:role/all_permission-sykim"
}
