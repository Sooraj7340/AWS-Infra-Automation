
variable "vpc_id" {}

resource "aws_security_group" "jump_sg" {
  name        = "jump_sg"
  description = "Allow SSH"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

output "jump_sg_id" {
  value = aws_security_group.jump_sg.id
}
