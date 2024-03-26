terraform {
  backend "s3" {
    bucket = "np-iac-lab-tfstate"
    key    = "np-iac-lab/tfstate.terraform"
    region = "ap-southeast-2"

    dynamodb_table = "np-iac-lab-tfstate-locks"
    encrypt        = true
  }
}