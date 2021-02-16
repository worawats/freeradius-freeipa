FROM ubuntu:20.04
MAINTAINER Worawat Songwiwat <boy@totbb.net>

ENTRYPOINT [ "/init" ]

# RADIUS Authentication Messages
EXPOSE 1812/udp

# RADIUS Accounting Messages
EXPOSE 1813/udp

# Install freeradius with ldap support
RUN apt -y update && apt -y upgrade

RUN apt -y install curl freeradius freeradius-ldap

# Install tini init
ENV TINI_VERSION v0.10.0
RUN curl -L https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini > /usr/bin/tini \
        && chmod +x /usr/bin/tini

# Copy our configuration
COPY ldap /etc/freeradius/3.0/mods-available/
COPY authorize /etc/freeradius/3.0/mods-config/files/
COPY default /etc/freeradius/3.0/sites-available/
COPY init /

RUN ln -s /etc/freeradius/3.0/mods-available/ldap /etc/freeradius/3.0/mods-enabled/ldap
RUN chown freerad:freerad /etc/freeradius/3.0/mods-config/files/authorize
