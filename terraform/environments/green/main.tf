module "ec2" {
  source = "../../modules/ec2"

  instance_count       = var.instance_count
  subnet_ids           = var.subnet_ids
  instance_type        = var.instance_type
  ami                  = var.ami
  security_group_ids   = var.security_group_ids
  environment          = "green"
  iam_instance_profile = aws_iam_instance_profile.ec2_cloudwatch_profile.name
  target_group_arn     = var.target_group_arn
  user_data            = <<-EOF
                          #!/bin/bash
                          sudo yum update -y
                          sudo yum install -y amazon-cloudwatch-agent
                          sudo tee /opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json <<-EOC
                          {
                              "agent": {
                                  "metrics_collection_interval": 60,
                                  "run_as_user": "root"
                              },
                              "logs": {
                                  "logs_collected": {
                                      "files": {
                                          "collect_list": [
                                              {
                                                  "file_path": "/var/log/messages",
                                                  "log_group_name": "/aws/ec2/green-messages",
                                                  "log_stream_name": "{instance_id}"
                                              }
                                          ]
                                      }
                                  }
                              }
                          }
                          EOC
                          sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a start -c file:/opt/aws/amazon-cloudwatch-agent/etc/amazon-cloudwatch-agent.json
                          EOF
}

resource "aws_iam_role" "ec2_cloudwatch_role" {
  name = "green-ec2-cloudwatch-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
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
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_policy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.ec2_cloudwatch_role.name
}

resource "aws_iam_instance_profile" "ec2_cloudwatch_profile" {
  name = "green-ec2-cloudwatch-profile"
  role = aws_iam_role.ec2_cloudwatch_role.name
} 