#!/usr/bin/env bash

#Creating Vagrant box for web dev

apt-get -y update

#install curl
#apt-get -y install curl

#install homebrew
#ruby -e "$(wget -O- https://raw.github.com/Homebrew/linuxbrew/go/install)"
#ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"

#install vim
apt-get install -y vim


#install apache2 (service apache status) and remove default web directory with vagrant (shared) directory
apt-get install -y apache2

rm -rf /var/www
ln -fs /vagrant /var/www


#install mysql
#apt-get install mysql-server libapache2-mod-auth-mysql php5-mysql
#apt-get install -y php5-mysql mysql-server



#install git

#install nodejs, npm

#install compass

#install varnish3

#install sequelpro

#install grunt-cli

#install karma

#service mysql start
