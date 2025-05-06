
variable "subnet_ids" {}
variable "sg_id" {}

resource "aws_lb" "app_lb" {
  name               = "app-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = var.subnet_ids
  security_groups    = [var.sg_id]
}

output "lb_dns_name" {
  value = aws_lb.app_lb.dns_name
}
