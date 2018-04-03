```
$ docker build -t eg_sshd -f Dockerfile.sshd .
```

```
$ docker run -d -P --name test_sshd eg_sshd
```

```
$ docker port test_sshd 22
$ ssh root@192.168.1.2 -p 32768
```
