+++
title="Requirements"
weight = 200
+++

Every production-ready project must have defined requirements before start, we will never start coding without knowing what are going to do.

# Abstract

Daedalus Project manages **Projects**.

* Projects mean applications hosted in Mazes.
* A Maze is a group of servers and services.
* Servers can be hosted at Saas providers.
* Projects are owned by Organizations.
* Projects are managed by Organizations.

## Organizations

* An organization is an official group of people, in our case it should be a company or a single person.
* A potential new user must receive an e-mail to join to Daedalust Project.
* That user must be able to create one or more Organizations.
* Each Organization needs to provide their billing info and sign user contracts before become enabled by Daedalus Project Administrator(s).
* First created user becomes Master User of his/her Organization.
* Once the organization has been created, Master User can invite/create new users to his/here Organization.
* Master User may grant access to foreign organizations that will be able to operate in his/her organization projects.

## Projects & Mazes

* Projects are applications hosted in Mazes.
* A Maze is a set of servers and services.
* The number of servers and their features depends on Organization requirements.
* There are two types of mazes:
  * Single Maze  ->  Low load production servers.
  * Complex Mazes -> High load production servers.
* All mazes come with monitoring service enabled.
* Projects have a name, description and Oracle.
* Project's Oracle knows project data (domain names, SSL certificates), service data ( Web Server and load balancer configurations, PHP memory limits, etc ), mazes visibility between each other.
* Project's Oracle also knows and maintains eligible infrastructure pieces (for example, how many frontends is using this Project).
* Organizations are able to create development environments using Project's Oracle data.
  * For example, development Complex Maze is deployed using and anonymized production database copy.
* Dadedalus Project must support many types of projects (Wordpress, Magento 1, Magento 2, Django, Catalyst, etc)
* Each type of projects may have its own information models so....
* Daedalus Project implementation MUST allow the addition of new project types, mazes services, servers configurations, server access policy.
* Simple and Complex mazes include services.
* Part of those services may be non eligible.
* Extra Services can be hired hired by the Organization.
* Projects are owned by Organizations and can be managed by the same organization or by another Organization.
* Apart of the Organization which owns a Project, only one more Organization can Manage that Project.
* If organization A wants Organization B to manage its project, A is able to choose the roles able to manage its project. For example A manages an e-commerce site and needs developers from organization B. So A is able to share its project with B only for Project Caretaker role.

## Users

* User belongs to one or more organizations.
* Each user belongs 0 or more groups.
* Each group has 0 or more roles.
* Organizations are able to manage groups of users with the same role. For example, an intern roles.
* An organization is able to manage groups of roles, for example groups of project's caretakers. When organization A wants some role of Organization B to manage its project, organization B is able to choose which users with that role are able to manage Organization A project.


## User Roles 

Organization users may have the following roles:

### Organization Master

* It can be more than one Organization Master in each Organization.
* This role is able to create new users inside its Organization.
* This role is able to assign roles inside its Organization.
* This role is the only able to create Projects.
* Organization Master is also who allows other Organizations to manage its projects.

### Project Caretaker
* This role manages (but does not create) projects owned or managed by its Organization.
* For each project, Project Caretaker supply Project Info to Project's Oracle.
* Project Caretaker is able to:
  * Deploy development environments which will be a copy of (parts of) the original project env.
  * Resize Project mazes.
  * Manage mazes firewall.
  * Manage mazes developers access.
  * Set Project domains.
  * Set SSL certificates and configs.
  * FTP jails.
  * Any other required service parameters....

###  Health Watcher

* This role is able to review maze status using centralized monitoring panel.
* It is also able to subscribe to monitoring alerts.

### Expense Watcher

* This role can review costs of Organization projects.
* This role can configure billing alerts.

### Fireman

* It is allowed to review health status of any organization project.
* This user is able to access to all servers of Project Mazes.

### Code deployer or config view roles.

Not defined yet but we know that has to be defined.

## Daedalus Project Operator Roles

### Maze Master

* Rules all the mazes.
* It is allowed to review, resize and manage any server, service or maze of any project.

### Fireman  Commando

* Sysadmin on duty
* This user is able to access to all servers of Project Mazes and become root.
* It's able to access to any Saas control panel.

### Daedalus Manager

* Super Admin User.
* Has all Fireman Commando properties.
