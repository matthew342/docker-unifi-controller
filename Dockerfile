# build docker image to run the unifi controller
#
# the unifi contoller is used to admin ubunquty wifi access points
#
FROM ubuntu:latest
#MAINTAINER stuart nixon dotcomstu@gmail.com

ENV DEBIAN_FRONTEND noninteractive

VOLUME /usr/lib/unifi/data
VOLUME /var/log/supervisor
RUN 	mkdir -p /var/log/supervisor /usr/lib/unifi/data && \
  	touch /usr/lib/unifi/data/.unifidatadir

RUN apt-get update -q -y
RUN apt-get install -q -y supervisor apt-utils lsb-release curl wget rsync util-linux

# add ubiquity repo + key
RUN echo "deb http://www.ubnt.com/downloads/unifi/debian stable ubiquiti" > /etc/apt/sources.list.d/ubiquity.list && \
   apt-key adv --keyserver keyserver.ubuntu.com --recv C0A52C50 && \
   apt-get update -q -y && \
   apt-get install -q -y unifi

ADD ./supervisord.conf /etc/supervisor/conf.d/supervisord.conf

VOLUME /usr/lib/unifi/data
EXPOSE  8443 8080 27117
WORKDIR /usr/lib/unifi
CMD ["/usr/bin/supervisord"]
