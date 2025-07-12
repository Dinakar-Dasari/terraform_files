
bucket = "roboshop-env-prod"
key            = "terraform-roboshop-prod"
region         = "us-east-1"
# dynamodb_table = "roboshop_state"   ##using dynamoDB
encrypt      = true
use_lockfile = true  # S3 native locking "