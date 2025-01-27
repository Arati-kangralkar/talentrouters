output "elastic_ip" {
  value = aws_eip.jenkins_eip.public_ip
}
