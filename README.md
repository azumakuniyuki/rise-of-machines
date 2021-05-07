RISE-OF-MACHINES
===================================================================================================

How To Use
---------------------------------------------------------------------------------------------------
### 1. Clone this repository
```
% git clone https://github.com/azumakuniyuki/rise-of-machines.git
Cloning into 'rise-of-machines'...
remote: Enumerating objects: 249, done.
remote: Total 249 (delta 0), reused 0 (delta 0), pack-reused 249
Receiving objects: 100% (249/249), 41.73 KiB | 485.00 KiB/s, done.
Resolving deltas: 100% (125/125), done.
```

### 2. Rename The Directory
```
% mv ./rise-of-machines ./mx2.neko.example.org
```

### 3. Edit server/for-install file
```
#   __                 _           _        _ _ 
#  / _| ___  _ __     (_)_ __  ___| |_ __ _| | |
# | |_ / _ \| '__|____| | '_ \/ __| __/ _` | | |
# |  _| (_) | | |_____| | | | \__ \ || (_| | | |
# |_|  \___/|_|       |_|_| |_|___/\__\__,_|_|_|
#                                               
# Ansible inventory file for setting up environment: python, sudo run as root.
# % ansible-playbook -i server/for-install path/to/playbook.yml
#
[install]
mx2.neko.example.org

[install:vars]
ansible_ssh_port=22
ansible_ssh_user=root
ansible_ssh_pass="root-password-here"
#ansible_ssh_private_key_file=/path/to/.ssh/secret-key
#ansible_python_interpreter=/usr/local/bin/python2.7
#ansible_connection=paramiko
```

### 4. Edit server/130-configure-sshd.yml file
```
...
  vars:
    sshd:
      execute:   true
      port:      22202
      rootlogin: "no"
...
```

### 5. Execute "make env"
```
% make env
cd .ssh && /usr/bin/make DEPLOYKEY=./.ssh/ssh.deploy-rsa.key DEPLOYUSER=deploy all
make[1]: Nothing to be done for `all'.
chmod 0600 ./.ssh/ssh.deploy-rsa.key
chmod 0644 ./.ssh/ssh.deploy-rsa.pub
cd server && make env
ansible-playbook -i ./for-install \
		100-update-package.yml 101-install-python.yml 102-notuse-selinux.yml \
		103-apply-hostname.yml 104-never-use-ipv6.yml 105-ipv4-than-ipv6.yml \
		110-configure-sudo.yml 120-user-to-deploy.yml 130-configure-sshd.yml
...


% ssh -l deploy -i ./.ssh/ssh.deploy-rsa.key -p 22202 mx1.neko.example.org
```

System requirements
---------------------------------------------------------------------------------------------------
* Ansible 2.8.5 or later
* Python 3.6 or later

Author
===================================================================================================
[@azumakuniyuki](https://twitter.com/azumakuniyuki)

Copyright
===================================================================================================
Copyright (C) 2014-2021 azumakuniyuki, All Rights Reserved.

License
===================================================================================================
This software is distributed under The BSD 2-Clause License.

