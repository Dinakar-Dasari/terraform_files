terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" #The ~> operator means: Allow versions like 5.0.1, 5.1.3, etc., Don’t allow breaking upgrades like 6.0.0
    }
  }

  backend "s3" {

  }
}

# Configure the AWS Provider
provider "aws" {
  # AWS CLI is already configured locally so we need not provide details if we want we can. It will auto detect
  # default profile, credentials ,region
}