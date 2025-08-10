output "vpc_id" {
  value = aws_vpc.dpp-vpc.id
}

output "public_subnet_01_id" {
  value = aws_subnet.dpp-public-subnet-01.id
}

output "public_subnet_02_id" {
  value = aws_subnet.dpp-public-subnet-02.id
}

output "demo_sg_id" {
  value = aws_security_group.demo-sg.id
}
