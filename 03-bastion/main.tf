module "bastion" {

  source  = "terraform-aws-modules/ec2-instance/aws"
  name = "${var.project_name}-${var.environment}-bastion"
  instance_type   = "t3.micro"
  vpc_security_group_ids = [data.aws_ssm_parameter.bastion_sg_id.value]
  # convert StringList to list and get first element.
  subnet_id = local.public_subnet_id
  ami = data.aws_ami.ami_info.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-bastion"
    }
  )
}

module "records" {
  source  = "terraform-aws-modules/route53/aws//modules/records"
  version = "2.11.1"
  #zone_name = var.zone_name

  records = [
    {
        name    = "bastion"
        type    = "A"
        ttl     = 1
        records = [
            module.bastion.public_ip
        ]
    }
  ]
}