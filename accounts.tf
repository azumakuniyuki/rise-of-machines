# rise-of-machines/accounts.tf
#                                  _       
#   __ _  ___ ___ ___  _   _ _ __ | |_ ___ 
#  / _` |/ __/ __/ _ \| | | | '_ \| __/ __|
# | (_| | (_| (_| (_) | |_| | | | | |_\__ \
#  \__,_|\___\___\___/ \__,_|_| |_|\__|___/
# -------------------------------------------------------------------------------------------------
locals {
  developers     = ["neko"]
  administrators = []
  machines       = []
}

#  ___    _    __  __   _   _                   
# |_ _|  / \  |  \/  | | | | |___  ___ _ __ ___ 
#  | |  / _ \ | |\/| | | | | / __|/ _ \ '__/ __|
#  | | / ___ \| |  | | | |_| \__ \  __/ |  \__ \
# |___/_/   \_\_|  |_|  \___/|___/\___|_|  |___/
# -------------------------------------------------------------------------------------------------
resource aws_iam_user "neko" { name = "neko" }

#  ___    _    __  __    ____                           
# |_ _|  / \  |  \/  |  / ___|_ __ ___  _   _ _ __  ___ 
#  | |  / _ \ | |\/| | | |  _| '__/ _ \| | | | '_ \/ __|
#  | | / ___ \| |  | | | |_| | | | (_) | |_| | |_) \__ \
# |___/_/   \_\_|  |_|  \____|_|  \___/ \__,_| .__/|___/
#                                            |_|        
# -------------------------------------------------------------------------------------------------
resource aws_iam_group "aws-administrators" { name = "aws-administrators" }
resource aws_iam_group "app-developers"     { name = "app-developers" }
resource aws_iam_group "postmasters"        { name = "postmasters" }

resource aws_iam_user_group_membership "developers-belong-to" {
  count   = length(local.developers)
  user    = element(local.developers, count.index)
  groups  = [aws_iam_group.app-developers.name]
}

# -------------------------------------------------------------------------------------------------
resource aws_iam_policy_attachment "AttachesPolicy-IAMUserChangePassword" {
  name = "AttachesPolicy-IAMUserChangePassword"
  policy_arn = "arn:aws:iam::aws:policy/IAMUserChangePassword"
  groups = [aws_iam_group.app-developers.name]
}

resource aws_iam_policy_attachment "AttachesPolicy-AmazonSESFullAccess" {
  name = "AttachesPolicy-AmazonSESFullAccess"
  policy_arn = "arn:aws:iam::aws:policy/AmazonSESFullAccess"
  groups = [aws_iam_group.postmasters.name]
}

