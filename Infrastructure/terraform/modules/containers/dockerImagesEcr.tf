module "docker_images_ecr" {
  source  = "terraform-module/ecr/aws"
  version = "~> 1.0"

  ecrs = {
    api = {
      tags = { Service = "api" }
      lifecycle_policy = {
        rules = [{
          rulePriority = 1
          description  = "keep last 2 images"
          action = {
            type = "expire"
          }
          selection = {
            tagStatus   = "any"
            countType   = "imageCountMoreThan"
            countNumber = 2
          }
        }]
      }
    }
  }
}
