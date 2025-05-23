
variable "subnet_id" {}

resource "aws_eip" "nat" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat.id
  subnet_id     = var.subnet_id
  depends_on    = [aws_eip.nat]
}

output "nat_gateway_id" {
  value = aws_nat_gateway.nat.id
}
