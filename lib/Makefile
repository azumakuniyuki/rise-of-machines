# Makefile for rise-of-machines/lib
#  _ _ _       ____  __       _         __ _ _      
# | (_) |__   / /  \/  | __ _| | _____ / _(_) | ___ 
# | | | '_ \ / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | | | |_) / / | |  | | (_| |   <  __/  _| | |  __/
# |_|_|_.__/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# -------------------------------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
CURNODE := $(shell echo $(dir $(HEREIAM)) | xargs basename)
MAKEDIR  = mkdir -p

DOWNLOADUSING := $(shell (which wget && echo '-O') || (which curl && echo '-Lo') || echo 'get-command')
WILLBEUPDATED  = Makefile ansible_helper.rb spec_helper.rb
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

