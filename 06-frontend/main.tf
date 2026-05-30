module "frontend_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_info.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.frontend_sg_id.value]
# it should be in Expense DB subnet
  subnet_id = local.public_subnet_id
  user_data = file("frontend.sh")
  tags = merge(
    {
       Name = "${var.project_name}-${var.env}-frontend"
    },
    var.common_tags
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.1"
  zone_id = var.zone_id
  records = [
    {
        name    = "frontend"
        type    = "A"
        ttl     = 1
        records = [
            module.frontend_instance.public_ip
        ]
    }
  ]
   depends_on = [module.frontend_instance]
}