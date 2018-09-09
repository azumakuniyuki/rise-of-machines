# Makefile for rise-machines/server/roles
#            __         _              ____  __       _         __ _ _      
#      _ __ / / __ ___ | | ___  ___   / /  \/  | __ _| | _____ / _(_) | ___ 
#     | '__/ / '__/ _ \| |/ _ \/ __| / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
#  _ _| | / /| | | (_) | |  __/\__ \/ / | |  | | (_| |   <  __/  _| | |  __/
# (_|_)_|/_/ |_|  \___/|_|\___||___/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
#                                                                           
# -----------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
CURNODE := $(shell echo $(dir $(shell cd ../ && pwd)) | xargs basename)
MAKEDIR  = mkdir -p

DOWNLOADUSING := $(shell (which wget && echo '-cO') || (which curl && echo '-Lo') || echo 'get-command')
.DEFAULT_GOAL := git-status

# -----------------------------------------------------------------------------
.PHONY: clean
.SUFFIXES:

me-upgrade:
	@test "$(CURNODE)" != "rise-machines"
	for v in $(WILLBEUPDATED); do $(DOWNLOADUSING) ./$$v $(GITHUBFILE)/server/roles/$$v; done

git-status:
	git status

clean:

