resource "aws_security_group" "alb_sg" {
  name   = "${var.solution_name}-alb-sg-${var.environment_name}"
  vpc_id = var.vpc.id

  ingress {
    description = "tcp from vpc"
    // from port to port ---> that's range
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc.cidr_block]

  }

  // to allow for access to ECR
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}
