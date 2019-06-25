+++
title="Daedalus Project Docs"
weight = 541
+++

This section shows how logging is implemented for this wiki.

### What we need to log

These docs are generated using [Hugo](https://gohugo.io/), this wiki is a static site (here is the [repo](https://git.daedalus-project.io/docs/Daedalus-Project-Docs)). User requests do not trigger internal events like modern webapps. The only relevant thing to be logged is which visitors are requesting our page.

### Purpose

The main purpose of collecting logs from this wiki is learn about logging recollection tools, learning how to use then in a non critical scenario (that will come later).

### Implementation

Here are some log recollection tools:

* [Logstash](https://www.elastic.co/products/logstash)
* [Fluentd](https://www.fluentd.org/)
* [Fluent Bit](https://fluentbit.io/)
* [Loki](https://grafana.com/loki)

After searching about this tools, Loki was rejected, it is a very promising and interesting project but it is not mature yet (June 2019). On the other hand, Fluentd is a [Cloud Native Computing Foundation (CNCF)](https://www.cncf.io/) member project and it seems to be lighter than Logstash (this service has not been tested yet).

First Implementation suggestion was the following:

* Nginx serving this content and logging against Syslog server.
* Fluentd listening as Syslog server and delivering logs to S3 and Elasticsearch.

<center>
  <img src="/images/DaedalusProjectLogColectorFirstVersion.jpg" alt="First Implementation" />
</center>

This implementation should work but, what happens if Fluentd is down? Logs get lost. It won't be a problem but the main purpose is learning so let's assume. It won't be a problem but the main purpose is learning so let's assume log recollection is critical so logs can't get lost. We need a log collector that retries sending information if the endpoint is not working.

A second implementation suggestion comes:

* Nginx serving this content and logging against log file.
* Fluentbit reads those files and sends info to central Fluentd service.
* Fluentd receives that information and forward it to S3 and Elasticsearch.

### Logging Stack

It wouldn't be the first time 20Gb log file fills our filesystem, if there are log files they must be rotated and purged. Since our Nginx server is running inside Docker container there is no cron executing log rotate. Original Kubernetes pod becomes a three container pod:

* Nginx serves content and writes logs against files.
* Logrotate container execute cron tasks for rotating Nginx Logs
* Fluentbit container read logs and tries to sent them to Fluentd.

Each container needs to see processes running inside pod and share log folder:

Our deployment:
```yml
apiVersion: apps/v1
kind: Deployment
metadata:
  namespace: daedalus-project-docs
  name: daedalus-project-docs
  labels:
    app: daedalus-project-docs
spec:
  selector:
    matchLabels:
      app: nginx
      role: project-docs
  replicas: 3
  template:
    metadata:
      labels:
        app: nginx
        role: project-docs
    spec:
      volumes:
      - name: nginx-logs
        emptyDir: {}
      shareProcessNamespace: true
      containers:
      - name: daedalus-project-docs-nginx
        image: daedalusproject/daedalus-project-docs:__IMAGE_TAG__
        volumeMounts:
        - name: nginx-logs
          mountPath: /var/log/nginx
        resources:
          limits:
            cpu: 20m
            memory: 20Mi
          requests:
            cpu: 20m
            memory: 20Mi
        securityContext:
          allowPrivilegeEscalation: false
        ports:
        - containerPort: 80
        readinessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 5
          periodSeconds: 10
        livenessProbe:
          tcpSocket:
            port: 80
          initialDelaySeconds: 10
          periodSeconds: 20
        lifecycle:
          postStart:
            exec:
              command:
                - "sh"
                - "-c"
                - >
                  /bin/chmod 755 /var/log/nginx;
                  /bin/chown root:adm /var/log/nginx;
          preStop:
            exec:
              command:
                  - "/usr/sbin/nginx"
                  - "-s"
                  - "quit"
      - name: daedalus-project-docs-logrotate
        image: daedalusproject/daedalus-project-docs-logrotate:__IMAGE_TAG__
        volumeMounts:
        - name: nginx-logs
          mountPath: /var/log/nginx
        resources:
          limits:
            cpu: 20m
            memory: 20Mi
          requests:
            cpu: 20m
            memory: 20Mi
        securityContext:
          allowPrivilegeEscalation: false
      - name: daedalus-project-docs-td-agent-bit
        image: daedalusproject/daedalus-project-docs-td-agent-bit:__IMAGE_TAG__
        volumeMounts:
        - name: nginx-logs
          mountPath: /var/log/nginx
        resources:
          limits:
            cpu: 20m
            memory: 20Mi
          requests:
            cpu: 20m
            memory: 20Mi
        securityContext:
          allowPrivilegeEscalation: false
      terminationGracePeriodSeconds: 150
```

Nginx log format has been changed to JSON format. Parameters returned have been updated, here is the current **log_format**:
```
   log_format json_log escape=json '{"connection_serial_number":$connection,'
                                    '"number_of_requests":$connection_requests,'
                                    '"response_status":"$status",'
                                    '"body_bytes_sent":$body_bytes_sent,'
                                    '"content_type":"$content_type",'
                                    '"host":"$host",'
                                    '"host_name":"$hostname",'
                                    '"query_string":"$query_string",'
                                    '"client_address":"$remote_addr",'
                                    '"http_ar_real_proto":"$http_ar_real_proto",'
                                    '"http_ar_real_ip":"$http_ar_real_ip",'
                                    '"http_ar_real_country":"$http_ar_real_country",'
                                    '"request":"$request",'
                                    '"request_time":$request_time,'
                                    '"request_id":"$request_id",'
                                    '"request_length":$request_length,'
                                    '"request_method":"$request_method",'
                                    '"request_uri":"$request_uri",'
                                    '"request_body":"$request_body",'
                                    '"scheme":"$scheme",'
                                    '"server_addr":"$server_addr",'
                                    '"server_protocol":"$server_protocol",'
                                    '"http_user_agent":"$http_user_agent",'
                                    '"time_iso":"$time_iso8601",'
                                    '"time_msec":"$msec",'
                                    '"url":"$scheme://$host$request_uri",'
                                    '"uri":"$uri"}';
```

Remember that when Nginx logs are rotated, Nginx needs to know it for releasing file descriptors and use new log files. Inside our logrotate container there is no Nginx process so logrotate needs to find it.

Logrotate Nginx config
```
/var/log/nginx/*.log {
    daily
    missingok
    rotate 5
    size 10M
    compress
    delaycompress
    notifempty
    create 0640 www-data adm
    sharedscripts
    postrotate
        kill  -USR1 $(ps -ef | grep 'nginx: master process' | awk '{print $2}' | head -1)
    endscript
}
```

Fluentbit only reads log files and forwards recollected info to fluentd service:
```
[SERVICE]
    Flush        60
    Grace        120
    Parsers_File parsers.conf

[INPUT]
    Name        tail
    Parser      json
    Path        /var/log/nginx/access.log

[OUTPUT]
    Name          forward
    Match         *
    Host          logcollector
    Port          9880
    tls           off
```

Fluentd service will send logs to Elasticsearch and AWS S3 bucket:
```xml
<source>
  @type forward
  bind 0.0.0.0
  port 9880
</source>
<match tail.0 >
  @type copy
  <store>
    @type s3
    aws_key_id _@_AWS_KEY_ID_@_
    aws_sec_key _@_AWS_SECRET_KEY_@_
    s3_bucket _@_S3_BUCKET_NAME_@_
    s3_region eu-west-1
    path develop-logs/
    <buffer tag,time>
      @type file
      path /tmp/fluents3
      timekey 300
      timekey_wait 10m
      flush_interval 5m
      timekey_use_utc true # use utc
      chunk_limit_size 5m
      flush_at_shutdown true
    </buffer>
  </store>
  <store>
    @type elasticsearch
    host _@_ELASTICSEARCH_HOST_@_
    port 9200
    user _@_ELASTICSEARCH_USER_@_
    password _@_ELASTICSEARCH_PASSWORD_@_
    index_name _@_ELASTICSEARCH_INDEX_@_
    pipeline geoip
  </store>
</match>
```

This is the Stack suggested for collecting this wiki logs:
<center>
  <img src="/images/DaedalusProjectLogColectorStack.jpg" alt="Log Colector Stack" />
</center>

### Visualizing results

Results are stored in AWS S3 Bucket and Elasticsearch instance:

* S3 Bucket is used for "infinite" log storage.
* Elasticsearch is used for real time visualization.

If there is new data, every 5 minutes fluentd sends logs to S3 bucket:
<center>
  <img src="/images/DaedalusProjectLogColectorResultsS3.jpg" alt="S3 Log Colector Results" />
</center>

For visualizing almost real time data a Kibana dashboard has been created.
<center>
  <img src="/images/DaedalusProjectLogColectorResults.jpg" alt="Log Colector Results" />
</center>

Kibana dashboard is available publicly:

* URL: [https://kibana.daedalus-project.io](https://kibana.daedalus-project.io/s/daedalus-project-docs-develop/app/kibana#/dashboards?_g=\(\))
* User: guest
* Password: seameguest

### Final thoughts

This document is not completed yet:

* How AWS IAM has been configured to write only in our S3 bucket has to be documented.
* How Elasticsearch has been configured and secured has to be documented.
* How Elasticsearch indexes, pipelines and users have been created has to be documented.
* How Elasticsearch are purged has to be documented.
