terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" #The ~> operator means: Allow versions like 5.0.1, 5.1.3, etc., Don’t allow breaking upgrades like 6.0.0
    }
  }
  backend "s3" {
    bucket = "roboshop-env-prod"
    key    = "terraform-vpc_module"
    region = "us-east-1"
    # dynamodb_table = "roboshop_state"   ##using dynamoDB
    encrypt      = true
    use_lockfile = true # S3 native locking
  }
}

# Configure the AWS Provider
provider "aws" {
  # AWS CLI is already configured locally so we need not provide details if we want we can. It will auto detect
  # default profile, credentials ,region
  region = "us-east-1"
}