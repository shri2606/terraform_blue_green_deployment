terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_alb" "main" {
  name               = "${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = var.security_group_ids
  subnets            = var.subnet_ids

  enable_deletion_protection = true

  tags = {
    Environment = var.environment
  }
}

resource "aws_alb_target_group" "blue" {
  name     = "${var.environment}-blue-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_alb_target_group" "green" {
  name     = "${var.environment}-green-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 3
    interval            = 30
    matcher             = "200"
  }
}

resource "aws_alb_listener" "http" {
  load_balancer_arn = aws_alb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.active_target_group == "blue" ? aws_alb_target_group.blue.arn : aws_alb_target_group.green.arn
  }
}

resource "aws_alb_listener_rule" "blue" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 100

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.blue.arn
  }

  condition {
    path_pattern {
      values = ["/blue/*"]
    }
  }
}

resource "aws_alb_listener_rule" "green" {
  listener_arn = aws_alb_listener.http.arn
  priority     = 101

  action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.green.arn
  }

  condition {
    path_pattern {
      values = ["/green/*"]
    }
  }
} 