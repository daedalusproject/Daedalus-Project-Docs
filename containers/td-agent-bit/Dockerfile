FROM daedalusproject/base_td_agent_bit:201906201803
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/td-agent-bit/conf/td-agent-bit.conf /etc/td-agent-bit/td-agent-bit.conf

CMD ["/usr/bin/td-agent-bit", "-c", "/etc/td-agent-bit/td-agent-bit.conf"]
