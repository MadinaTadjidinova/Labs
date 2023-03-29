# 1) Store state file on S3 
terraform {
  backend "s3" {
    bucket         = "mybucket-terraform-1"
    key            = "aws-lab.tfstate"
    region         = "us-east-1"
    encrypt = true
  }
}