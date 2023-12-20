resource "aws_security_group" "alb_sg" {
  name   = "${var.solution_name}-ecs-api-sg-${var.environment_name}"
  vpc_id = var.vpc.id

  //todo: further restrict access
  ingress {
    description = "tcp from vpc"
    // from port to port ---> that's range
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc.cidr_block]
  }
}