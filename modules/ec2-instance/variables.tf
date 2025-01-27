variable "region" {
  default = "ap-south-1"
}

variable "ami_id" {
  default = "ami-02ddb77f8f93ca4ca" 
}

variable "instance_type" {
  default = "t2.medium"
}

variable "key_name" {
  description = "taskkey"
}

variable "github_repo_owner" {
  description = "arati-k"
}

variable "github_repo_name" {
  description = "jenkins-docker"
}
variable "private_key_path" {
  default = "D:/private_keys/taskkey.pem"
}