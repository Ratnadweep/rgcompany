terraform {
  backend "s3" {
    bucket         = "rg-terraform-state-689772cf912c" # shared bucket created by backend-bootstrap
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "rg-terraform-locks-689772cf"
    encrypt        = true
  }
}