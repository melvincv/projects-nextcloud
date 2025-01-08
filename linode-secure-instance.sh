#!/bin/bash

USERNAME="melvin"
HOSTNAME="nextcloud1"
IPV4="172.236.149.94"
IPV6="2600:3c15::f03c:95ff:fee7:29b8"

apt update && apt upgrade
timedatectl set-timezone 'Asia/Kolkata'
hostnamectl set-hostname $HOSTNAME

cat <<EOF >> /etc/hosts
${IPV4} ${HOSTNAME}
${IPV6} ${HOSTNAME}
EOF

adduser ${USERNAME}
adduser ${USERNAME} sudo

read -p "Now login as the regular user..."
exit

