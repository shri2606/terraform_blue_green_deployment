variable "environment" {
  description = "Environment name (e.g., prod, staging)"
  type        = string
}

variable "security_group_ids" {
  description = "List of security group IDs for the ALB"
  type        = list(string)
}

variable "subnet_ids" {
  description = "List of subnet IDs for the ALB"
  type        = list(string)
}

variable "vpc_id" {
  description = "VPC ID for the target groups"
  type        = string
}

variable "active_target_group" {
  description = "Which target group is currently active (blue or green)"
  type        = string
  default     = "blue"
} 