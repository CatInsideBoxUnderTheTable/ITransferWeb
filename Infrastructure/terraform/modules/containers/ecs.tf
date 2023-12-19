locals {
  api_docker_image_url = module.docker_images_ecr.ecrs["api"].repository_url

}
resource "aws_cloudwatch_log_group" "log_group" {
  name = "${var.solution_name}-logs-${var.environment_name}"
}

resource "aws_ecs_cluster" "ecs_cluster" {
  name = "${var.solution_name}-cluster-${var.environment_name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  configuration {
    execute_command_configuration {
      # OVERRIDE:
      #
      # If you set logging to OVERRIDE, it means that you want to specify a custom log configuration 
      # using the log_configuration block within the aws_ecs_task_definition resource.
      #
      # The log_configuration block allows you to define the details of how and where the logs should be stored. 
      # This might include specifying the log driver, log options, and other logging-related configurations.
      logging = "OVERRIDE"

      log_configuration {
        cloud_watch_encryption_enabled = false
        cloud_watch_log_group_name     = aws_cloudwatch_log_group.log_group.name
      }
    }

  }
}

resource "aws_ecs_service" "app" {
  name            = "${var.solution_name}-ecs-${var.environment_name}"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.api_task_definition.id
  desired_count   = var.ecs_scaling.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets          = var.network_config.subnets_ids
    security_groups  = var.network_config.security_groups_ids
    assign_public_ip = false
  }

  load_balancer {
    container_name   = var.load_balancing.container_name
    container_port   = var.load_balancing.container_port
    target_group_arn = var.load_balancing.alb_target_group_arn
  }

}

data "aws_iam_policy_document" "task_execution_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "task_definition_execution_role" {
  name = "${var.solution_name}-api-task-definition-execution-role-${var.environment_name}"
  path = "/system/api"

  assume_role_policy = data.aws_iam_policy_document.task_execution_role_policy.json
}

resource "aws_ecs_task_definition" "api_task_definition" {
  family                   = "${var.solution_name}-api-task-family-${var.environment_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_definition_execution_role.arn

  container_definitions = jsonencode([
    {
      name  = "api-container",
      image = "${local.api_docker_image_url}"

      cpu    = 256 # Specify the CPU units (1 vCPU = 1024 units)
      memory = 512 # Specify the memory in MiB

      log_configuration = {
        log_driver = "awslogs"

        options = {
          "awslogs-group"         = "/ecs/${var.solution_name}-api-task-logs"
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }

      portMappings = [
        {
          hostPort      = var.load_balancing.application_port
          containerPort = var.load_balancing.container_port
        }
      ]

      environment = [
        {
          name  = "ENV_NAME",
          value = "VAL"
        }
      ]
    }
  ])
}


