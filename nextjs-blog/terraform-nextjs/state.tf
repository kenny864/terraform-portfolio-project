terraform {
  backend "s3" {
    bucket = "kjb-portfolio-project"
    key = "global/s3/terraform.tfstate"
    region = "us-east-1"
    use_lockfile = true
  }
}