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
  availability_zone = "us-east-1a"
  ami               = ""
  instance_type     = "t3.medium"
  subnet_id         = aws_subnet.subnet-ec2-1.id
  key_name          = aws_key_pair.ssh-1.id

  vpc_security_group_ids = [aws_security_group.sgr-subnet-ec2-1]
  tags = merge({ Name = "host1.${local.domain}" }, local.defaulttag)
}
 
