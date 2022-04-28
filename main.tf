terraform {

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

data "terraform_remote_state" "vpc" {
  backend = "remote"
  config = {
    organization = "cedric"
    workspaces = {
      name = "apitest"
    }
  }
}

provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_instance" "app_server" {
  ami           = "${lookup(var.amis, var.region)}"
  instance_type = "t2.micro"
  subnet_id = data.terraform_remote_state.vpc.outputs.subnet_id

  tags = {
    Name = var.instance_name
  }
}

