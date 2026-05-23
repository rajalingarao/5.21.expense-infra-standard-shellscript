module "backend_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  ami = data.aws_ami.ami_info.id
  instance_type = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.backend_sg_id.value]
# it should be in Expense DB subnet
  subnet_id = local.private_subnet_id
  user_data = file("backend.sh")
  tags = merge(
    {
       Name = "${var.project_name}-${var.env}-backend"
    },
    var.common_tags
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.1"
  #zone_name = var.zone_name
  records = [
    {
        name    = "backend"
        type    = "A"
        ttl     = 1
        records = [
            module.backend_instance.private_ip
        ]
    }
  ]
}