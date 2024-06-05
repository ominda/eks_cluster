terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.45.0"
    }
  }
}

provider "aws" {
  region = var.v_region
  default_tags {
    tags = {
      Project     = var.v_default_tags["project"]
      Environment = var.v_default_tags["environment"]
      Owner       = var.v_default_tags["owner"]
      Identifier  = var.v_default_tags["identifier"]
    }
  }
}