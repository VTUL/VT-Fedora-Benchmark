#!/bin/bash
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

sudo wget https://bootstrap.pypa.io/get-pip.py
sudo python get-pip.py
sudo apt-get install unzip -y
sudo apt-get install libpcap-dev -y
sudo pip install boto3
sudo pip install pika
sudo apt-get install python-dev -y
sudo apt-get install python-numpy python-nose -y
sudo apt-get install python-scipy -y
sudo apt-get install python-pycurl -y
sudo pip install cython
sudo apt-get install libhdf5-dev -y
sudo pip install xmltodict
sudo pip install h5py
sudo pip install supervisor
sudo apt-get install openjdk-8-jdk -y
sudo rm get-pip.py

sudo apt-get install mediainfo -y
sudo wget http://projects.iq.harvard.edu/files/fits/files/fits-0.9.0.zip?m=1449588471 -O fits-0.9.0.zip
sudo unzip fits-0.9.0.zip
sudo sed -i '/lib\/mediainfo/s/^/<!--/' fits-0.9.0/xml/fits.xml
sudo sed -i '/lib\/mediainfo/s/$/-->/' fits-0.9.0/xml/fits.xml
sudo chmod +x fits-0.9.0/fits.sh

if [ -d "vt-fedora-benchmark/experiments" ]; then
	sudo mv fits-0.9.0.zip vt-fedora-benchmark/experiments
	sudo mv fits-0.9.0 vt-fedora-benchmark/experiments
	cd vt-fedora-benchmark/experiments
fi

sudo echo export PATH="$PATH:${PWD}/fits-0.9.0/" >> ~/.bashrc
sudo source ~/.bashrc

sudo apt-get install ntp -y
sudo service ntp restart
