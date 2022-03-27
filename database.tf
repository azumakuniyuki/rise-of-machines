# rise-of-machines/database.tf
#      _       _        _                    
#   __| | __ _| |_ __ _| |__   __ _ ___  ___ 
#  / _` |/ _` | __/ _` | '_ \ / _` / __|/ _ \
# | (_| | (_| | || (_| | |_) | (_| \__ \  __/
#  \__,_|\__,_|\__\__,_|_.__/ \__,_|___/\___|
# -------------------------------------------------------------------------------------------------
locals { }

#  ____  ____  ____  
# |  _ \|  _ \/ ___| 
# | |_) | | | \___ \ 
# |  _ <| |_| |___) |
# |_| \_\____/|____/ 
# -------------------------------------------------------------------------------------------------
resource aws_db_subnet_group "sng-1" {
  name        = "${local.prefix}-sng-1"
  description = ""
  subnet_ids  = [
    aws_subnet.subnet-rds-1.id,
    aws_subnet.subnet-rds-2.id,
  ]
  tags = local.defaulttag
}

# -------------------------------------------------------------------------------------------------
resource aws_db_instance "rds1" {
  identifier        = "${local.prefix}-rds-1"
  availability_zone = lookup(var.abzone, "a")
  instance_class    = "db.t3.micro"
  multi_az          = false
  engine            = "mysql"
  engine_version    = "8.0.23"
  license_model     = "general-public-license"
  name              = ""
  username          = "root"
  password          = ""

  allocated_storage       = 20
  max_allocated_storage   = 1000
  storage_type            = "gp2"
  storage_encrypted       = true

  vpc_security_group_ids  = [aws_security_group.sgr-rds-1.id]
  db_subnet_group_name    = aws_db_subnet_group.sng-1.name
  monitoring_role_arn     = ""
  monitoring_interval     = 60
  option_group_name       = "default:mysql-8-0"
  parameter_group_name    = "default.mysql8.0"

  copy_tags_to_snapshot   = true
  deletion_protection     = false
  publicly_accessible     = false
  skip_final_snapshot     = true

  tags = local.defaulttag
}

