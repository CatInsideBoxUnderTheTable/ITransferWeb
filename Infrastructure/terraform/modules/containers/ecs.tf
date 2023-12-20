locals {
  api_docker_image_url = module.docker_images_ecr.urls["api"]
  api_log_group_name   = "/ecs/${var.solution_name}-logs-${var.environment_name}"
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
    subnets         = var.network_config.subnets_ids
    security_groups = var.network_config.security_groups_ids
    # This is necessary for Fargate tasks to have internet access. 
    # Fargate tasks launched in a private subnet need a public IP to route traffic through a NAT gateway.
    assign_public_ip = true
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

data "aws_iam_policy_document" "task_execution_privilages" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetAuthorizationToken",
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = ["arn:aws:ecr:${var.aws_region}:*", aws_cloudwatch_log_group.log_group.arn]
  }
}

resource "aws_iam_role" "task_definition_execution_role" {
  name = "${var.solution_name}-api-task-definition-execution-role-${var.environment_name}"
  path = "/system/api/"

  assume_role_policy = data.aws_iam_policy_document.task_execution_role_policy.json

  inline_policy {
    name   = "${var.solution_name}-api-task-definition-execution-role-privilages-${var.environment_name}"
    policy = data.aws_iam_policy_document.task_execution_privilages.json
  }
}

resource "aws_cloudwatch_log_group" "log_group" {
  name              = local.api_log_group_name
  retention_in_days = 7
}

resource "aws_ecs_task_definition" "api_task_definition" {
  family                   = "${var.solution_name}-api-task-family-${var.environment_name}"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn       = aws_iam_role.task_definition_execution_role.arn

  //todo: move to variables
  cpu    = 256 # Specify the CPU units (1 vCPU = 1024 units)
  memory = 512 # Specify the memory in MiB

  container_definitions = jsonencode([
    {
      name  = var.load_balancing.container_name
      image = local.api_docker_image_url

      essential = true

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          "awslogs-group"         = local.api_log_group_name
          "awslogs-region"        = var.aws_region
          "awslogs-create-group"  = tostring(true)
          "awslogs-stream-prefix" = "ecs"
        }
      }

      portMappings = [
        {
          hostPort      = tonumber(var.load_balancing.application_port)
          containerPort = tonumber(var.load_balancing.container_port)
        }
      ]

      environment = [
        {
          name  = "APP_LOGIN",
          value = data.aws_secretsmanager_secret_version.app_login.secret_string
        },
        {
          name  = "APP_PASSWORD",
          value = data.aws_secretsmanager_secret_version.app_password.secret_string
        },
        {
          name  = "AWS_CONSOLE_LOGIN",
          value = data.aws_secretsmanager_secret_version.console_login.secret_string
        },
        {
          name  = "AWS_CONSOLE_KEY",
          value = data.aws_secretsmanager_secret_version.console_password.secret_string
        },
        {
          name  = "AWS_STORAGE_BUCKET_NAME",
          value = var.data_storage_s3.bucket_name
        },
        {
          name  = "AWS_STORAGE_BUCKET_REGION",
          value = var.data_storage_s3.bucket_region
        },
      ]
    }
  ])
}


