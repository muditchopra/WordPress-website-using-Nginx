resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t3.micro"
  key_name               = var.key_name
  vpc_security_group_ids = [aws_security_group.web_server.id]
  subnet_id              = data.aws_ssm_parameter.vpcsubnet.value #if you want to deployin specific subnet 
  tags = {
    Name = "${lower(var.project_name)}-${lower(var.env)}-server"
  }

  lifecycle {
    ignore_changes = [
      tags["wordpress-nginx"]
    ]
  }
}
