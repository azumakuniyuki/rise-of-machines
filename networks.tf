# rise-of-machines/networks.tf
#             _                      _        
#  _ __   ___| |___      _____  _ __| | _____ 
# | '_ \ / _ \ __\ \ /\ / / _ \| '__| |/ / __|
# | | | |  __/ |_ \ V  V / (_) | |  |   <\__ \
# |_| |_|\___|\__| \_/\_/ \___/|_|  |_|\_\___/
# -------------------------------------------------------------------------------------------------
locals {}

#   ____       _                              _______           _             _       _   
#  / ___| __ _| |_ _____      ____ _ _   _   / / ____|_ __   __| |_ __   ___ (_)_ __ | |_ 
# | |  _ / _` | __/ _ \ \ /\ / / _` | | | | / /|  _| | '_ \ / _` | '_ \ / _ \| | '_ \| __|
# | |_| | (_| | ||  __/\ V  V / (_| | |_| |/ / | |___| | | | (_| | |_) | (_) | | | | | |_ 
#  \____|\__,_|\__\___| \_/\_/ \__,_|\__, /_/  |_____|_| |_|\__,_| .__/ \___/|_|_| |_|\__|
#                                    |___/                       |_|                      
# -------------------------------------------------------------------------------------------------
resource aws_internet_gateway "internet-gateway-1" {
  vpc_id = aws_vpc.vpc-1.id
  tags   = merge({ Name = "${local.prefix}-igw-1" }, local.defaulttag)
}

#  ____             _         _____     _     _           
# |  _ \ ___  _   _| |_ ___  |_   _|_ _| |__ | | ___  ___ 
# | |_) / _ \| | | | __/ _ \   | |/ _` | '_ \| |/ _ \/ __|
# |  _ < (_) | |_| | ||  __/   | | (_| | |_) | |  __/\__ \
# |_| \_\___/ \__,_|\__\___|   |_|\__,_|_.__/|_|\___||___/
# -------------------------------------------------------------------------------------------------
resource aws_route_table "rtb-to-internet-1" {
  vpc_id = aws_vpc.vpc-1.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gateway-1.id
  }

  tags = merge({ Name = "${local.prefix}-rtb-to-internet-1" }, local.defaulttag)
}

resource aws_route_table "rtb-in-local-1" {
  vpc_id = aws_vpc.vpc-1.id
  route  = []
  tags   = merge({ Name = "${local.prefix}-rtb-in-local-1" }, local.defaulttag)
}

# __     ______   ____ 
# \ \   / /  _ \ / ___|
#  \ \ / /| |_) | |    
#   \ V / |  __/| |___ 
#    \_/  |_|    \____|
# -------------------------------------------------------------------------------------------------
resource aws_vpc "vpc-1" {
  cidr_block = "192.0.2.0/24"
  enable_dns_hostnames = true
  tags = merge({ Name = "${local.prefix}-vpc-1" }, local.defaulttag)
}

#  ____        _                _       
# / ___| _   _| |__  _ __   ___| |_ ___ 
# \___ \| | | | '_ \| '_ \ / _ \ __/ __|
#  ___) | |_| | |_) | | | |  __/ |_\__ \
# |____/ \__,_|_.__/|_| |_|\___|\__|___/
# -------------------------------------------------------------------------------------------------
resource aws_subnet "subnet-ec2-1" {
  cidr_block = "192.0.2.0/25"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.vpc-1.id
  map_public_ip_on_launch = true
  tags = merge({ Name = "${local.prefix}-subnet-ec2-1" }, local.defaulttag)
}
resource aws_route_table_association "subnet-ec2-1-to-internet" {
  subnet_id = aws_subnet.subnet-ec2-1.id
  route_table_id = aws_route_table.rtb-to-internet-1.id
}

resource aws_subnet "subnet-rds-1" {
  cidr_block = "192.0.2.128/26"
  availability_zone = "us-east-1a"
  vpc_id = aws_vpc.vpc-1.id
  map_public_ip_on_launch = false
  tags = merge({ Name = "${local.prefix}-subnet-rds-1" }, local.defaulttag)
}

resource aws_subnet "subnet-rds-2" {
  cidr_block = "192.0.2.192/26"
  availability_zone = "us-east-1d"
  vpc_id = aws_vpc.vpc-1.id
  map_public_ip_on_launch = false
  tags = merge({ Name = "${local.prefix}-subnet-rds-2" }, local.defaulttag)
}

