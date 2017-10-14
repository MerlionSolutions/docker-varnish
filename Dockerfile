FROM debian:jessie

RUN \
  useradd -r -s /bin/false varnishd

RUN apt-get update && apt-get install -y curl git
RUN curl -s https://packagecloud.io/install/repositories/varnishcache/varnish41/script.deb.sh | bash 
RUN apt-get install -y \
  varnish-dev \
  automake \
  build-essential \
  ca-certificates \
  libmicrohttpd-dev\ 
  libedit-dev \
  libcurl4-gnutls-dev \
  libjemalloc-dev \
  libncurses-dev \
  libpcre3-dev \
  libtool \
  pkg-config \
  python-docutils \
  autotools-dev \
  python-sphinx \
  graphviz

# Install Varnish from source, so that Varnish modules can be compiled and installed.
RUN \
  mkdir -p /var/varnish && \
  mkdir -p /var/www/html
  
# vmods
RUN cd /usr/local/src && \
  git clone https://github.com/varnish/varnish-modules && \
  cd varnish-modules && \
  ./bootstrap && \
  ./configure && \
  make && make install 
  

# varnish-agent
RUN cd /usr/local/src && \
  git clone https://github.com/varnish/vagent2 && \
  cd vagent2 && \
  ./autogen.sh && \ 
  ./configure && \
  make && make install && \
  echo "root:root" > /etc/varnish/agent_secret

RUN cd /var/www/html && git clone git://github.com/brandonwamboldt/varnish-dashboard.git
RUN apt-get install -y supervisor


ARG port=80
ARG memory=100m
ARG backend_port=8080
ARG backend_host=0.0.0.0

ENV VARNISH_PORT=$port
ENV BACKEND_PORT=$backend_port
ENV BACKEND_HOST=$backend_host
ENV VARNISH_MEMORY=$memory

EXPOSE 80
EXPOSE 6083
EXPOSE 6085

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD start-varnishd.sh /usr/local/bin/start-varnishd
ADD vcl/default.source.vcl /etc/varnish/default.source.vcl
ADD vcl/devicedetect.vcl /etc/varnish/devicedetect.vcl
ADD run.sh /usr/local/bin/run_script.sh
RUN chmod +x /usr/local/bin/run_script.sh && /usr/local/bin/run_script.sh ${BACKEND_HOST} ${BACKEND_PORT}



CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

# ONBUILD COPY default.vcl /etc/varnish/default.vcl