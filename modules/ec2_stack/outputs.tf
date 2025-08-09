output "instance_public_ips" {
  value = { for k, inst in aws_instance.demo-server : k => inst.public_ip }
}

output "instance_ids" {
  value = { for k, inst in aws_instance.demo-server : k => inst.id }
}