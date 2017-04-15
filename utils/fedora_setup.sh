#!/bin/bash
FEDORA_VERSION="4.2.0"

sudo add-apt-repository ppa:openjdk-r/ppa -y

sudo apt-get update && sudo apt-get install -y \
	build-essential \
	curl \
	screen \
	openssh-server \
	software-properties-common \
	vim \
	wget \
	htop tree zsh fish

sudo apt-get update -y
sudo env DEBIAN_FRONTEND=noninteractive apt-get -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" dist-upgrade

sudo apt-get install openjdk-8-jdk -y
sudo apt-get install maven -y

echo export JAVA_HOME=$(readlink -f /usr/bin/java | sed "s:bin/java::") >> ~/.bashrc
source ~/.bashrc
sudo ln -s $(readlink -f /usr/bin/java | sed "s:bin/java::" | sed "s:/jre/::") /usr/lib/jvm/default-java

sudo apt-get install tomcat7 tomcat7-admin -y

sudo mkdir fedora-data
sudo chown tomcat7:tomcat7 fedora-data
sudo sed -i '0,/JAVA_OPTS=".*"/s//JAVA_OPTS=\"-Djava.awt.headless=true -Xmx512m -XX:MaxPermSize=512m -XX:+UseConcMarkSweepGC -Dfcrepo.home=\/fedora-data\"/' /etc/default/tomcat7

sudo wget "https://github.com/fcrepo4/fcrepo4/releases/download/fcrepo-${FEDORA_VERSION}/fcrepo-webapp-${FEDORA_VERSION}.war" -O fedora.war
sudo mv fedora.war /var/lib/tomcat7/webapps

sudo service tomcat7 restart

sudo apt-get install ntp -y
sudo service ntp restart
