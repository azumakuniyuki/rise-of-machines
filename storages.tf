# rise-of-machines/storages.tf
#      _                                  
#  ___| |_ ___  _ __ __ _  __ _  ___  ___ 
# / __| __/ _ \| '__/ _` |/ _` |/ _ \/ __|
# \__ \ || (_) | | | (_| | (_| |  __/\__ \
# |___/\__\___/|_|  \__,_|\__, |\___||___/
#                         |___/           
# -------------------------------------------------------------------------------------------------
locals {}

#  ____ _____ 
# / ___|___ / 
# \___ \ |_ \ 
#  ___) |__) |
# |____/____/ 
# -------------------------------------------------------------------------------------------------
resource aws_s3_bucket "lb-access-log" {
  bucket = "${local.prefix}-lb-access-log"
  acl    = "log-delivery-write"

  lifecycle_rule {
    id      = "${local.prefix}-keep-logs-for-90-days"
    enabled = true
    prefix  = ""
    expiration { 
      days = 90
    }
  }
  tags = local.defaulttag
}
resource aws_s3_bucket_policy "allow-lb-access-log-write" {
  bucket = aws_s3_bucket.lb-access-log.id
  policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Sid       = "AWSLogDeliveryWrite",
        Effect    = "Allow",
        Principal = { Service = "delivery.logs.amazonaws.com" },
        Action    = "s3:PutObject",
        Resource  = "${aws_s3_bucket.lb-access-log.arn}/*",
        Condition = { StringEquals = { "s3:x-amz-acl" = "bucket-owner-full-control" } }
      },
      {
        Sid       = "AWSLogDeliveryAclCheck",
        Effect    = "Allow",
        Principal = { Service = "delivery.logs.amazonaws.com" },
        Action    = "s3:GetBucketAcl",
        Resource  = "arn:aws:s3:::${local.prefix}-lb-access-log"
        }
    ]
  })
}

