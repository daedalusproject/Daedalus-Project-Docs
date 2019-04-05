FROM daedalusproject/base_nginx_light:201904051717
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/develop/nginx/vhost /etc/nginx/sites-enabled/default
COPY vhostlocations.conf /etc/nginx/vhostlocations.conf
COPY --chown=www-data:www-data public /var/www/daedalus-project-docs

# forward request and error logs to docker log collector
RUN ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log

EXPOSE 80

STOPSIGNAL SIGTERM

CMD ["nginx", "-g", "daemon off;"]
