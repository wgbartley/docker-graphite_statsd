FROM ubuntu:latest

RUN apt-get -y update
RUN apt-get -y install nginx python-dev python-flup python-pip expect git memcached sqlite3 libcairo2 libcairo2-dev python-cairo pkg-config nodejs supervisor

# python dependencies
RUN pip install django==1.3 python-memcached==1.53 django-tagging==0.3.1 whisper==0.9.12 twisted==11.1.0 txAMQP==0.6.2

# Make /storage before we really get into the scripting
RUN mkdir -p /storage/graphite
VOLUME ["/storage"]

# install graphite
RUN git clone -b 0.9.12 https://github.com/graphite-project/graphite-web.git /usr/local/src/graphite-web
WORKDIR /usr/local/src/graphite-web
RUN python ./setup.py install
ADD scripts/local_settings.py /opt/graphite/webapp/graphite/local_settings.py
COPY conf/graphite/ /opt/graphite/conf/

# install whisper
RUN git clone -b 0.9.12 https://github.com/graphite-project/whisper.git /usr/local/src/whisper
WORKDIR /usr/local/src/whisper
RUN python ./setup.py install

# install carbon
RUN git clone -b 0.9.12 https://github.com/graphite-project/carbon.git /usr/local/src/carbon
WORKDIR /usr/local/src/carbon
RUN python ./setup.py install

# install statsd
RUN git clone -b v0.7.2 https://github.com/etsy/statsd.git /opt/statsd
ADD conf/statsd/config.js /opt/statsd/config.js

# config nginx
RUN rm /etc/nginx/sites-enabled/default
ADD conf/nginx/nginx.conf /etc/nginx/nginx.conf
ADD conf/nginx/graphite.conf /etc/nginx/sites-available/graphite.conf
RUN ln -s /etc/nginx/sites-available/graphite.conf /etc/nginx/sites-enabled/graphite.conf

# init django admin
ADD scripts/django_admin_init.exp /usr/local/bin/django_admin_init.exp
RUN /usr/local/bin/django_admin_init.exp

# logging support
RUN mkdir -p /var/log/carbon /var/log/graphite /var/log/nginx
ADD conf/logrotate /etc/logrotate.d/graphite

# supervisor logging
RUN mkdir -p /var/log/supervisor

# daemons
ADD scripts/carbon.conf /etc/supervisor/conf.d/carbon.conf
ADD scripts/graphite.conf /etc/supervisor/conf.d/graphite.conf
ADD scripts/statsd.conf /etc/supervisor/conf.d/statsd.conf
ADD scripts/nginx.conf /etc/supervisor/conf.d/nginx.conf
ADD scripts/start.sh /start.sh

RUN chmod +x /start.sh

# cleanup
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# defaults
EXPOSE 80 2003 8125/udp

WORKDIR /
ENV HOME /root

CMD ["/start.sh"]
