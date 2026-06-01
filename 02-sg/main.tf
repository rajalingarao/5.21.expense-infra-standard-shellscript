########################################
# Security Groups
########################################

module "mysql" {
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"

  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "mysql"
  sg_description = "Security Group for MySQL Instance"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "backend" {
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"

  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "backend"
  sg_description = "Security Group for Backend Instance"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "frontend" {
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"

  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "frontend"
  sg_description = "Security Group for Frontend Instance"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

module "bastion" {
  source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"

  project_name   = var.project_name
  environment    = var.environment
  sg_name        = "bastion"
  sg_description = "Security Group for Bastion Instance"
  vpc_id         = data.aws_ssm_parameter.vpc_id.value
  common_tags    = var.common_tags
}

########################################
# MySQL Security Group Rules
########################################

# Allow Backend to connect to MySQL(services connect each other)
resource "aws_security_group_rule" "mysql_backend_3306" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.backend.sg_id
  security_group_id        = module.mysql.sg_id
}

# Allow Bastion to connect to MySQL(services connect each other)
resource "aws_security_group_rule" "mysql_bastion_3306" {
  type                     = "ingress"
  from_port                = 3306
  to_port                  = 3306
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql.sg_id
}

#We can login into mysql from bastion (ssh ec2-user@mysql.lithesh.shop)with 22 port.
resource "aws_security_group_rule" "mysql_bastion_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.mysql.sg_id
}

########################################
# Backend Security Group Rules
########################################

# Allow Frontend to access Backend(services connect each other)
resource "aws_security_group_rule" "backend_frontend_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.frontend.sg_id
  security_group_id        = module.backend.sg_id
}

# Allow Bastion to access Backend(services connect each other)
resource "aws_security_group_rule" "backend_bastion_8080" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend.sg_id
}
#We can login into backend from bastion (ssh ec2-user@backend.lithesh.shop)with 22 port.
resource "aws_security_group_rule" "backend_bastion_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.backend.sg_id
}
########################################
# Frontend Security Group Rules
########################################

# Allow Bastion to access Frontend on HTTP(services connect each other)
resource "aws_security_group_rule" "frontend_bastion_80" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.frontend.sg_id
}

# Allow public SSH access to Frontend(services connect each other)
resource "aws_security_group_rule" "frontend_public_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}

# Allow public HTTP access to Frontend(services connect each other)
resource "aws_security_group_rule" "frontend_public_80" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.frontend.sg_id
}
#We can login into backend from bastion (ssh ec2-user@frontend.lithesh.shop)with 22 port.
resource "aws_security_group_rule" "frontend_bastion_22" {
  type                     = "ingress"
  from_port                = 22
  to_port                  = 22
  protocol                 = "tcp"
  source_security_group_id = module.bastion.sg_id
  security_group_id        = module.frontend.sg_id
}
########################################
# Bastion Security Group Rules
########################################

# Allow public SSH access to Bastion
resource "aws_security_group_rule" "bastion_public_22" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = module.bastion.sg_id
}














# module "mysql" {
#   #source        = "../../../5.12.terraform-aws-securitygroup"
#   source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "SG for Mysql Instance"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   common_tags = var.common_tags
#   sg_name = "mysql"
# }

# module "backend" {
#   #source        = "../../../5.12.terraform-aws-securitygroup"
#   source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "SG for Backend Instance"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   common_tags = var.common_tags
#   sg_name = "backend"
# }

# module "frontend" {
#   #source        = "../../../5.12.terraform-aws-securitygroup"
#   source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "SG for Frontend Instance"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   common_tags = var.common_tags
#   sg_name = "frontend"
# }

# module "bastion" {
#   #source        = "../../../5.12.terraform-aws-securitygroup"
#   source = "git::https://github.com/rajalingarao/5.12.terraform-aws-securitygroup.git?ref=main"
#   project_name = var.project_name
#   environment = var.environment
#   sg_description = "SG for Bastion Instance"
#   vpc_id = data.aws_ssm_parameter.vpc_id.value
#   common_tags = var.common_tags
#   sg_name = "Bastion"
# }


# # mysql:
# # mysql is accepting connections from backend
# resource "aws_security_group_rule" "mysql_backend_3306" {
#   type      =  "ingress"
#   from_port = 3306
#   to_port =  3306
#   protocol = "tcp"
#   source_security_group_id = module.backend.sg_id
#   security_group_id = module.mysql.sg_id
# }
# resource "aws_security_group_rule" "mysql_bastion_3306" {
#   type      =  "ingress"
#   from_port = 3306
#   to_port =  3306
#   protocol = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.mysql.sg_id
# }

# # Backend:
# resource "aws_security_group_rule" "backend_frontend_8080" {
#   type      =  "ingress"
#   from_port = 8080
#   to_port =  8080
#   protocol = "tcp"
#   source_security_group_id = module.frontend.sg_id
#   security_group_id = module.backend.sg_id
# }
# resource "aws_security_group_rule" "backend_bastion_8080" {
#   type      =  "ingress"
#   from_port =  8080
#   to_port =  8080
#   protocol = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.backend.sg_id
# }
# # Frontend:
# resource "aws_security_group_rule" "frontend_bastion_80" {
#   type      =  "ingress"
#   from_port =  80
#   to_port =  80
#   protocol = "tcp"
#   source_security_group_id = module.bastion.sg_id
#   security_group_id = module.frontend.sg_id
# }

# resource "aws_security_group_rule" "frontend_public_ssh_22" {
#   type      =  "ingress"
#   from_port =  22
#   to_port =  22
#   protocol = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.frontend.sg_id
# }
# resource "aws_security_group_rule" "frontend_public_http_80" {
#   type      =  "ingress"
#   from_port =  80
#   to_port =  80
#   protocol = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.frontend.sg_id
# }
# # Bastion:
# resource "aws_security_group_rule" "bastion_public_22" {
#   type      =  "ingress"
#   from_port =  22
#   to_port =  22
#   protocol = "tcp"
#   cidr_blocks = ["0.0.0.0/0"]
#   security_group_id = module.bastion.sg_id
# }


