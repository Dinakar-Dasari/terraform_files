terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" #The ~> operator means: Allow versions like 5.0.1, 5.1.3, etc., Don’t allow breaking upgrades like 6.0.0
    }
  }
}

# Configure the AWS Provider
# creating a resource in 2 different aws accounts.

## we need to congifure in CLI with aws configure --profile dev
## we need to congifure in CLI with aws configure --profile prod

provider "aws" {
  alias = "dev"
  profile = "dev"
}

provider "aws" {
  alias = "prod"
  profile = "prod"
}

