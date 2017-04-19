# User-Defined Makefile for github.com/azumakuniyuki/make-server
#  _   _           _      _                    _             _    
# | \ | | ___   __| | ___| |    ___   ___ __ _| |  _ __ ___ | | __
# |  \| |/ _ \ / _` |/ _ \ |   / _ \ / __/ _` | | | '_ ` _ \| |/ /
# | |\  | (_) | (_| |  __/ |__| (_) | (_| (_| | |_| | | | | |   < 
# |_| \_|\___/ \__,_|\___|_____\___/ \___\__,_|_(_)_| |_| |_|_|\_\
# This file is not updated by `makeserverctl --update-makefile`.
# ---------------------------------------------------------------------------
PATHTOANSIBLE  = $(shell which ansible)

# -----------------------------------------------------------------------------
uptime:
	$(PATHTOANSIBLE) all -i $(INVENTORYFILE) -m command -a 'uptime'

