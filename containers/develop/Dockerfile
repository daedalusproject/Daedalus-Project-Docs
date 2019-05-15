FROM daedalusproject/base_nginx_daedalus_light:201904300501
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/develop/nginx/vhost /etc/nginx/sites-enabled/default
COPY containers/conf/nginx/nginx.conf /etc/nginx/nginx.conf
COPY vhostlocations.conf /etc/nginx/vhostlocations.conf
COPY realip.conf /etc/nginx/realip.conf
COPY --chown=www-data:www-data public /var/www/daedalus-project-docs

# forward request and error logs to docker log collector
RUN chown -R www-data:www-data /var/lib/nginx \
    && mkdir -p /var/run/nginx \
    && chown www-data:www-data /var/run/nginx \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

USER www-data

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
