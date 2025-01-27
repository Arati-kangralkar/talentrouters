module "ec2_instance" {
  source = "./modules/ec2-instance"

  ami_id            = var.ami_id
  instance_type     = var.instance_type
  key_name          = var.key_name
  github_repo_owner = var.github_repo_owner
  github_repo_name  = var.github_repo_name
  private_key_path  = var.private_key_path
}

module "eip" {
  source = "./modules/eip"

  instance_id = module.ec2_instance.instance_id
}
module "ebs_snapshots" {
  source             = "./modules/ebs-snapshots"
  instance_id        = module.ec2_instance.instance_id
  availability_zone  = module.ec2_instance.availability_zone
  backup_role_arn    = var.backup_role_arn
}

provider "aws" {
  region = var.region
}


