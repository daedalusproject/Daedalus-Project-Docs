+++
title="Logging"
weight = 540
+++

This section shows how logging is being configured inside Daedalus Project components. And how logging should be configured in client's projects.

## How much important logging is?

In any production scenario any organization wonders things like that:

* My app, shop, blog, etc is working right now?
* My app, shop, blog, etc is still working at 5 am isn't it?
* What happened three months ago when we started our mid Season Sales campaign?
* New campaign is coming, are my servers and my app able to handle a hundreds of requests per second?
* What did user 213012831 do yesterday?
* Who did grant the new inter access to Sysadmin group?
* Who did modify this critical config file?
* Are you sure that my app, shop, blog, etc is working right now?

Those wonders become requisites:

* Log what is happening in our app.
* Log how this app is using our resources (CPU, Memory, System load, Network bandwidth, etc).
* Correlate behavior logs with status logs (like [APM](https://www.elastic.co/solutions/apm)).

## Logs persistence

So, we have logs for the most popular services. By default those services come with logrotate configurations which will purge old logs (by default NGINX logs older than 14 days are purged). With log rotation system disks shouldn't fill up. At the end of rotation those files will be erased.

One of the wonders is to know what happened in the past, maybe months ago. Because of that **store old logs is mandatory**. This logs should be stored out of production servers, maybe in AWS S3, GCP Cloud Storage, Cepth server, etc

This storage should be as cheap as possible because it will be rarely checked after stored.

About storing logs until the end of times, it depends. There are laws about that, organizations may want to store logs for 20 years, etc. Any project will have its own log retention policy.

With cloud technologies like Kubernetes a new problem comes. There is not a server writing logs anymore. There are ephemeral pods serving apps or services that could die in any moment. Its logs must be sent outside as soon as they are generated. Therefore a logcollector is or persistent volume is needed.

## Logs relevance

Some logs are more relevant than others. If not all requests received from this site are recollected there is not a real problem. If some of our [bots delete entire organization infrastructure](https://www.theregister.co.uk/2019/05/31/digitalocean_killed_my_company/) someone is doomed, if there are not logs that allows us to trace this incident more people are doomed.

So the more critical losing our logs is the more resilient logging process has to be.

## Use cases

Here are examples of how Daedalus Project apps are being logged:

* [Daedalus Project Docs](/infrastructure/logging/daedaus-project-docs/)
