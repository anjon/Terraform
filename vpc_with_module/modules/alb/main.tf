# Create ALB
resource "aws_lb" "dev-alb" {
  name               = "Dev-ALB"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.sg_id]
  subnets            = var.subnets
}

# Create Listener
resource "aws_lb_listener" "dev-alb-listener" {
  load_balancer_arn = aws_lb.dev-alb.arn
  port              = "80"
  protocol          = "HTTP"
  
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.dev-tg.arn
  }
}

# Create Target Group
resource "aws_lb_target_group" "dev-tg" {
  name     = "Dev-ALB-TG"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id
}

# Create Target Group Attachment
resource "aws_lb_target_group_attachment" "dev-alb-tga" {
  count = length(var.instances)
  target_group_arn = aws_lb_target_group.dev-tg.arn
  target_id        = var.instances[count.index]
  port             = 80
}