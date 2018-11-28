#!/bin/bash


if [ "$#" = 0 ]; then
  echo -e "\e[00;31mError: You must provide an IP address\e[00m"
  exit
fi


IP=$1

if [ "$IP" = "-h" ]; then
   echo -e "\n\e[00;32mUSAGE: $0 IP_ADDRESS\e[00m\n"
   exit
fi


service denyhosts stop

echo -e "\n\e[00;32mRemoving IP $IP from DenyHosts blacklist\e[00m\n"

cd /var/lib/denyhosts
for file in $(find . -type f -not -name "allowed*");do
  sed -i "/$IP/d" $file
done

sed -i "/$IP/d" /etc/hosts.deny

service denyhosts start

echo -e "\n\e[00;32mDone!\e[00m\n"
