# Makefile for github.com/azumakuniyuki/rise-machines
#       _                                     _     _                 
#  _ __(_)___  ___       _ __ ___   __ _  ___| |__ (_)_ __   ___  ___ 
# | '__| / __|/ _ \_____| '_ ` _ \ / _` |/ __| '_ \| | '_ \ / _ \/ __|
# | |  | \__ \  __/_____| | | | | | (_| | (__| | | | | | | |  __/\__ \
# |_|  |_|___/\___|     |_| |_| |_|\__,_|\___|_| |_|_|_| |_|\___||___/
# -----------------------------------------------------------------------------
VERSION := '0.0.1'
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
MAKEDIR := mkdir -p
ROOTDIR := server
SUBDIRS := server lib .ssh script
ROLEDIR := $(ROOTDIR)/roles
ULIBDIR := lib

REPOSITORY  = htts://github.com/azumakuniyuki/rise-machines.git
DEPLOYUSER := deploy
SSHKEYFILE  = ./.ssh/ssh.$(DEPLOYUSER)-rsa.key
.DEFAULT_GOAL := git-status

# -----------------------------------------------------------------------------
.PHONY: clean all $(SUBDIRS)

ansible.cfg:
	cd $(ROOTDIR) && make ansible-config
	test -L ./$(ROOTDIR)/ansible-config || ln -s $(ROOTDIR)/ansible-config ./$@

setup:
	$(MAKE) server

# -----------------------------------------------------------------------------
# Sub directory: .ssh/
ssh-key-pair:
	cd .ssh && $(MAKE) DEPLOYKEY=$(SSHKEYFILE) DEPLOYUSER=$(DEPLOYUSER) ssh
	chmod 0600 $(SSHKEYFILE)
	chmod 0644 $(subst key,pub,$(SSHKEYFILE))

# -----------------------------------------------------------------------------
# Sub directory: server/
server: ssh-key-pair
	$(MAKE) -C $@
	$(MAKE) ansible.cfg

# -----------------------------------------------------------------------------
# Targets for rise-machines authors
git-status:
	git status

diff push branch:
	@$(MAKE) git-$@
fix-commit-message: git-commit-amend
cancel-the-latest-commit: git-reset-soft
remove-added-file: git-rm-cached

git-commit-amend:
	git commit --amend

git-current-branch:
	@git branch --contains=HEAD | grep '*' | awk '{ print $$2 }'

git-push:
	@ for v in `git remote show | grep -v origin`; do \
		printf "[%s]\n" $$v; \
		git push --tags $$v `$(MAKE) git-current-branch`; \
	done

clean:
	rm -f ./*.retry
	cd $(ROOTDIR) && make $@

# -----------------------------------------------------------------------------
# include NodeLocal.mk, User-defined macros and targets are defined in the file.
include NodeLocal.mk

