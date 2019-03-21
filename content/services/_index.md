+++
title="Services"
weight = 200
+++

In the previous section we talked about orchestrating servers, managing configurations, maintaining an information system and so on. This seems to end into a huge project that will became Legacy before first demo. Daedalus Project is not a giant monolitic app, it splits into many services.

In this section the concept of **Maze** is referenced for the first time, this concept will be introduced in the [next section](/architecture).

### Daedalus Core
[Repo](https://git.daedalus-project.io/daedalusproject/Daedalus-Core)

Information system which also manages all other services, clients, organization and projects. The entrypoint for Daedalus Project users and services.

Technology: [Perl Catalyst](http://www.catalystframework.org/).
### Gorgon
There is no Repo yet.

Web frontend which allows users interact with Daedalus services.

Technology: Maybe [React](https://reactjs.org/).
### Hermes
[Repo](https://git.daedalus-project.io/daedalusproject/Hermes-Perl)

Hermes provides communication between Daedalus Project services. It is essencialy a distributed message broker library included in all services.

Technology: For the time being there is only a Perl implementation using [RabbitMq](https://www.rabbitmq.com/).
### Iris
> The personification of the rainbow and messenger of the gods.

This service sends notifications outside Daedalus Project Realms such as:

* e-mails
* other services (not defined yet)

Technology: Perl script.
### Icarus
There is no Repo yet.

This service provides Saas management across all suported providers (machine creation, Saas service management, etc). As and example it is supposed to manage VPC firewall rules acording with Demeter provided Info.

Technology: Not defined yet but we need a language where most of the SaaS providers SDK's present.
### Aion
> The "time" represented by Aion is unbounded, in contrast to Chronos as empirical time divided into past, present, and future.

There is no Repo yet.

The timekeeper, this service manages backups from projects (machines and Daedalus data itself). There is one Aion present for each maze.

Technology: Not defined yet.
### Demeter
There is no Repo yet.

This service manages Project's info (maze configuration, Project's machines, service balancers, backups policy, monitoring preferences, alert policy). It seems to be a huge service so it should be redefindes as a set of multiple services.

Technology: Not defined yet. Maybe it will use a non relatioal database because each Saas has its own config.
### Nereus
There is no Repo yet.

Acording with Demeter info it will render machines or service info which will be used by its Nereid.

Technology: Not defined yet.
### Nerites
There is no Repo yet.

Service config deployer (uses Nereus info), manages configuration for the following Maze services:
* Iris
* Nereid
* Kairos
* Aion

Technology: Not defined yet.
### Nereid
There is no Repo yet.

Machine config deployer (uses Nereus info).

Technology: Not defined yet. Maybe we will use [SaltStack](https://www.saltstack.com/).
### Kairos
There is no Repo yet.

Realtime Monitoring Maze service.

Technology: Not defined yet. Maybe we will use [Prometheus](https://prometheus.io/).
### Agathodaemon
> Ensures good luck, health, and wisdom.

Project's monitoring services, provides monitoring info provided by Mazes Kairos service.

There is no Repo yet.

Technology: Not defined yet. Mybe we will use [Prometheus](https://prometheus.io/) and [Grafana](https://grafana.com/).

-------------------

As this project grows more services will be added.
