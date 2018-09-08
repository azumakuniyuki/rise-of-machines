# Makefile for rise-machines/.ssh
#            _        ____  __       _         __ _ _      
#    ___ ___| |__    / /  \/  | __ _| | _____ / _(_) | ___ 
#   / __/ __| '_ \  / /| |\/| |/ _` | |/ / _ \ |_| | |/ _ \
#  _\__ \__ \ | | |/ / | |  | | (_| |   <  __/  _| | |  __/
# (_)___/___/_| |_/_/  |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# ---------------------------------------------------------------------------
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
CURNODE := $(shell echo $(dir $(HEREIAM)) | xargs basename)

SSH2SECRETKEY  = $(notdir $(DEPLOYKEY))
SSH2PUBLICKEY  = $(subst key,pub,$(SSH2SECRETKEY))
WILLBEUPDATED  = Makefile 
.DEFAULT_GOAL := git-status

# ---------------------------------------------------------------------------
.PHONY: clean all
.SUFFIXES: .key .pub
all: $(SSH2PUBLICKEY)

$(SSH2SECRETKEY):
	ssh-keygen -vf $@ -N '' -C "$(DEPLOYUSER)@$(CURNODE)"
	chmod 0600 $@

.key.pub:
	test -f $(SSH2SECRETKEY).pub && mv $(SSH2SECRETKEY).pub $(SSH2PUBLICKEY)
	chmod 0644 $(SSH2PUBLICKEY)

me-upgrade:
	@test "$(CURNODE)" != "rise-machines"
	@for v in $(WILLBEUPDATED); do $(DOWNLOADBY) ./$$v $(GITHUBFILE)/$(PWDNAME)/$$v; done

git-status:
	git status

clean:

