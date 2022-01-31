# Makefile for github.com/azumakuniyuki/rise-of-machines/host0
#       _                       __                            _     _                 
#  _ __(_)___  ___        ___  / _|      _ __ ___   __ _  ___| |__ (_)_ __   ___  ___ 
# | '__| / __|/ _ \_____ / _ \| |_ _____| '_ ` _ \ / _` |/ __| '_ \| | '_ \ / _ \/ __|
# | |  | \__ \  __/_____| (_) |  _|_____| | | | | | (_| | (__| | | | | | | |  __/\__ \
# |_|  |_|___/\___|      \___/|_|       |_| |_| |_|\__,_|\___|_| |_|_|_| |_|\___||___/
#                                                                                     
# -------------------------------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
MAKEDIR := mkdir -p
ROOTDIR := server
SUBDIRS := server lib .ssh script
ROLEDIR := $(ROOTDIR)/roles
ULIBDIR := lib

DOWNLOADBY := $(shell (which wget && echo '-O') || (which curl && echo '-Lo') || echo 'get-command')
GITHUBROOT  = https://github.com/azumakuniyuki
GITHUBFILE  = https://raw.githubusercontent.com/azumakuniyuki/rise-of-machines/master
REPOSITORY  = $(GITHUBROOT)/rise-of-machines.git
DEPLOYUSER := deploy
SSHKEYFILE  = ./.ssh/ssh.$(DEPLOYUSER)-rsa.key

WILLBEUPDATED  = Makefile
INVENTORYFILE  = $(ROOTDIR)/$(shell head -1 ./.default-inventory)
BUILDPLAYBOOK := $(ROOTDIR)/build-all-machines.yml
SPECIFIEDTAGS := $(shell test -n "$(T)" && echo --tags "$(T)")

GITCOMMANDSET := $(shell grep '^git-' ../Repository.mk | sed 's/git-//' | tr -d ':' | tr '\n' ' ')
.DEFAULT_GOAL := status

# -------------------------------------------------------------------------------------------------
.PHONY: clean all $(SUBDIRS)

ansible.cfg:
	cd $(ROOTDIR) && make ansible-config
	test -L ./$(ROOTDIR)/ansible-config || ln -s $(ROOTDIR)/ansible-config ./$@

fact:
	ansible all -i $(INVENTORYFILE) -m setup

setup: ssh-key-pair
	$(MAKE) ansible.cfg
	$(MAKE) install-collections

env: ssh-key-pair sshpass
	cd $(ROOTDIR) && make -w $@

sshpass:
	test -x /usr/local/bin/$@ || ( \
		echo 'https://sourceforge.net/projects/sshpass/files/latest/download' && \
		echo 'gunzip -c sshpass-1.06.tar.gz | tar xvf -' && \
		echo 'cd ./sshpass-1.06 && /bin/sh configure --prefix=/usr/local && make && make install' && exit 1 )

build: ssh-key-pair
	ansible-playbook -i $(INVENTORYFILE) $(SPECIFIEDTAGS) $(BUILDPLAYBOOK)

check: test
test: ssh-key-pair
	ansible-playbook --check -i $(INVENTORYFILE) $(SPECIFIEDTAGS) $(BUILDPLAYBOOK)

install-collections:
	ansible-galaxy collection install --ignore-certs -r $(ROOTDIR)/module-collections.yml

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

me-upgrade: is-not-rise-of-machines
	@for v in $(WILLBEUPDATED); do $(DOWNLOADBY) ./$$v $(GITHUBFILE)/$$v; done
	@for v in $(SUBDIRS); do \
		cd $(HEREIAM)/$$v && $(MAKE) GITHUBFILE=$(GITHUBFILE) $@; \
	done

is-not-rise-of-machines:
	@test "$(PWDNAME)" != "rise-of-machines"

# -------------------------------------------------------------------------------------------------
# Sub directory: .ssh/
ssh-key-pair:
	cd .ssh && $(MAKE) DEPLOYKEY=$(SSHKEYFILE) DEPLOYUSER=$(DEPLOYUSER) all
	chmod 0600 $(SSHKEYFILE)
	chmod 0644 $(subst key,pub,$(SSHKEYFILE))

ssh-connection:
	@test -n "$(H)" || (echo 'Usage: make $@ H=hostname' && false)
	ssh -i $(SSHKEYFILE) -l $(DEPLOYUSER) $(H)

clean:
	rm -f ./*.retry
	cd $(ROOTDIR) && make $@
	cd $(ROLEDIR) && make $@

# -------------------------------------------------------------------------------------------------
# git related targets
$(GITCOMMANDSET):
	$(MAKE) -f ../Repository.mk git-$@

# -------------------------------------------------------------------------------------------------
# include NodeLocal.mk, User-defined macros and targets are defined in the file.
include NodeLocal.mk

