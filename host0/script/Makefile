# Makefile for rise-of-machines/script
#                _       _      ____  __       _         __ _ _      
#  ___  ___ _ __(_)_ __ | |_   / /  \/  | __ _| | _____ / _(_) | ___ 
# / __|/ __| '__| | '_ \| __| / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# \__ \ (__| |  | | |_) | |_ / / | |  | | (_| |   <  __/  _| | |  __/
# |___/\___|_|  |_| .__/ \__/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#                 |_|                                                
# -------------------------------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
CURNODE := $(shell echo $(dir $(HEREIAM)) | xargs basename)
MAKEDIR  = mkdir -p

DOWNLOADUSING := $(shell (which wget && echo '-O') || (which curl && echo '-Lo') || echo 'get-command')
WILLBEUPDATED  = Makefile disable-selinux install-python-eggs
.DEFAULT_GOAL := git-status

# -------------------------------------------------------------------------------------------------
.PHONY: clean
.SUFFIXES:

me-upgrade: is-not-rise-of-machines
	@for v in $(WILLBEUPDATED); do $(DOWNLOADUSING) ./$$v $(GITHUBFILE)/$(PWDNAME)/$$v; done

is-not-rise-of-machines:
	@test "$(CURNODE)" != "rise-of-machines"

git-status:
	git status

clean:

