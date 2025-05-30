terraform {
  required_version = ">= 1.5.0, < 2.0.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.17"
    }
    time = {
      source  = "hashicorp/time"
      version = "0.11.1"
    }
  }
}
