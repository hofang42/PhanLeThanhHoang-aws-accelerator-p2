output "instance_ids" {
  value = [
    for i in aws_instance.ec2_ex4 : i.id
  ]
}

output "environments_uppercase" {
  value = [
    for i in aws_instance.ec2_ex4 : upper(i.instance_type) == "T3.MICRO" ? "PROD" : "DEV"
  ]
}
