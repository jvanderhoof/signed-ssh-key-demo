#!/bin/bash -ex

echo 'Enable the zones `zone-webservers` and `root-everywhere` on the SSH server '
# Setup Zones
docker-compose exec ssh-server bash -c '
  echo "AuthorizedPrincipalsFile /etc/ssh/auth_principals/%u" >> /etc/ssh/sshd_config
  mkdir /etc/ssh/auth_principals
  echo -e "zone-webservers\nroot-everywhere" > /etc/ssh/auth_principals/root
  service ssh restart
  cat /etc/ssh/auth_principals/root
'
