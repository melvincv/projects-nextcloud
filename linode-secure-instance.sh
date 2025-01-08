#!/bin/bash

USERNAME="melvin"
HOSTNAME="algo-sgp"
IPV4="172.236.149.86"
IPV6="2600:3c15::f03c:95ff:fee7:6d20"
PUBLIC_KEY="ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMZC+6qyiAuiMjnXEOH3VRJ2KWbZuEwax9UTGvniBe9b melro@MELZ-LAPTOP"

apt update -y && apt upgrade -y
timedatectl set-timezone 'Asia/Kolkata'
hostnamectl set-hostname $HOSTNAME

cat <<EOF >> /etc/hosts
${IPV4} ${HOSTNAME}
${IPV6} ${HOSTNAME}
EOF
echo
echo Set your password.
echo
adduser ${USERNAME}
adduser ${USERNAME} sudo

mkdir /home/${USERNAME}/.ssh/
echo "${PUBLIC_KEY}" > /home/${USERNAME}/.ssh/authorized_keys
sudo chown -R ${USERNAME}: /home/${USERNAME}/.ssh/
sudo chmod -R 700 /home/${USERNAME}/.ssh && chmod 600 /home/${USERNAME}/.ssh/authorized_keys

# sshd options
sudo cp -av /etc/ssh/sshd_config /etc/ssh/sshd_config.bk
sudo sed -i 's/^PermitRootLogin\s*yes\s*$/PermitRootLogin no/' /etc/ssh/sshd_config
sudo sed -i 's/^PasswordAuthentication\s*yes\s*$/PasswordAuthentication no/' /etc/ssh/sshd_config
sudo systemctl restart ssh

echo
echo "Now logging in as the regular user..."
echo

su - ${USERNAME}
