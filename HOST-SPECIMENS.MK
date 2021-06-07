# /root/host-specimens.mk
#  __  __       _         __ _ _      
# |  \/  | __ _| | _____ / _(_) | ___ 
# | |\/| |/ _` | |/ / _ \ |_| | |/ _ \
# | |  | | (_| |   <  __/  _| | |  __/
# |_|  |_|\__,_|_|\_\___|_| |_|_|\___|
# -------------------------------------------------------------------------------------------------
SHELL        := /bin/sh
TODAY        := $(shell date '+%F')
PREFIX       := $(shell date '+%H%M%S')
NAME         := host-specimens
DIST         := ./$(NAME)/$(TODAY)

MKDIR        := mkdir -p
WHEREIS      := whereis
SYSTEMCTL    := /usr/bin/systemctl
JOURNALCTL   := /usr/bin/journalctl
JOURNALOPT   := -r -p3 -S today --no-pager -n 100
CP           := cp
RM           := rm -f

LISTOFSERVICE := postfix bind
SYSTEMCOMMAND := id w last uptime env "uname -a " "top -bc -n1" "free -m" "ps axuwww" "df -h" \
				 mount iostat vmstat "netstat -nat" "netstat -nar" neko ifconfig "iptables -n -L"   \
				 jobs "ntpdate -q ntp.nict.jp" getenforce "ls -laF /tmp"
MAILSERVERCMD := mailq postconf
OTHERCOMMANDS :=
TOBEINSPECTED := $(SYSTEMCOMMAND) $(MAILSERVERCMD) $(OTHERCOMMANDS)
.DEFAULT_GOAL := inspect-me

# -------------------------------------------------------------------------------------------------
.PHONY: clean

directory:
	@ test -d $(DIST) || $(MKDIR) $(DIST)
	@ chmod 700 $(DIST)

require-root:
	@ echo "$${UID}" = "0"

inspect-me: directory
	@ logname
	@ id
	@ w
	@ uptime
	@ echo '----------------------------------------------------------------------------'
	@ echo " RESULTS OF EACH COMMAND WILL BE SAVED INTO $(DIST)"
	@ echo '----------------------------------------------------------------------------'

	@ for v in $(TOBEINSPECTED); do \
		n=`echo $$v | awk '{ print $$1 }'`; \
		f=`echo $$v | sed 's| /|-|' | tr -d '"' | tr -d "'" | tr ' /' '-' | sed -e 's/--*/-/g'`; \
		echo "- $$v"; \
		$$v > $(DIST)/$(PREFIX)-$$f.txt 2>&1 || true; \
	done

	@ for v in $(LISTOFSERVICE); do \
		f="systemctl-status-$$v"; \
		echo "- $$v"; \
		echo "  - systemctl status"; \
		$(SYSTEMCTL) status $$v > $(DIST)/$(PREFIX)-$$f.txt 2>&1 || true; \
		f="journalctl-today-$$v"; \
		echo "  - journalctl"; \
		$(JOURNALCTL) $(JOURNALOPT) -u $$v > $(DIST)/$(PREFIX)-$$f.txt 2>&1 || true; \
	done
	@ echo "- journalctl -k"
	@ $(JOURNALCTL) $(JOURNALOPT) -k > $(DIST)/$(PREFIX)-journalctl-kernel.txt 2>&1 || true; \

reboot: require-root inspect-me
	wall 'REBOOT AFTER 30 SECONDS'
	sleep 30
	/sbin/shutdown -r now

clean:
	test -d $(NAME)
	find $(NAME)/ -type f -ctime +30 -delete

