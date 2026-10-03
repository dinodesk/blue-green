module "network" {
  source = "./modules/network"
  name_prefix = local.name_prefix
  container_port = var.container_port
  tags = local.common_tags
}

module "ecr" {
  source = "./modules/ecr"
  name_prefix = local.name_prefix
  tags = local.common_tags
}

module "iam" {
  source = "./modules/iam"
  name_prefix = local.name_prefix
  tags = local.common_tags
}

module "alb" {
  source = "./modules/alb"
  name_prefix = local.name_prefix
  vpc_id = module.network.vpc_id
  public_subnet_ids = module.network.public_subnet_ids
  alb_security_group = module.network.alb_security_group_id
  container_port = var.container_port
  health_check_path = var.health_check_path
  tags = local.common_tags
}

module "ecs" {
  source = "./modules/ecs"
  name_prefix = local.name_prefix
  cluster_name = local.name_prefix
  subnet_ids = module.network.public_subnet_ids
  security_group_id = module.network.ecs_security_group_id
  execution_role_arn = module.iam.execution_role_arn
  task_role_arn = module.iam.task_role_arn
  target_group_arn = module.alb.blue_target_group_arn
  container_port = var.container_port
  desired_count = var.desired_count
  cpu = var.cpu
  memory = var.memory
  image = var.bootstrap_image
  release_version = var.release_version
  environment = var.environment
  health_check_path = var.health_check_path
  aws_region = var.aws_region
  tags = local.common_tags
}

locals {
  name_prefix = "${var.project_name}-${var.environment}"
  common_tags = merge({
    Project = var.project_name
    Environment = var.environment
    Branch = var.branch_name
    ReleaseVersion = var.release_version
    ManagedBy = "terraform"
    Portfolio = "blue-green"
  }, var.tags)
}
