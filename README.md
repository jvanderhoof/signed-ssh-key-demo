# Signed SSH Keys (for managing SSH access)

This demo came out of a desire to understand how SSH key signing works. I used the following resources as heavy inspiration:

* [Digital Ocean Tutorial](https://www.digitalocean.com/community/tutorials/how-to-create-an-ssh-ca-to-validate-hosts-and-clients-with-ubuntu)
* [Facebook Engineering Blog Example](https://code.facebook.com/posts/365787980419535/scalable-and-secure-access-with-ssh/)


### Setup

```
$ ./0_start.sh
```

Starts two containers: `ssh-server` and `ssh-client`.

### Configure SSH Server
```
$ ./1_run.sh
```
performs the following:
1) Creates a new public/private certificate pair to use as our CA root certificate.
2) Signs the SSH Server public key
3) Configures the SSH server to validate connections against the public CA certificate
4) Generates a public/private key pair for the SSH Client
5) Adds the public CA certificate to the know hosts file on the client

### Generate a Signed SSH key
This command signs the client public SSH key, which is good for 10 seconds:
```
$ ./2_generate_signed_cert.sh
```

Then, login to the `ssh-client` container and connect to the server:
```
$ docker-compose exec ssh-client bash
# ssh root@ssh-server
```
If the above ssh command fails, regenerate the signed certificate and try again.

### Create two SSH Zones
Next, create two zones: `zone-webservers` and `root-everywhere` on the SSH server.
```
$ ./3_create_zones.sh
```
The client will be unable to login with a simple signed certificate.

### Generate a Signed SSH key for the `zone-webserver` Zone
This command signs the client public SSH key for the `zone-webserver` zone (valid for 60 minutes):
```
$ ./4_generate_zoned_signed_cert.sh
```

You should now be able to connect to the server from the client.

### Revoke Access
Next we'll revoke the client's public key:
```
$ ./5_revoke_key
```

### Shut it Down
Remove all running containers:
```
$ ./6_stop.sh
```

## Additional Resources:
* https://ef.gy/hardening-ssh
