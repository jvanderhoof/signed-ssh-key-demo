#!/bin/bash -ex

echo ' -- Generate CA --'
ssh-keygen -C CA -f ca-certs/ca -N ''
echo ''

echo ' -- Sign SSH Server key using local CA cert -- '
docker cp ssh-server:/etc/ssh/ssh_host_rsa_key.pub .
ssh-keygen -s ca-certs/ca -I host_sshserver -h -n ssh-server -V +1w ssh_host_rsa_key.pub
docker cp ssh_host_rsa_key-cert.pub ssh-server:/etc/ssh/
docker-compose exec ssh-server service ssh restart

rm ssh_host_rsa_key.pub ssh_host_rsa_key-cert.pub
echo ''

echo ' -- Tell sshd to use signed cert to validate host --'
docker-compose exec ssh-server bash -c '
  echo "HostCertificate /etc/ssh/ssh_host_rsa_key-cert.pub" >> /etc/ssh/sshd_config
  echo "TrustedUserCAKeys /etc/ssh/ca.pub" >> /etc/ssh/sshd_config
  service ssh restart
'
echo ''

echo ' -- Generate SSH key pair on client (and add public CA cert to prevent connection warnings) --'
docker-compose exec ssh-client bash -c '
  ssh-keygen -f ~/.ssh/id_rsa -t rsa -N ""
  echo "@cert-authority * $(cat /etc/ssh/ca.pub)" > ~/.ssh/known_hosts
'
