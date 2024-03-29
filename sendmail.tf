# rise-of-machines/sendmail.tf
#                     _                 _ _ 
#  ___  ___ _ __   __| |_ __ ___   __ _(_) |
# / __|/ _ \ '_ \ / _` | '_ ` _ \ / _` | | |
# \__ \  __/ | | | (_| | | | | | | (_| | | |
# |___/\___|_| |_|\__,_|_| |_| |_|\__,_|_|_|
# -------------------------------------------------------------------------------------------------
locals {}

#     _                                   ____  _____ ____  
#    / \   _ __ ___   __ _ _______  _ __ / ___|| ____/ ___| 
#   / _ \ | '_ ` _ \ / _` |_  / _ \| '_ \\___ \|  _| \___ \ 
#  / ___ \| | | | | | (_| |/ / (_) | | | |___) | |___ ___) |
# /_/   \_\_| |_| |_|\__,_/___\___/|_| |_|____/|_____|____/ 
# -------------------------------------------------------------------------------------------------
resource aws_ses_domain_identity "neko-example-jp" { domain = local.domain }
resource aws_ses_domain_dkim     "neko-example-jp" { domain = aws_ses_domain_identity.neko-example-jp.domain }
resource aws_ses_email_identity  "nekochan"        { email  = "nyaan@${local.domain}" }

