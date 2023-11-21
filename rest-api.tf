resource "aws_api_gateway_rest_api" "main_api" {
  name = "sy_terraform_05"

  tags = {
    stage = "dev"
  }

  description = "테라폼을 통한 api gateway 관리 테스트"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_model" "empty_model" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  name        = "EmptyModel"
  description = "Empty response model"
  content_type = "application/json"
  schema      = "{}"  # Adjust the schema as needed
}

resource "aws_api_gateway_resource" "recommends_brand_resource" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  parent_id   = aws_api_gateway_rest_api.main_api.root_resource_id
  path_part   = "recommends"
}

resource "aws_api_gateway_resource" "brand_subresource" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  parent_id   = aws_api_gateway_resource.recommends_brand_resource.id
  path_part   = "brand"
}

resource "aws_api_gateway_method" "get_brand_method" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  resource_id = aws_api_gateway_resource.brand_subresource.id
  http_method = "GET"

  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.hwahae_authorizer.id

  request_parameters = {
    "method.request.header.hwahae-platform"       = true
    "method.request.header.hwahae-app-HWAHAE_SERVER_API_VERSION"    = true
    "method.request.querystring.userId"           = true
  }

  request_models = {
    "application/json" = "Empty"  # Adjust the content type and schema as needed
  }

}

resource "aws_api_gateway_integration" "get_brand_integration" {
  rest_api_id             = aws_api_gateway_rest_api.main_api.id
  resource_id             = aws_api_gateway_resource.brand_subresource.id
  http_method             = aws_api_gateway_method.get_brand_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"

  uri = "http://${var.HWAHAE_SERVER_API_ALB}/${var.HWAHAE_SERVER_API_VERSION}/recommends/brand"

  request_parameters = {
    "integration.request.header.hwahae-platform"      = "method.request.header.hwahae-platform"
    "integration.request.header.hwahae-app-HWAHAE_SERVER_API_VERSION"   = "method.request.header.hwahae-app-HWAHAE_SERVER_API_VERSION"
    "integration.request.querystring.userId"          = "method.request.querystring.userId"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}


resource "aws_api_gateway_resource" "user_resource" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  parent_id   = aws_api_gateway_rest_api.main_api.root_resource_id
  path_part   = "users"
}

resource "aws_api_gateway_resource" "profile_subresource" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  parent_id   = aws_api_gateway_resource.user_resource.id
  path_part   = "profile"
}

resource "aws_api_gateway_method" "get_profile_method" {
  rest_api_id = aws_api_gateway_rest_api.main_api.id
  resource_id = aws_api_gateway_resource.profile_subresource.id
  http_method = "GET"

  authorization = "CUSTOM"
  authorizer_id = aws_api_gateway_authorizer.hwahae_authorizer.id

  request_parameters = {
    "method.request.header.hwahae-platform"       = true
    "method.request.header.hwahae-app-HWAHAE_SERVER_API_VERSION"    = true
    "method.request.querystring.userId"           = true
  }

  request_models = {
    "application/json" = "Empty"  # Adjust the content type and schema as needed
  }

}

resource "aws_api_gateway_integration" "get_profile_integration" {
  rest_api_id             = aws_api_gateway_rest_api.main_api.id
  resource_id             = aws_api_gateway_resource.profile_subresource.id
  http_method             = aws_api_gateway_method.get_profile_method.http_method
  integration_http_method = "GET"
  type                    = "HTTP_PROXY"

  uri = "http://${var.HWAHAE_SERVER_API_ALB}/${var.HWAHAE_SERVER_API_VERSION}/users/profile"

  request_parameters = {
    "integration.request.header.hwahae-platform"      = "method.request.header.hwahae-platform"
    "integration.request.header.hwahae-app-HWAHAE_SERVER_API_VERSION"   = "method.request.header.hwahae-app-HWAHAE_SERVER_API_VERSION"
    "integration.request.querystring.userId"          = "method.request.querystring.userId"
  }

  passthrough_behavior = "WHEN_NO_MATCH"
}
