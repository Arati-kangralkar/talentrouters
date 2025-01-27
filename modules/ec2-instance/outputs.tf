output "instance_id" {
  value = aws_instance.jenkins.id
}

output "availability_zone" {
  value = aws_instance.jenkins.availability_zone
}
