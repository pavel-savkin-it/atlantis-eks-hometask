terraform {
  backend "s3" {
    bucket         = ""
    key            = "dev/terraform.tfstate"
    region         = ""
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}
