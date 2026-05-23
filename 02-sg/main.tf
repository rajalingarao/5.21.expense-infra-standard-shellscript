module "mysql" {
  #source        = "../../../5.12.terraform-aws-securitygroup"
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Mysql Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "mysql"
}

module "backend" {
  #source        = "../../../5.12.terraform-aws-securitygroup"
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Backend Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "backend"
}

module "frontend" {
  #source        = "../../../5.12.terraform-aws-securitygroup"
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Frontend Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "frontend"
}

module "bastion" {
  #source        = "../../../5.12.terraform-aws-securitygroup"
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
  project_name = var.project_name
  environment = var.environment
  sg_description = "SG for Bastion Instance"
  vpc_id = data.aws_ssm_parameter.vpc_id.value
  common_tags = var.common_tags
  sg_name = "Bastion"
}


# mysql:
# mysql is accepting connections from backend
resource "aws_security_group_rule" "mysql_backend_3306" {
  type      =  "ingress"
  from_port = 3306
  to_port =  3306
  protocol = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id = module.mysql.sg_id
}
resource "aws_security_group_rule" "mysql_bastion_3306" {
  type      =  "ingress"
  from_port = 3306
  to_port =  3306
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.mysql.sg_id
}

# Backend:
resource "aws_security_group_rule" "backend_frontend_8080" {
  type      =  "ingress"
  from_port = 8080
  to_port =  8080
  protocol = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id = module.backend.sg_id
}
resource "aws_security_group_rule" "backend_bastion_8080" {
  type      =  "ingress"
  from_port =  8080
  to_port =  8080
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.backend.sg_id
}
# Frontend:
resource "aws_security_group_rule" "frontend_bastion_80" {
  type      =  "ingress"
  from_port =  80
  to_port =  80
  protocol = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id = module.frontend.sg_id
}

resource "aws_security_group_rule" "frontend_public_ssh_22" {
  type      =  "ingress"
  from_port =  22
  to_port =  22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}
resource "aws_security_group_rule" "frontend_public_http_80" {
  type      =  "ingress"
  from_port =  80
  to_port =  80
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}
# Bastion:
resource "aws_security_group_rule" "bastion_public_22" {
  type      =  "ingress"
  from_port =  22
  to_port =  22
  protocol = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}


