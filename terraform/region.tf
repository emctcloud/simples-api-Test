data "aws_region" "current" {}
data "aws_caller_identity" "current" {}

data "terraform_remote_state" "network" {
  backend = "s3"

  config = {
    bucket = "emctx-terraform-ecs"
    key    = "terraform.tfstate"
    region = "${data.aws_region.current.name}"
  }
}