module "ec2_stack" {
  source                = "../../modules/ec2_stack"

  aws_region            = var.aws_region
  vpc_cidr              = var.vpc_cidr
  public_subnet_01_cidr = var.public_subnet_01_cidr
  public_subnet_02_cidr = var.public_subnet_02_cidr
  az1                   = var.az1
  az2                   = var.az2
  instance_type         = var.instance_type
  key_name              = var.key_name
}