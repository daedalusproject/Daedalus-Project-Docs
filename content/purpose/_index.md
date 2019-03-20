+++
title="Purpose"
weight = 100
+++

# What Daedalus Project aims to be?

You may already read that **Daedalus Project** aims to be a powerful interface for managing orchestrated applications and server configuration across multiple SaaS providers. Let's dig into those concepts:

Managing servers is not an easy peasy, there are a lot of concepts to dominate, starting from basic Linux knowlege to managing High Availability Clusters and beyond.

## Everyone has a beginning

You maybe start installing and configuring your first *LAMP* stack and you know, after some *apt-get* commands it works!. Then, you install some [unknown content managed web application](https://wordpress.org/). It works too, so beautiful!. Well, it seems that your dev workmates need to develop a new plugin for the blog. It's not a big deal, you say `User: user - Pass: 123` to then and where the blog files are....

Few hours later, angry customer calls your boss telling him that his blog is not running, some dev has dropped blog's databse because he or she thought that it was his/her cumputer instead of production one...
<center>
  <img src="/static/images/dropdatabase.jpg" alt="What have you done" width=50% />
</center>

## Growing up

After few accidents and useful learnings, the blog has daily backups, there are production and development environments, development team even has started to use [some rare tool called version control system](https://git-scm.com/).

So, everithing is pretty and able to be managed until there arrives a new request from your boss. Our customer is so happy with us that their friends want us to host manage and develop their blogs too. New blogs means more money, cool. So you create a new production and development server for new client, copy, paste and modify those robust configs that you used in previous works. After few hours your job is done, devs are happy, boss loves you and money will come soon.

But, wait a minute, there are new blogs comming. Are you supposed to create new blogs doing again same service provision? Are you going to paste again that configs. What happens if there is a bug in your web-server config? Are you supossed to change by hand all servers? You start having a bad feeling about this.
<center>
  <img src="/static/images/thefuture.jpg" alt="Are we doomed?" width=40% />
</center>

After looking in the Internet a solution comes up, so much sysadmins and developrs had the same problem and they created automated config managers, some of them look [marvelous](https://www.ansible.com/). You already had written some [cool scripts](https://github.com/a-castellano/nextcloud_backups_aws_s3) but this concepts is beyong that. Looking forward for a better future you begin to learn how to orchestrate your infra using those tools.

## Orchestrate all the things

Here you are, the master of jinja2 templating, all your machines are being managed using the same tool. A new blog comes? A new *blog_server* is added to your **inventory.yaml** file. During this development you realize that some customers need more or less php memory consumption, this is not a problem since you mastered templating. Your past version of yourself would be proud of [what have you done](https://github.com/a-castellano/Sysadmin-Scripts/tree/master/Ansible). After few months of dealing with it you perhaps changed your base tool by some [cooler one](https://www.saltstack.com/).

Some customers have their own devlopment team for their blogs, so you have a file containing their credentials for each blog. New dev comes to your team, you copy and paste its *ssh-key* in all your blogs, not a big deal. Not a big deal, isn't it? Some dev leaves the company and you have to delete its access from all the machines he/she had access to, machine by machine. Uhm, you have duplicated information in your not-so-cool system... Every time a customer needs to have FTP services enabled you have to remember to open that conections in your orquestrated firewall configuration. New customer arrives asking you to host his [fabolous e-commerce site](https://magento.com/) which config has to be orchestrated almost from the beginning. which config has to be orchestrated almost from the beginning...

There are many more examples that probe that althought your tools work, they could work even better if you go beyond simple templating.

<center>
  <img src="/static/images/escalatedquickly.jpg" alt="That escalated quickly" width=40% />
</center>

There is a need for maintaining Information Systems, containing your clients info, Bussiness Inteligence platforms to deploy apps with multiple services interconected and make your infra easier to operate.

This is the aim of this project. 

* Mantain an information system to manage your client organizations, yours too.
* Apply the smart rules for managing applications services across complex infrastructure.
* Escape from technical debt allowing service configs versioning.
* Avoid hardcoding, duplicad info and any techncal debt that will bother you in the next months.
* Use evolutionary clean designs adaptable to changes.
* Think twice, (try to) code once.
