#!/bin/bash -ex

docker-compose exec ssh-server bash -c '
  echo "RevokedKeys /etc/ssh/revoked-keys" >> /etc/ssh/sshd_config
  service ssh restart
'

docker cp ssh-client:/root/.ssh/id_rsa.pub .

ssh-keygen -k -f revoked-keys id_rsa.pub

docker cp revoked-keys ssh-server:/etc/ssh/
rm -f revoked-keys id_rsa.pub
