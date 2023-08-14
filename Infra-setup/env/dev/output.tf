output "instance_public_ip" {
  description = "Public IP of EC2 instance"
  value       = module.infraSetup.instance_public_ip
}
