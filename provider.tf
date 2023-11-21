terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "sy_trf_test"

    workspaces {
      name = "learn-terraform-github-actions"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}
