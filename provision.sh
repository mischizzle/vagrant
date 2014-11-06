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

#Set up CWF development environment
mkdir /sites/
cd /sites

wget "http://repo.rgt.internal/service/local/artifact/maven/redirect?r=releases-mit-cache&g=internal.brandx&a=brandx-site&v=1.50.2&e=tar.gz&c=drupal" -O brandx-site-drupal.tar.gz
wget "http://repo.rgt.internal/service/local/artifact/maven/redirect?r=releases-mit-cache&g=internal.brandx&a=bovada-web&v=1.51.1&e=tar.gz&c=drupal" -O bovada-web-drupal.tar.gz
tar xzvf brandx-site-drupal.tar.gz
tar xzvf bovada-web-drupal.tar.gz
cd www.brand--x.com/config
./process.py mdev
cd ../../www.bovada.lv/config
./process.py mdev

rm environments.php
cat << EOF | sudo tee -a environments.php
<?php
$databases = array (
  'default' =>
  array (
    'default' =>
    array (
      'unix_socket' => '/tmp/mysql.sock',
      'database' => 'brandx_web',
      'username' => 'root',
      'password' => '',
      'host' => '127.0.0.1',
      'port' => '',
      'driver' => 'mysql',
      'prefix' => 'brandx_com_',
    ),
  ),
);
ini_set('cookie_domain', 'bovada.lv');
$cookie_domain = 'bovada.lv';
ini_set ('memory_limit', '256M');
EOF

cd ../../www.brand--x.com/htdocs/
cp -r ../../www.bovada.lv/htdocs/sites/ .
cd sites/www.bovada.lv/
ln -s ../../../../www.bovada.lv/config/environments.php


