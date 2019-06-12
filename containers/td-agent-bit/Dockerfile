FROM daedalusproject/base_td_agent_bit
MAINTAINER Álvaro Castellano Vela <alvaro.castellano.vela@gmail.com>

COPY containers/td-agent-bit/conf/td-agent-bit.conf /etc/td-agent-bit/td-agent-bit.conf

STOPSIGNAL SIGTERM

CMD "/usr/bin/td-agent-bit -e /usr/lib/out_s3.so -c /etc/td-agent-bit/td-agent-bit.conf"
