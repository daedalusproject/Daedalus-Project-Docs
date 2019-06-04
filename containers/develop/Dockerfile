FROM daedalusproject/base_nginx_daedalus_light:201905230353
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/develop/nginx/vhost /etc/nginx/sites-enabled/default
COPY containers/develop/nginx/logrotate /etc/nginx/logrotate/nginx
COPY containers/conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY vhostlocations.conf /etc/nginx/vhostlocations.conf
COPY realip.conf /etc/nginx/realip.conf
COPY --chown=www-data:www-data public /var/www/daedalus-project-docs

# Forward request and error logs to docker log collector
RUN apt update -qq \
    && apt-get install -qq -o=Dpkg::Use-Pty=0 -y cron \
    && chown -R www-data:www-data /var/lib/nginx \
    && mkdir -p /var/run/nginx \
    && chown www-data:www-data /var/run/nginx \
    && rm -rf /var/lib/apt/lists/*

EXPOSE 80

STOPSIGNAL SIGTERM

CMD service cron start && nginx -g 'daemon off;'
