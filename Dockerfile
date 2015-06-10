FROM ubuntu:utopic
MAINTAINER cptactionhank <cptactionhank@users.noreply.github.com>


COPY ./root /

RUN RUNTMDEPS="supervisor dbus python-dbus dbus-x11 python libdbus-1-3 libdbus-glib-1-2 avahi-daemon nodejs git-core libnss-mdns libavahi-compat-libdnssd-dev" \
	&& apt-get --quiet --yes update \
	&& apt-get dist-upgrade -y \
	&& apt-get --quiet --yes install curl gnupg-curl apt-transport-https \
	&& curl -sL https://deb.nodesource.com/setup_0.12 | sudo bash - \
	&& apt-get --quiet --yes install ${RUNTMDEPS} \
	&& rm -rf "/var/lib/apt/lists/*" \
	&& apt-get --quiet --yes autoclean \
	&& apt-get --quiet --yes autoremove \
	&& apt-get --quiet --yes clean
RUN mkdir /opt/hap-nodejs
WORKDIR /opt/hap-nodejs
RUN update-alternatives --install /usr/bin/node node /usr/bin/nodejs 10
RUN git clone https://github.com/KhaosT/HAP-NodeJS.git .
RUN npm install -g node-gyp
RUN npm rebuild
RUN npm install
RUN npm install mqtt



CMD ["/usr/bin/supervisord", "--nodaemon"]
