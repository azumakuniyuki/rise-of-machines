# rise-of-machines/balancer.tf
#  _           _                           
# | |__   __ _| | __ _ _ __   ___ ___ _ __ 
# | '_ \ / _` | |/ _` | '_ \ / __/ _ \ '__|
# | |_) | (_| | | (_| | | | | (_|  __/ |   
# |_.__/ \__,_|_|\__,_|_| |_|\___\___|_|   
# -------------------------------------------------------------------------------------------------
locals {}

#  _   _ _     ____  
# | \ | | |   | __ ) 
# |  \| | |   |  _ \ 
# | |\  | |___| |_) |
# |_| \_|_____|____/ 
# -------------------------------------------------------------------------------------------------
resource aws_lb "nlb-1" {
  name                = "${local.prefix}-nlb-1"
  load_balancer_type  = "network"
  ip_address_type     = "ipv4"
  internal            = false
  security_groups     = []

  subnet_mapping {
    subnet_id = aws_subnet.subnet-1.id
  }

  enable_deletion_protection        = true
  enable_cross_zone_load_balancing  = false
  access_logs {
    bucket  = aws_s3_bucket.lb-access-log.bucket
    prefix  = ""
    enabled = true
  }
  tags = local.defaulttag
}

resource aws_lb_listener "nlb-1-http" {
  load_balancer_arn = aws_lb.nlb-1.arn
  port              = 80
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.tgg-1-tcp.arn
    type = "forward"
  }
  tags = local.defaulttag
}

resource aws_lb_listener "nlb-1-https" {
  load_balancer_arn = aws_lb.nlb-1.arn
  port              = 443
  protocol          = "TLS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert-1.arn

  default_action {
    target_group_arn = aws_lb_target_group.tgg-1-tcp.arn
    type = "forward"
  }
  tags = local.defaulttag
}

resource aws_lb_target_group "tgg-1-tcp" {
  name      = "${local.prefix}-tgg-1-tcp"
  port      = 80
  protocol  = "TCP"
  vpc_id    = aws_vpc.vpc-1.id
  tags      = local.defaulttag
}

resource aws_lb_target_group_attachment "tgg-1-tcp" {
  target_group_arn = aws_lb_target_group.tgg-1-tcp.arn
  target_id        = aws_instance.ec2-host1.id
  port             = 80
}

