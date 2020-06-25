#!/bin/bash

# https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/
set -e
set -u
set -x
set -o pipefail

if [ "$#" = 0 ]; then
  echo -e "\e[00;31mError: You must provide a user name\e[00m"
  exit
fi

# define some variables
FTP_ALLOWED_USERS="/etc/vsftpd.allowed_users"

# get user from cmd
USER=$1

# preserve home while removing user
deluser ${USER}

# remove line from allowed ftp users
# https://stackoverflow.com/a/5410784
sed -i.bak "/${USER}/d" ${FTP_ALLOWED_USERS}

# debug
echo -e "\e[00;32mDone! User '${USER}' has been removed\e[00m"

# restart vsftp service
systemctl restart vsftpd.service
