FROM daedalusproject/base_nginx_daedalus_light:201906201803
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/nginx/release/nginx/vhost /etc/nginx/sites-enabled/default
COPY containers/nginx/conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY vhostlocations.conf /etc/nginx/vhostlocations.conf
COPY realip.conf /etc/nginx/realip.conf
COPY --chown=www-data:www-data public /var/www/daedalus-project-docs

# Forward request and error logs to docker log collector
RUN chown -R www-data:www-data /var/lib/nginx \
    && mkdir -p /var/run/nginx \
    && chown www-data:www-data /var/run/nginx \
    && date +%Y%m%d%H%M > /var/www/datecontentcreated

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
