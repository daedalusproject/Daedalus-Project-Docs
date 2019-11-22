FROM daedalusproject/base_logrotate:201911221930
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/logrotate/conf/nginx /etc/logrotate.d/nginx
COPY containers/logrotate/cron/logrotate /etc/cron.d/logrotate

RUN rm /etc/cron.daily/logrotate \
    && /bin/chmod 444 /etc/logrotate.d/nginx \
    && /bin/chmod 644 /etc/cron.d/logrotate \
    && /usr/bin/crontab /etc/cron.d/logrotate

STOPSIGNAL SIGTERM

CMD cron -f
