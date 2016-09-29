#!/usr/bin/env bash

set -e

if ! ls /etc/ssh/ssh_host_* 1> /dev/null 2>&1; then
  ssh-keygen -A
fi

if [ ! -d /home/git/.gitolite ]; then
    if [ ! -f /tmp/admin.pub ]; then
      echo "/tmp/admin.pub must exists for the setup !"
      exit 1
    fi

    chown -R git:git ~git
    sudo -H -u git sh -c 'mkdir ~/bin'
    sudo -H -u git sh -c 'git clone git://github.com/sitaramc/gitolite ~/gitolite'
    sudo -H -u git sh -c '~/gitolite/install -ln'
    sudo -H -u git sh -c '~/bin/gitolite setup -pk /tmp/admin.pub'
else
    if [ ! -f /tmp/admin.pub ]; then
      sudo -H -u git sh -c '~/bin/gitolite setup -pk /tmp/admin.pub'
    else
      sudo -H -u git sh -c '~/bin/gitolite setup'
    fi
fi

/usr/sbin/sshd -D