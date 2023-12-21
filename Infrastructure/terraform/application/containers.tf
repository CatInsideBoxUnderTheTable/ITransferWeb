module "containers" {
  source = "../modules/containers"

  environment_name = var.environment_name
  solution_name    = local.solution_name
  aws_region       = data.aws_region.current.name
  ecs_scaling = {
    desired_count = 1
  }

  vpc = {
    id         = module.vpc.vpc_id
    cidr_block = module.vpc.vpc_cidr_block
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

  secrets = {
    login_secret_id    = module.secrets.app_secrets.login_secret_id
    password_secret_id = module.secrets.app_secrets.password_secret_id

    console_login_secret_id    = module.secrets.app_aws_secrets.login_secret_id
    console_password_secret_id = module.secrets.app_aws_secrets.password_secret_id
  }

  data_storage_s3 = {
    bucket_name   = module.transfer_bucket.transfer_bucket_name
    bucket_region = module.transfer_bucket.transfer_bucket_region
  }
}
