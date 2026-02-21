terraform {
  backend "s3" {
    bucket         = "tf-state-memos-0305jk"
    key            = "terraform.tfstate"
    region         = "eu-west-2"
    encrypt        = true
    dynamodb_table = "tf-lock-memos-0305jk"
  }
}

