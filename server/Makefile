# Makefile for rise-machines/server
#                                ____  __       _         __ _ _      
#  ___  ___ _ ____   _____ _ __ / /  \/  | __ _| | _____ / _(_) | ___ 
# / __|/ _ \ '__\ \ / / _ \ '__/ /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# \__ \  __/ |   \ V /  __/ | / / | |  | | (_| |   <  __/  _| | |  __/
# |___/\___|_|    \_/ \___|_|/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# ---------------------------------------------------------------------------
HEREIAM  = $(shell pwd)
PWDNAME  = $(shell echo $(HEREIAM) | xargs basename)
SUBDIRS := roles
ROLEDIR := roles
MAKEDIR  = mkdir -p

.DEFAULT_GOAL := git-status
ROOTDIRECTORY := server
INVENTORYFILE  = $(shell head -1 ../.default-inventoryfile)
ANSIBLECONFIG := ansible-config
ANSIBLECMDLOG := ansible.log
INVENTORYLIST := for-develop for-install for-product for-sandbox for-staging

BUILDPLAYBOOK := build-all-machines.yml
ANSIBLETARGET := $(INVENTORYLIST) $(PLAYBOOKFILES)

# -----------------------------------------------------------------------------
.PHONY: clean
.SUFFIXES:

all:
	$(MAKE) $(ANSIBLECONFIG) $(INVENTORYLIST) $(ANSIBLECMDLOG)
	$(MAKE) $(SUBDIRS)

$(ANSIBLECMDLOG):
	touch ./$@

git-status:
	git status

clean:
	/bin/cp /dev/null $(ANSIBLECMDLOG)
	/bin/rm ./*.retry

