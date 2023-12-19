output "vpc_id" {
  value = module.vpc.vpc_id
}
output "vpc_cidr_block" {
  value = var.vpc_cidr
}

output "public_subnets_ids" {
  value = module.vpc.public_subnets
}
