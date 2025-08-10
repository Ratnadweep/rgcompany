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

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
  }
}

module "asg_ansible" {
  source             = "../../modules/asg_stack"
  name               = "ansible-asg"
  desired_capacity   = 1
  instance_type      = "t2.micro"
  security_group_ids = [module.ec2_stack.demo_sg_id]
  subnet_ids         = [module.ec2_stack.public_subnet_01_id, module.ec2_stack.public_subnet_02_id]
  key_name           = var.key_name
  role               = "ansible"
}

module "asg_jenkins_master" {
  source             = "../../modules/asg_stack"
  name               = "jenkins-master-asg"
  desired_capacity   = 1
  instance_type      = "t2.micro"
  security_group_ids = [module.ec2_stack.demo_sg_id]
  subnet_ids         = [module.ec2_stack.public_subnet_01_id, module.ec2_stack.public_subnet_02_id]
  key_name           = var.key_name
  role               = "jenkins-master"
}

module "asg_build_slave" {
  source             = "../../modules/asg_stack"
  name               = "build-slave-asg"
  desired_capacity   = 1
  instance_type      = "t2.micro"
  security_group_ids = [module.ec2_stack.demo_sg_id]
  subnet_ids         = [module.ec2_stack.public_subnet_01_id, module.ec2_stack.public_subnet_02_id]
  key_name           = var.key_name
  role               = "build-slave"
}
