#!/bin/bash -ex

echo 'Generate a signed public key for the `zone-webservers` Zone'
# Sign client public key
docker cp ssh-client:/root/.ssh/id_rsa.pub .

ssh-keygen -s ca-certs/ca -I user_root -n zone-webservers -V +60m -z 1 id_rsa.pub

docker cp id_rsa-cert.pub ssh-client:/root/.ssh/
rm -f id_rsa-cert.pub id_rsa.pub
