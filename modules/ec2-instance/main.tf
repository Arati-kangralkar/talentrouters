resource "aws_security_group" "jenkins_sg" {
  name        = "jenkins-sg"
  description = "Security group for Jenkins server"

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 50000
    to_port     = 50000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [aws_security_group.jenkins_sg.name]

  tags = {
    Name = "Jenkins-Server"
  }

  provisioner "remote-exec" {
  inline = [
    "sudo dnf update -y",  # Update system
    "sudo dnf install -y git",  # Install git
    "sudo yum install -y curl",
    "sudo dnf config-manager --add-repo https://download.docker.com/linux/rhel/docker-ce.repo",   # Add Docker repo
    "sudo dnf install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin",  # Install Docker
    "sudo systemctl enable docker",  # Enable Docker to start on boot
    "sudo systemctl start docker",   # Start Docker service
    "sudo usermod -aG docker ec2-user",  # Add ec2-user to docker group
    "git clone https://@github.com/${var.github_repo_owner}/${var.github_repo_name}.git",
	  "sudo curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose",  # Download docker-compose binary
    "sudo chmod +x /usr/local/bin/docker-compose",  # Make it executable
    "cd ${var.github_repo_name} && sudo docker-compose up -d"
  ]
}


  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.private_key_path)
    host        = self.public_ip
  }
}
