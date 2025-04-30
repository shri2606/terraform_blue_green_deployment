terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = var.security_group_ids
  subnet_id              = var.subnet_ids[count.index % length(var.subnet_ids)]
  iam_instance_profile   = var.iam_instance_profile
  user_data              = var.user_data
  tags = {
    Name        = "${var.environment}-instance-${count.index + 1}"
    Environment = var.environment
  }
}

resource "aws_lb_target_group_attachment" "this" {
  count = var.instance_count

  target_group_arn = var.target_group_arn
  target_id        = aws_instance.this[count.index].id
  port             = 80
}