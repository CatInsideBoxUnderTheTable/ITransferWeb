locals {
  alb_name = "${var.solution_name}-public-alb-${var.environment_name}"
}

resource "aws_alb" "public_alb" {
  name               = local.alb_name
  internal           = false
  load_balancer_type = "application"
  subnets            = var.public_subnets_ids
  security_groups    = [aws_security_group.alb_sg.id]

  drop_invalid_header_fields = true

  access_logs {
    bucket  = var.logging_bucket_name
    prefix  = "alb"
    enabled = true
  }
}

resource "aws_alb_target_group" "api_target_group" {
  depends_on = [aws_alb.public_alb]

  name_prefix = "in-api"
  vpc_id      = var.vpc.id
  protocol    = "HTTP"
  port        = var.forward_traffic_to_port
  target_type = "ip"

  health_check {
    enabled  = true
    port     = var.forward_traffic_to_port
    protocol = "HTTP"
    matcher  = "200-401" # we are using basicauth. Thus 401 will tell us that our service is runing

    timeout             = var.target_group_health_heck.check_timeout
    interval            = var.target_group_health_heck.interval
    healthy_threshold   = var.target_group_health_heck.min_successes_to_mark_as_healthy
    unhealthy_threshold = var.target_group_health_heck.min_failures_to_mark_as_unhealthy
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_alb_listener" "api_https_internet_listener" {
  load_balancer_arn = aws_alb.public_alb.arn
  port              = "443"
  protocol          = "HTTPS"

  default_action {
    type             = "forward"
    target_group_arn = aws_alb_target_group.api_target_group.arn
  }

  certificate_arn = module.acm.acm_certificate_arn
}

resource "aws_alb_listener" "api_http_internet_listener" {
  load_balancer_arn = aws_alb.public_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
