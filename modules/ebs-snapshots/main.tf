resource "aws_ebs_volume" "jenkins_volume" {
  availability_zone = var.availability_zone
  size              = 20

  tags = {
    Name = "Jenkins-Data-Volume"
  }
}

resource "aws_volume_attachment" "jenkins_attachment" {
  device_name = "/dev/xvdf"
  volume_id   = aws_ebs_volume.jenkins_volume.id
  instance_id = var.instance_id
}

resource "aws_backup_vault" "jenkins_vault" {
  name = "jenkins-backup-vault"
}

resource "aws_backup_plan" "jenkins_backup_plan" {
  name = "jenkins-daily-backup"

  rule {
    rule_name         = "daily-backup"
    target_vault_name = aws_backup_vault.jenkins_vault.name
    schedule          = "cron(0 0 * * ? *)"

    lifecycle {
      delete_after = 30
    }
  }
}

resource "aws_backup_selection" "jenkins_backup_selection" {
  name          = "jenkins-selection"
  iam_role_arn  = var.backup_role_arn
  plan_id  = aws_backup_plan.jenkins_backup_plan.id

  resources = [
    aws_ebs_volume.jenkins_volume.arn
  ]
}
