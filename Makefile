# Makefile for Terraform: github.com/azumakuniyuki/rise-of-machines.git
#       _                       __                            _     _                 
#  _ __(_)___  ___        ___  / _|      _ __ ___   __ _  ___| |__ (_)_ __   ___  ___ 
# | '__| / __|/ _ \_____ / _ \| |_ _____| '_ ` _ \ / _` |/ __| '_ \| | '_ \ / _ \/ __|
# | |  | \__ \  __/_____| (_) |  _|_____| | | | | | (_| | (__| | | | | | | |  __/\__ \
# |_|  |_|___/\___|      \___/|_|       |_| |_| |_|\__,_|\___|_| |_|_|_| |_|\___||___/
# -------------------------------------------------------------------------------------------------
VERSION := '0.2.5'
HEREIAM := $(shell pwd)
PWDNAME := $(shell echo $(HEREIAM) | xargs basename)
MAKEDIR := mkdir -p
ACCOUNT := $(shell head -1 ./.account-id)
PROFILE := $(shell head -1 ./.default-profile)
REGION0 := $(shell head -1 ./.default-region)

TERRAFORM := AWS_DEFAULT_PROFILE=$(PROFILE) AWS_DEFAULT_REGION=$(REGION0) $(shell which terraform)
TFTARGETS := apply fmt plan refresh validate

GITCOMMANDSET := $(shell grep '^git-' ./Repository.mk | sed 's/git-//' | tr -d ':' | tr '\n' ' ')
.DEFAULT_GOAL := status

# -------------------------------------------------------------------------------------------------
.PHONY: clean all $(SUBDIRS)
.terraform-version:
	$(TERRAFORM) --version | head -1 | cut -d' ' -f2 | tr -d 'v' > $@

sure: sure-default-profile sure-account-id sure-default-region
sure-account-id:
	test -n $(ACCOUNT)
	test $(shell echo $(ACCOUNT) | wc -c) -ge 10
	aws --profile $(PROFILE) sts get-caller-identity | grep '"$(ACCOUNT)"'

sure-default-profile:
	test -n "$(PROFILE)"

sure-default-region:
	test -n "$(REGION0)"

initialize-as-new-environment:
	rm -f  ./terraform.tfstate*
	rm -f  ./.terraform-version ./.terraform.lock.hcl
	rm -rf .terraform/

printenv:
	@ echo export AWS_DEFAULT_PROFILE=$(PROFILE)

init: .terraform-version
	$(TERRAFORM) $@

resource-list:
	@ grep '^resource ' ./*.tf | cut -d' ' -f2,3 | tr -d '"' | tr ' ' '.' | sort

$(TFTARGETS): sure
	$(TERRAFORM) $@

build: sure
	$(MAKE) apply

test: validate
	$(MAKE) plan

# -------------------------------------------------------------------------------------------------
# Targets for rise-machines authors
$(GITCOMMANDSET):
	$(MAKE) -f ./Repository.mk git-$@

# -------------------------------------------------------------------------------------------------
clean:

