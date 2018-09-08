# Makefile for rise-machines/lib
#  _ _ _       ____  __       _         __ _ _      
# | (_) |__   / /  \/  | __ _| | _____ / _(_) | ___ 
# | | | '_ \ / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | | | |_) / / | |  | | (_| |   <  __/  _| | |  __/
# |_|_|_.__/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# -----------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
MAKEDIR  = mkdir -p

WILLBEUPDATED  = Makefile ansible_helper.rb spec_helper.rb
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

