Dockerfile - Crate.io
=========================
#### Build
```
root@ruo91:~# git clone https://github.com/ruo91/docker-crate /opt/docker-crate
root@ruo91:~# docker build --rm -t crate /opt/docker-crate
```

#### Run
```
root@ruo91:~# docker run -d  --name="crate" -h "crate" \
-p 4200:4200 -p 4300:4300 crate
```
