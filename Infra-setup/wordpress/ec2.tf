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

  owners = ["452584365305"] # Canonical
}

resource "aws_instance" "management" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.management.id]
  # subnet_id              =  subnet_id value if you want to deployin specific subnet 
  tags = {
    Name = "${lower(var.project_name)}-${lower(var.env)}-server"
  }

  lifecycle {
    ignore_changes = [
      tags["wordpress-nginx"]
    ]
  }
}