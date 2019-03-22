+++
title="Architecture"
weight = 400
+++

During the writting of [requirements](/requirements) and [services](/services) (Summer 2017) we realized that we were describing an interconnected service ecosystem.

(Micro)Services? Docker? Kubernetes? Let's use them all! Let's use Google Cloud or AWS from the begining! We will use them all because they are so cool.

<center>
  <img src="/images/holdmycloud.jpg" alt="Hold my cloud." width=50% />
</center>

Wait, we have never used Docker for any serious project neither Kubernetes but after reading what [Kubernetes](https://kubernetes.io/) is, we were tempted to use them. So let's first learn how to use Docker and [kubernetes](https://github.com/a-castellano/kubernetes-tutorials) and we will see if our project can be deployed in Kubernetes cluster.

We should develop software not for Docker nor kubernetes directly, we don't want to asume any technologies, it will make or development process slower but we don't want our software to be platform or technology dependend. Software development over the decades has bring us package managemnt, services (systemd), /etc config files, log management and it will be a regretful error not to use all this knowleges in our project.

So, all our services should be platform agnostic.

Of course our budget is low.

More info will be added soon.
