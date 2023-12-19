module "containers" {
  source = "../modules/containers"

  environment_name = var.environment_name
  solution_name    = local.solution_name
  aws_region       = data.aws_region.current.name
  ecs_scaling = {

    desired_count = 2
  }
  load_balancing = {
    container_name       = "api"
    container_port       = local.api_port
    application_port     = local.api_port
    alb_target_group_arn = module.publicAlb.api_alb_target_group_arn
  }

  network_config = {
    subnets_ids         = module.vpc.public_subnets_ids
    security_groups_ids = [module.publicAlb.api_alb_security_group_id]
  }
}
