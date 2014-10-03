# sshd
#
# VERSION               0.0.4

FROM	ubuntu:12.04
MAINTAINER Thushara Rananwaka "thusharak@wso2.com"

#######################
# Uncomment this to hide debian related error messages > eg: debconf
#######################
ENV DEBIAN_FRONTEND noninteractive

#######################
# make sure the package repository is up to date
# --fix-missing will check and istall the missing archive as well
#######################
RUN apt-get -y update --fix-missing

#################################
# Enable ssh - This is not good. http://jpetazzo.github.io/2014/06/23/docker-ssh-considered-evil/
# For debug purposes only
##################################
RUN apt-get install -y openssh-server
RUN echo 'root:password' |chpasswd
RUN mkdir -p /var/run/sshd

#######################
# Install CouchDB
#######################
RUN echo "deb http://us.archive.ubuntu.com/ubuntu/ precise universe" >> /etc/apt/sources.list

RUN apt-get install -y apt-utils g++ 
RUN apt-get install -y erlang-dev erlang-manpages erlang-base-hipe erlang-eunit erlang-nox erlang-xmerl erlang-inets

RUN apt-get install -y libmozjs185-dev libicu-dev libcurl4-gnutls-dev libtool wget

#
# Please check the mirror is working or not. 
#
RUN cd /tmp ; wget http://mirror.nexcess.net/apache/couchdb/source/1.6.1/apache-couchdb-1.6.1.tar.gz

RUN cd /tmp && tar xvzf apache-couchdb-1.6.1.tar.gz
RUN apt-get install -y make
RUN cd /tmp/apache-couchdb-* ; ./configure && make install

RUN printf "[httpd]\nport = 5984\nbind_address = 0.0.0.0" > /usr/local/etc/couchdb/local.d/docker.ini

#######################
# Adding dependencies for couchApps
#######################
# for Kleks CMS
ADD couchapps/kleks/kleks.couch /usr/local/var/lib/couchdb/
ADD couchapps/kleks/static.couch /usr/local/var/lib/couchdb/


#######################
# Installing useful commands
#######################
RUN apt-get install -y apache2
RUN apt-get install -q -y zip unzip
RUN apt-get install -q -y telnet iputils-ping curl
RUN apt-get install -q -y curl facter nano vim


#######################
# Install Java and Stratos Cartridge Agent
# make sure you add jdk1.6.0_24.tar.gz and apache-stratos-cartridge-agent-4.0.0.tgz to respective(packs/) locations
#######################
ADD packs/jdk1.6.0_24.tar.gz /opt/
RUN ln -s /opt/jdk1.6.0_24 /opt/java
ADD packs/apache-stratos-cartridge-agent-4.0.0.tgz /mnt/


#######################
# ActiveMQ dependencies
# make sure you add following libraries to respective(packs/activemq/) locations
#######################
ADD packs/activemq/activemq-broker-5.10.0.jar /mnt/apache-stratos-cartridge-agent-4.0.0/lib/activemq-broker-5.10.0.jar
ADD packs/activemq/activemq-client-5.10.0.jar /mnt/apache-stratos-cartridge-agent-4.0.0/lib/activemq-client-5.10.0.jar
ADD packs/activemq/geronimo-j2ee-management_1.1_spec-1.0.1.jar /mnt/apache-stratos-cartridge-agent-4.0.0/lib/geronimo-j2ee-management_1.1_spec-1.0.1.jar
ADD packs/activemq/geronimo-jms_1.1_spec-1.1.1.jar /mnt/apache-stratos-cartridge-agent-4.0.0/lib/geronimo-jms_1.1_spec-1.1.1.jar
ADD packs/activemq/hawtbuf-1.10.jar /mnt/apache-stratos-cartridge-agent-4.0.0/lib/hawtbuf-1.10.jar

#######################
# setup bootup scripts
# All the scripts are located in scripts directory 
#######################
RUN mkdir /root/bin
ADD scripts/init.sh /root/bin/
RUN chmod +x /root/bin/init.sh
ADD scripts/stratos_sendinfo.rb /usr/lib/ruby/1.8/facter/
ADD scripts/metadata_svc_bugfix.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/metadata_svc_bugfix.sh
ADD scripts/run_scripts.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/run_scripts.sh

#######################
# workaround for host entries
#######################
RUN mkdir p - /root/lib
RUN cp /lib/x86_64-linux-gnu/libnss_files.so.2 /root/lib
RUN perl -pi -e 's:/etc/hosts:/tmp/hosts:g' /root/lib/libnss_files.so.2
RUN cp /etc/hosts /tmp/hosts
ENV LD_LIBRARY_PATH /root/lib
RUN locale-gen en_US.UTF-8

#######################
# Opening ports
#######################
EXPOSE 22
EXPOSE 80
EXPOSE 5984

#######################
# Run when container is up
#######################
#
# couchdb will starting after the agent creation 
#
#CMD ["/usr/local/bin/couchdb"] 

ENTRYPOINT /usr/local/bin/run_scripts.sh | /usr/sbin/sshd -D
