# Makefile for github.com/azumakuniyuki/rise-machines
#       _                                     _     _                 
#  _ __(_)___  ___       _ __ ___   __ _  ___| |__ (_)_ __   ___  ___ 
# | '__| / __|/ _ \_____| '_ ` _ \ / _` |/ __| '_ \| | '_ \ / _ \/ __|
# | |  | \__ \  __/_____| | | | | | (_| | (__| | | | | | | |  __/\__ \
# |_|  |_|___/\___|     |_| |_| |_|\__,_|\___|_| |_|_|_| |_|\___||___/
# -----------------------------------------------------------------------------
VERSION := '0.1.10'
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
MAKEDIR := mkdir -p
ROOTDIR := server
SUBDIRS := server lib .ssh script
ROLEDIR := $(ROOTDIR)/roles
ULIBDIR := lib

DOWNLOADBY := $(shell (which wget && echo '-O') || (which curl && echo '-Lo') || echo 'get-command')
GITHUBROOT  = https://github.com/azumakuniyuki
GITHUBFILE  = https://raw.githubusercontent.com/azumakuniyuki/rise-machines/master
REPOSITORY  = $(GITHUBROOT)/rise-machines.git
DEPLOYUSER := deploy
SSHKEYFILE  = ./.ssh/ssh.$(DEPLOYUSER)-rsa.key

WILLBEUPDATED  = Makefile
INVENTORYFILE  = $(ROOTDIR)/$(shell head -1 ./.default-inventory-file)
BUILDPLAYBOOK := $(ROOTDIR)/build-all-machines.yml
SPECIFIEDTAGS := $(shell test -n "$(T)" && echo --tags "$(T)")
.DEFAULT_GOAL := git-status

# -----------------------------------------------------------------------------
.PHONY: clean all $(SUBDIRS)

ansible.cfg:
	cd $(ROOTDIR) && make ansible-config
	test -L ./$(ROOTDIR)/ansible-config || ln -s $(ROOTDIR)/ansible-config ./$@

fact:
	ansible all -i $(INVENTORYFILE) -m setup

setup: ssh-key-pair
	$(MAKE) ansible.cfg

env: ssh-key-pair
	cd $(ROOTDIR) && make -w $@

build: ssh-key-pair
	ansible-playbook -i $(INVENTORYFILE) $(SPECIFIEDTAGS) $(BUILDPLAYBOOK)

check: ssh-key-pair
	ansible-playbook --check -i $(INVENTORYFILE) $(SPECIFIEDTAGS) $(BUILDPLAYBOOK)

install-role:
	@if [ -n "$(R)" ]; then \
		if [ ! -d "$(ROLEDIR)/$(R)" ]; then \
			git clone $(GITHUBROOT)/$(R).git $(ROLEDIR)/$(R); \
			mkdir -p $(ROLEDIR)/$(R)/vars; \
			touch $(ROLEDIR)/$(R)/vars/main.yml; \
			rm -f $(ROLEDIR)/$(R)/Makefile; \
			cd $(ROLEDIR) && make -w clean; \
		fi; \
	fi

role-skeleton:
	if [ -n "$(R)" ]; then \
		for e in defaults files handlers meta tasks templates tests vars; do \
			mkdir -p $(ROLEDIR)/$(R)/$$e; \
		done; \
		for e in handlers meta tasks vars; do \
			touch $(ROLEDIR)/$(R)/$$e/main.yml; \
		done; \
	fi

me-upgrade: is-not-rise-machines
	@for v in $(WILLBEUPDATED); do $(DOWNLOADBY) ./$$v $(GITHUBFILE)/$$v; done
	@for v in $(SUBDIRS); do \
		cd $(HEREIAM)/$$v && $(MAKE) GITHUBFILE=$(GITHUBFILE) $@; \
	done

initialize-as-new-repository: is-not-rise-machines
	test -f "./.git/config"
	grep 'rise-machines' ./.git/config > /dev/null
	rm -r ./.git
	git init

is-not-rise-machines:
	@test "$(PWDNAME)" != "rise-machines"

# -----------------------------------------------------------------------------
# Sub directory: .ssh/
ssh-key-pair:
	cd .ssh && $(MAKE) DEPLOYKEY=$(SSHKEYFILE) DEPLOYUSER=$(DEPLOYUSER) all
	chmod 0600 $(SSHKEYFILE)
	chmod 0644 $(subst key,pub,$(SSHKEYFILE))

ssh-connection:
	@test -n "$(H)" || (echo 'Usage: make $@ H=hostname' && false)
	ssh -i $(SSHKEYFILE) -l $(DEPLOYUSER) $(H)

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
	cd $(ROLEDIR) && make $@

# -----------------------------------------------------------------------------
# include NodeLocal.mk, User-defined macros and targets are defined in the file.
include NodeLocal.mk

