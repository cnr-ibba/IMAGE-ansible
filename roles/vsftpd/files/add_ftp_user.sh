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
FTP_SHELL="/bin/ftponly"
FTP_ALLOWED_USERS="/etc/vsftpd.allowed_users"

# get user from cmd
USER=$1

# generating random password
LENGTH=16
# ignore error 141 (thrown by urandom after head truncate its output)
PASSWORD=`tr -dc A-Za-z0-9_ < /dev/urandom | head -c ${LENGTH} | xargs` || if [[ "${PIPESTATUS[0]}" -eq 141 ]]; then true; else exit "${PIPESTATUS[@]}"; fi
CRYPTEDPASS=$(perl -e 'print crypt($ARGV[0], "password")' ${PASSWORD})

# define user home directory
USER_HOME="/home/ftp/${USER}"

# creating user (-M: no home, -p encrypted password)
useradd --home-dir ${USER_HOME} -M -p ${CRYPTEDPASS} --shell ${FTP_SHELL} ${USER}

# creating CHROOT directory for USER
mkdir ${USER_HOME}

# setting permissions for USER root directory
chown $USER:$USER ${USER_HOME}
chmod 755 ${USER_HOME}

# add user in  /etc/vsftpd.allowed_users
# https://stackoverflow.com/a/3557165
grep -qxF "${USER}" ${FTP_ALLOWED_USERS} || echo "${USER}" >> ${FTP_ALLOWED_USERS}

# debug
echo -e "\n\e[00;32mUser ${USER} successfully created! The password for this user is:\e[00m ${PASSWORD}\n"

# restart vsftp service
systemctl restart vsftpd.service
