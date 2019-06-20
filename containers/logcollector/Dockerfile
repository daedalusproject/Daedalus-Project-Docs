FROM daedalusproject/base_td_agent:201906201803
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/logcollector/conf/td-agent.conf /etc/td-agent/td-agent.conf

CMD ["/opt/td-agent/embedded/bin/fluentd"]
