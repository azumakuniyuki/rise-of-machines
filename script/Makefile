# Makefile for rise-machines/script
#                _       _      ____  __       _         __ _ _      
#  ___  ___ _ __(_)_ __ | |_   / /  \/  | __ _| | _____ / _(_) | ___ 
# / __|/ __| '__| | '_ \| __| / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# \__ \ (__| |  | | |_) | |_ / / | |  | | (_| |   <  __/  _| | |  __/
# |___/\___|_|  |_| .__/ \__/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#                 |_|                                                
# -----------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
MAKEDIR  = mkdir -p

WILLBEUPDATED  = Makefile disable-selinux install-python-eggs
.DEFAULT_GOAL := git-status

# -----------------------------------------------------------------------------
.PHONY: clean
.SUFFIXES:

me-upgrade:
	if [ "$(CURNODE)" != "rise-machines" ]; then \
		for v in $(WILLBEUPDATED); do $(DOWNLOADBY) ./$$v $(GITHUBFILE)/$(PWDNAME)/$$v; done; \
	fi

git-status:
	git status

clean:

