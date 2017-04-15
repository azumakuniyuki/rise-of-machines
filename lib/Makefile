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

.DEFAULT_GOAL := git-status

# -----------------------------------------------------------------------------
.PHONY: clean
.SUFFIXES:

git-status:
	git status

clean:

