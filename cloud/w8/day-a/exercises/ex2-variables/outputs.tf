output "public_ip" {
  value       = aws_instance.ec2_ex2.public_ip
  description = "Public IP address of the EC2 instance"
}

output "private_ip" {
  value       = aws_instance.ec2_ex2.private_ip
  description = "Private IP address of the EC2 instance"
}
