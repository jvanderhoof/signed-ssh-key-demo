#!/bin/bash -ex

echo 'Generate a signed public key for the `zone-webservers` Zone'
# Sign client public key
docker cp ssh-client:/root/.ssh/id_rsa.pub .

ssh-keygen -s ca-certs/ca -I user_root -n zone-webservers -V +60m -z $(cat counter) id_rsa.pub

# Increment the cert counter
echo "$(($(cat counter) + 1))" > counter

docker cp id_rsa-cert.pub ssh-client:/root/.ssh/
rm -f id_rsa-cert.pub id_rsa.pub
