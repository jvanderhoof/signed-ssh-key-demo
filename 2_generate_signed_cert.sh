#!/bin/bash -ex

echo ' -- Sign client certificate (valid for 10 seconds) --'
# Sign client public key
docker cp ssh-client:/root/.ssh/id_rsa.pub .

# Generate a cert that's valid for 10 seconds
ssh-keygen -s ca-certs/ca -I user_root -n root -V +10s id_rsa.pub

docker cp id_rsa-cert.pub ssh-client:/root/.ssh/
docker-compose exec ssh-client chown root:root /root/.ssh/id_rsa-cert.pub
rm -f id_rsa-cert.pub id_rsa.pub
