+++
title="Docker images"
weight = 425
+++

Starting from these docs, one of Daedalus Project wills is maintain almost all its projects inside versioned docker images.

### Preamble

Daedalus Project images must use Windmaker and Daedalus Project [repos](/architecture/repos/), therefore, at the beginning of our Dockerfiles we must enable those repos. But... Do we really need to perform this action in all our images? Let's see the following examples:

**base_hugo**:
```Dockerfile
FROM ubuntu:bionic
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

RUN  apt-get update -qq
RUN  apt-get install -qq -o=Dpkg::Use-Pty=0 -y gnupg ca-certificates wget --no-install-recommends
RUN  wget -O - http://packages.windmaker.net/WINDMAKER-GPG-KEY.pub | apt-key add -
RUN  wget -O - http://repo-bionic.windmaker.net/repo-bionic.windmaker.net.gpg-key.pub | apt-key add
RUN  wget -O - https://repo.daedalus-project.io/repo.daedalus-project.io.gpg-key.pub | apt-key add
RUN  echo "deb http://repo-bionic.windmaker.net/ bionic main" > /etc/apt/sources.list
RUN  echo "deb http://packages.windmaker.net/ any main" >> /etc/apt/sources.list
RUN  echo "deb [arch=amd64] http://packages.windmaker.net/ bionic main" >> /etc/apt/sources.list
RUN  echo "deb [arch=amd64] http://repo.daedalus-project.io/ bionic main" >> /etc/apt/sources.list
RUN  apt-get update -qq
RUN  apt-get install -y hugo git
```

**base_node8**:
```Dockerfile
FROM ubuntu:bionic
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

RUN  apt-get update -qq
RUN  apt-get install -qq -o=Dpkg::Use-Pty=0 -y gnupg ca-certificates wget --no-install-recommends
RUN  wget -O - http://packages.windmaker.net/WINDMAKER-GPG-KEY.pub | apt-key add -
RUN  wget -O - http://repo-bionic.windmaker.net/repo-bionic.windmaker.net.gpg-key.pub | apt-key add
RUN  wget -O - https://repo.daedalus-project.io/repo.daedalus-project.io.gpg-key.pub | apt-key add
RUN  echo "deb http://repo-bionic.windmaker.net/ bionic main" > /etc/apt/sources.list
RUN  echo "deb http://packages.windmaker.net/ any main" >> /etc/apt/sources.list
RUN  echo "deb [arch=amd64] http://packages.windmaker.net/ bionic main" >> /etc/apt/sources.list
RUN  echo "deb [arch=amd64] http://repo.daedalus-project.io/ bionic main" >> /etc/apt/sources.list
RUN  apt-get update -qq
RUN  apt-get install -y nodejs npm
```

Let's supouse that we create base_hugo today and (for any reason) we create base_node8 few days before in other machine. We end with this image sizes:
```
REPOSITORY          TAG                 IMAGE ID            CREATED              SIZE
base_node8          latest              f822f1c880ba        8 seconds ago        456MB
base_hugo           latest              c71ffac6790d        About a minute ago   266MB
ubuntu              bionic              94e814e2efa8        3 weeks ago          88.9MB
```

Such a space isn't?
```
--- /var/lib/docker -----------------------------------------------------------------------------------------------------------------------------------------------------------------
  651.8 MiB [##########] /overlay2
```

What about our layers?
<center>
  <img src="/images/layeroverload.jpg" alt="Layer Overload" />
</center>

But...almost all the **RUN** commands did the same, their fingerprint differ. We don't like it...
When Docker image is created, any **RUN**, **COPY** and **ADD** command creates a new layer. During image download process, docker daemons downloads those layers.

> If we create those images at the time time almost all RUN's will use cache ant the images will be smaller.

What happens if we create a base image containing our repos and after that we create other images that uses our base image? Let's use some [optimization tips](https://hackernoon.com/tips-to-reduce-docker-image-sizes-876095da3b34) too.
```
--- /var/lib/docker -----------------------------------------------------------------------------------------------------------------------------------------------------------------
  318.1 MiB [##########] /overlay2
```

What about dependencies?

<center>
  <img src="/images/dockerinheritance.jpg" alt="Docker iamges Inheritance" />
</center>

It works! So all Daedalus Project should use inherited images from stable base images. When all our images are download many of them may share the same layers.

[Limani](https://git.daedalus-project.io/docker/Limani) repository has been created for maintaining our base images.

### Behaviour

We create a **base** images containing our repositories. **base_hugo** is built from **base** and so on.

This is our current image structure.

<center>
  <img src="/images/limani.jpg" alt="Docker images inheritance" />
</center>

These docs are generated inside two docker images, [daedalus-project-docs-develop](https://hub.docker.com/r/daedalusproject/daedalus-project-docs-develop) and [daedalus-project-docs](https://hub.docker.com/r/daedalusproject/daedalus-project-docs) and uses [base_nginx_light](https://git.daedalus-project.io/docker/Limani/tree/master/base_nginx_light) as base image.
