+++
title="Repositories"
weight = 420
+++

After some years dealing with Linux we fell in love with package managers, all our software we use is stored in packages, managed in some type of web server that allow use to download and install nay type of software and their dependences without driving ourselves crazy.

This seems to be marvelous and easy until, after some years or months you realize that although your servers use repos, the server using Centos you installed 3 years has NGINX 1.10 installed and the one you installed yesterday comes with NGINX 1.15.9.

Oh dear, what can we do? we are "maintaining" different versions of software with come with different config files and [features](http://nginx.org/en/CHANGES-1.14) that we cannot use in old versions, NGINX seems to work but using the same config of Percona Server 5.6 in Percona Server 5.7 breaks the service. This is a nightmare.

Some client ask you to enable TLS 1.3 in its server.... What we do? Update for latest version and pray for no errors? What about OpenSSL dependencies? Even we are using "infrastructure as code" managers, after some time our infra will be a "freak show" of unmanaged packages and servers. Fixed versions of our package fixes our problem until NGINX 1.10 vanishes from epel repo.

First idea came from a wise friend:

> We must be masters of our own repositories.

And the other idea we will discuss after:

> We must control software versions too.

Package repositories have been with us from more than 20 years and there are a lot of tools than allows us to manage our own repos. From the beginning, Daedalus Project uses [aptly](https://www.aptly.info/) for managing its Ubuntu repos. 

There are some pros about using this tool:

* Packages are mirrored once from original repos.
* Our servers download packages from a repo in the same network, download process is faster and it is not affected by downtimes (we have suffered [remi](https://rpms.remirepo.net/) many times).
* We can publish snapshots so every package version is fixed in time and any server downloading from this snapshot will always have the same package.

And the cons:

* *Storage*, after few months of maintaining copies of Ubuntu repos we need more than 100Gb to store all packages.

## Use different repo versions

Each generation of mazes should use the same repos with the same software versions. These repos will be updated for kernel security updates or security updates only.

There will be a published repo for each generation of mazes. If our first generation comes, hopefully, on October, mazes will use a repository flavour called **autum2019/main**.

For the time being daedalus-project repo has only two versions published, main and testing.

<center>
  <img src="/images/daedalusrepo20190403.jpg" alt="Daedalus-Project repo snapshot" />
</center>

## GPG keys

Daedalus Project repos uses their own GPG key for signing packages, make sure to import the key before using the repos.

```bash
wget -O - https://repo.daedalus-project.io/repo.daedalus-project.io.gpg-key.pub | sudo apt-key add -
```

## Available versions

### Main

Until versioning starts main is considered stable:
```
deb [arch=amd64] http://repo.daedalus-project.io/ bionic main
```

### Testing

Snapshot containing testing or experimental packages
```
deb [arch=amd64] http://repo.daedalus-project.io/ bionic testing
```
