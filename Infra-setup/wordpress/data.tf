data "aws_caller_identity" "current" {}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["amazon"] # Canonical
}

data "aws_ssm_parameter" "vpcid" {
  name = "corevpcid"
}

data "aws_ssm_parameter" "vpcsubnet" {
  name = "vpcsubnet"
}
