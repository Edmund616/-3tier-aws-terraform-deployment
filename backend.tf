terraform {
  backend "s3" {
    bucket         = "edmontons3bucket"
    encrypt        = true
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-lock-table"
  }
}