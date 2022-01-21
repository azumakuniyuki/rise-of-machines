# rise-of-machines/firewall.tf
#   __ _                        _ _ 
#  / _(_)_ __ _____      ____ _| | |
# | |_| | '__/ _ \ \ /\ / / _` | | |
# |  _| | | |  __/\ V  V / (_| | | |
# |_| |_|_|  \___| \_/\_/ \__,_|_|_|
# -------------------------------------------------------------------------------------------------
locals {}

#  ____        __             _ _     _   _      _                      _         _    ____ _     
# |  _ \  ___ / _| __ _ _   _| | |_  | \ | | ___| |___      _____  _ __| | __    / \  / ___| |    
# | | | |/ _ \ |_ / _` | | | | | __| |  \| |/ _ \ __\ \ /\ / / _ \| '__| |/ /   / _ \| |   | |    
# | |_| |  __/  _| (_| | |_| | | |_  | |\  |  __/ |_ \ V  V / (_) | |  |   <   / ___ \ |___| |___ 
# |____/ \___|_|  \__,_|\__,_|_|\__| |_| \_|\___|\__| \_/\_/ \___/|_|  |_|\_\ /_/   \_\____|_____|
# -------------------------------------------------------------------------------------------------
resource aws_default_network_acl "default-acl-1" {
  default_network_acl_id = aws_vpc.vpc-1.default_network_acl_id
  subnet_ids = [aws_subnet.subnet-ec2-1.id, aws_subnet.subnet-rds-1.id, aws_subnet.subnet-rds-2.id]

  egress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    icmp_code  = 0
    icmp_type  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }

  ingress {
    action     = "allow"
    cidr_block = "0.0.0.0/0"
    from_port  = 0
    icmp_code  = 0
    icmp_type  = 0
    protocol   = "-1"
    rule_no    = 100
    to_port    = 0
  }

  tags = merge({ Name = "${local.prefix}-default-acl-1" }, local.defaulttag)
}

#  ____                       _ _            ____                           
# / ___|  ___  ___ _   _ _ __(_) |_ _   _   / ___|_ __ ___  _   _ _ __  ___ 
# \___ \ / _ \/ __| | | | '__| | __| | | | | |  _| '__/ _ \| | | | '_ \/ __|
#  ___) |  __/ (__| |_| | |  | | |_| |_| | | |_| | | | (_) | |_| | |_) \__ \
# |____/ \___|\___|\__,_|_|  |_|\__|\__, |  \____|_|  \___/ \__,_| .__/|___/
#                                   |___/                        |_|        
# -------------------------------------------------------------------------------------------------
resource aws_security_group "sgr-subnet-ec2-1" {
  name        = "${local.prefix}-sgr-subnet-ec2-1"
  description = "Allow from 192.0.2.0/24"
  vpc_id      = aws_vpc.vpc-1.id

  egress = [
    {
      cidr_blocks = ["0.0.0.0/0"]
      description = ""
      from_port   = 0
      protocol    = "-1"
      to_port     = 0
      self        = false
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]

  ingress = [
    {
      description = "Allow SSH connection"
      cidr_blocks = [aws_subnet.subnet-ec2-1.cidr_block]
      from_port   = 22
      protocol    = "tcp"
      to_port     = 22 
      self        = false
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
    },
  ]

  tags = local.defaulttag
}

