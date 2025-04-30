output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_alb.this.dns_name
}

output "blue_target_group_arn" {
  description = "ARN of the blue target group"
  value       = aws_alb_target_group.blue.arn
}

output "green_target_group_arn" {
  description = "ARN of the green target group"
  value       = aws_alb_target_group.green.arn
}

output "alb_arn" {
  description = "ARN of the ALB"
  value       = aws_alb.this.arn
} 