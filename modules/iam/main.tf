resource "aws_iam_user" "this" {
  name = "my-user-1"  
}

resource "aws_iam_role" "role" {
  name               = "role-lab"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ] 
  })

  tags = {
    Name = "role-lab-5"
  }
}

resource "aws_iam_instance_profile" "ec2-profile" {
  name = "ec2-profile"
  role = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "pa" {
  role       = aws_iam_role.role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedEC2InstanceDefaultPolicy"
}
