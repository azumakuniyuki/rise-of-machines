# Makefile for rise-machines/server
#                                ____  __       _         __ _ _      
#  ___  ___ _ ____   _____ _ __ / /  \/  | __ _| | _____ / _(_) | ___ 
# / __|/ _ \ '__\ \ / / _ \ '__/ /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# \__ \  __/ |   \ V /  __/ | / / | |  | | (_| |   <  __/  _| | |  __/
# |___/\___|_|    \_/ \___|_|/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# ---------------------------------------------------------------------------
HEREIAM  = $(shell pwd)
PWDNAME  = $(shell echo $(HEREIAM) | xargs basename)
CURNODE := $(shell echo $(dir $(HEREIAM)) | xargs basename)
SUBDIRS := roles
ROLEDIR := roles
MAKEDIR  = mkdir -p

ROOTDIRECTORY := server
DOWNLOADUSING := $(shell (which wget && echo '-O') || (which curl && echo '-Lo') || echo 'get-command')
INVENTORYFILE  = $(shell head -1 ../.default-inventoryfile)
ANSIBLECONFIG := ansible-config
ANSIBLECMDLOG := ansible.log
INVENTORYLIST := for-develop for-install for-product for-sandbox for-staging
WILLBEUPDATED  = 100-update-package.yml 101-install-python.yml 102-notuse-selinux.yml \
				 103-apply-hostname.yml 104-never-use-ipv6.yml 105-ipv4-than-ipv6.yml \
				 110-configure-sudo.yml 120-user-to-deploy.yml 125-add-interfaces.yml \
				 130-configure-sshd.yml 901-make-ssl-files.yml Makefile

BUILDPLAYBOOK := build-all-machines.yml
ANSIBLETARGET := $(INVENTORYLIST) $(PLAYBOOKFILES)
.DEFAULT_GOAL := git-status

# -----------------------------------------------------------------------------
.PHONY: clean
.SUFFIXES:

all:
	$(MAKE) $(ANSIBLECONFIG) $(INVENTORYLIST) $(ANSIBLECMDLOG)

me-upgrade:
	@test "$(CURNODE)" != "rise-machines"
	@for v in $(WILLBEUPDATED); do $(DOWNLOADUSING) ./$$v $(GITHUBFILE)/$(PWDNAME)/$$v; done

$(ANSIBLECMDLOG):
	touch ./$@

git-status:
	git status

clean:
	/bin/cp /dev/null $(ANSIBLECMDLOG)
	/bin/rm ./*.retry

