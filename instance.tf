# rise-of-machines/instance.tf
#  _           _                       
# (_)_ __  ___| |_ __ _ _ __   ___ ___ 
# | | '_ \/ __| __/ _` | '_ \ / __/ _ \
# | | | | \__ \ || (_| | | | | (_|  __/
# |_|_| |_|___/\__\__,_|_| |_|\___\___|
# -------------------------------------------------------------------------------------------------
locals {}

#  _____ ____ ____  
# | ____/ ___|___ \ 
# |  _|| |     __) |
# | |__| |___ / __/ 
# |_____\____|_____|
# -------------------------------------------------------------------------------------------------
resource aws_instance "ec2-host1" {
  private_ip        = "192.0.2.22"
  availability_zone = lookup(var.abzone, "a")
  ami               = ""
  instance_type     = "t3.medium"
  subnet_id         = aws_subnet.subnet-ec2-1.id
  key_name          = aws_key_pair.ssh-1.id

  vpc_security_group_ids = [aws_security_group.sgr-subnet-ec2-1]
  tags = merge({ Name = "host1.${local.domain}" }, local.defaulttag)
}
resource aws_ebs_volume "ebs-host1-1" {
  availability_zone = lookup(var.abzone, "a")
  encrypted         = false
  size              = 30
  type              = "gp2"
  tags              = merge({ Snapshot = "true" }, local.defaulttag)
}
resource aws_volume_attachment "ec2-dev2-ebs1" {
  device_name = "/dev/xvda"
  volume_id   = aws_ebs_volume.ebs-dev2-1.id
  instance_id = aws_instance.ec2-dev2.id
}

#  ____  _     __  __
# |  _ \| |   |  \/  |
# | | | | |   | |\/| |
# | |_| | |___| |  | |
# |____/|_____|_|  |_|
# -------------------------------------------------------------------------------------------------
resource aws_dlm_lifecycle_policy "dlm-lifecycle-policy-1" {
  description         = "DLM LifeCycle Policy"
  execution_role_arn  = aws_iam_role.KukuluJP-DLM-LifeCycle.arn
  state               = "ENABLED"

  policy_details {
    resource_types = ["VOLUME"]
    schedule {
      name = "make-daily-snapshot-for-a-week"
      create_rule {
        interval      = 24
        interval_unit = "HOURS"
        times         = ["21:00"]
      }

      retain_rule   {
        count = 7
      }
      tags_to_add = { CreatedBy = "DLM" }
      copy_tags   = true
    }

    target_tags   = { Snapshot  = true }
  }
} 

