resource "aws_instance" "this" {
  ami                    = "ami-0b3c832b6b7289e44"
  instance_type          = "t3.micro"
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [ var.sg_id ]
  iam_instance_profile   = var.iam_ssm_profile

  tags = {
    Name = "ec2-app-lab5"
  }
}
