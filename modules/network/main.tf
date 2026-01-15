resource "aws_vpc" "this" {
  cidr_block           = "10.0.0.0/16" 
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "vpc-lab5"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = aws_vpc.this.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = var.availability_zone

  tags = {
    Name = "private-sb-lab5"
  }
}

resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name = "private-rt-lab5"
  }
}

resource "aws_route_table_association" "private-as" {
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private.id
}

resource "aws_security_group" "private" {
  vpc_id = aws_vpc.this.id

  egress {
    from_port = 443  
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssm-endpoint" {
  vpc_id = aws_vpc.this.id

  ingress {
    from_port = 443
    to_port = 443
    protocol = "tcp"
    security_groups = [ aws_security_group.private.id ]
  }

  egress {
    from_port = 0  
    to_port = 0 
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_vpc_endpoint" "ssm" {
  vpc_id = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.private.id ]
  service_name = "com.amazonaws.ap-southeast-2.ssm"

  private_dns_enabled = true
  security_group_ids = [aws_security_group.ssm-endpoint.id]
}

resource "aws_vpc_endpoint" "ssmm" {
  vpc_id = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.private.id ]
  service_name = "com.amazonaws.ap-southeast-2.ssmmessages"
  
  private_dns_enabled = true
  security_group_ids = [aws_security_group.ssm-endpoint.id]
}

resource "aws_vpc_endpoint" "ec2m" {
  vpc_id = aws_vpc.this.id
  vpc_endpoint_type = "Interface"
  subnet_ids = [ aws_subnet.private.id ]
  service_name = "com.amazonaws.ap-southeast-2.ec2messages"

  private_dns_enabled = true
  security_group_ids = [aws_security_group.ssm-endpoint.id]
}
