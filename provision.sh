#!/usr/bin/env bash
#Creating Vagrant box for web dev

apt-get -y update

#install vim
apt-get install -y vim

#install apache2
apt-get install -y apache2

#remove default web directory with vagrant (shared) directory
rm -rf /var/www
ln -fs /vagrant/www /var/www

#install mysql
export DEBIAN_FRONTEND=noninteractive
apt-get -y install mysql-server libapache2-mod-auth-mysql php5-mysql
mysqladmin -u root create brandx_web

#restoring the required database
cd /vagrant/www/db
gzip -cd 127.0.0.1-brandx_web-04-09-14-16-40.sql.gz | mysql -uroot brandx_web

#install php5
apt-get -y install php5 libapache2-mod-php5 php5-mcrypt

#enable mod_rewrite and mod_headers
a2enmod rewrite
a2enmod headers
a2enmod proxy
a2enmod ssl

#set CWF apache configurations
cd /etc/apache2
rm /etc/apache2/httpd.conf
ln -s /vagrant/www/config/httpd.conf
service apache2 restart



#install git
# apt-get -y install git
#install nodejs, npm
#install compass
#install varnish3
#install sequelpro
#install grunt-cli
#install karma

#NEED TO VERIFY
#Create a self-signed SSL
# openssl req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -days XXX
# openssl genrsa -des3 -out server.key 1024
# openssl req -new -key server.key -out server.csr
# cp server.key server.key.original
# openssl rsa -in server.key.original -out server.key
# openssl x509 -req -days 3650 -in server.csr -signkey server.key -out server.crt
# cat server.crt server.key > server.pem


#Set up CWF development environment
#MAKEIF
mkdir /vagrant/www/CWF
cd /vagrant/www/CWF

#download CWF and bovada.lv site
wget "http://repo.rgt.internal/service/local/artifact/maven/redirect?r=releases-mit-cache&g=internal.brandx&a=brandx-site&v=1.50.2&e=tar.gz&c=drupal" -O brandx-site-drupal.tar.gz
wget "http://repo.rgt.internal/service/local/artifact/maven/redirect?r=releases-mit-cache&g=internal.brandx&a=bovada-web&v=1.51.1&e=tar.gz&c=drupal" -O bovada-web-drupal.tar.gz
tar xzvf brandx-site-drupal.tar.gz
tar xzvf bovada-web-drupal.tar.gz
cd www.brand--x.com/config
./process.py mdev
cd ../../www.bovada.lv/config
./process.py mdev

# #Overrite the environments file
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

# #Copy all code into brand--x
cd ../../www.brand--x.com/htdocs/
cp -r ../../www.bovada.lv/htdocs/sites/ .
cd sites/www.bovada.lv/
ln -s ../../../../www.bovada.lv/config/environments.php


