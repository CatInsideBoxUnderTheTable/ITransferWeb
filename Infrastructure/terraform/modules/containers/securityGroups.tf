resource "aws_security_group" "ecs_sg" {
  name   = "${var.solution_name}-ecs-sg-${var.environment_name}"
  vpc_id = var.vpc.id

  ingress {
    description     = "tcp from vpc to ECR api container"
    from_port       = 9000
    to_port         = 9000
    protocol        = "tcp"
    cidr_blocks     = [var.vpc.cidr_block]
    security_groups = var.network_config.security_groups_ids
  }

  //allow for access to ECR
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
