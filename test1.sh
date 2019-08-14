#!/bin/bash

##  

#<UDF name="ssuser" Label="New user" example="username" />

#<UDF name="sspassword" Label="New user password" example="Password" />

#<UDF name="hostname" Label="Hostname" example="examplehost" />

#<UDF name="website" Label="Website" example="example.com" />

# <UDF name="db_password" Label="MySQL root Password" />

# <UDF name="db_name" Label="Create Database" default="" example="Create database" />

# add sudo user

adduser $SSUSER --disabled-password --gecos "" && \

echo "$SSUSER:$SSPASSWORD" | chpasswd

adduser $SSUSER sudo

# updates

apt-get -o Acquire::ForceIPv4=true update -y

sudo DEBIAN_FRONTEND=noninteractive apt-get -y -o DPkg::options::="--force-confdef" -o DPkg::options::="--force-confold"  install grub-pc

apt-get -o Acquire::ForceIPv4=true update -y

#SET HOSTNAME	

hostnamectl set-hostname $HOSTNAME

echo "127.0.0.1   $HOSTNAME" >> /etc/hosts

#INSTALL APACHE

apt-get install apache2 -y

# edit apache config

sed -ie "s/KeepAlive Off/KeepAlive On/g" /etc/apache2/apache2.conf

#Create a copy of the default Apache configuration file for your site:

cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$WEBSITE.conf

# configuration of vhost file

cat <<END >/etc/apache2/sites-available/$WEBSITE.conf

<Directory /var/www/html/$WEBSITE/public_html>

    Require all granted

</Directory>

<VirtualHost *:80>

        ServerName $WEBSITE

        ServerAlias www.$WEBSITE

        ServerAdmin webmaster@localhost

        DocumentRoot /var/www/html/$WEBSITE/public_html

        ErrorLog /var/www/html/$WEBSITE/logs/error.log

        CustomLog /var/www/html/$WEBSITE/logs/access.log combined

</VirtualHost>

END

mkdir -p /var/www/html/$WEBSITE/{public_html,logs}

cd /var/www/html/$WEBSITE/public_html/

echo " <html><head><title>PHP Test</title></head><body> <?php echo '<p>Hello World</p>';// In the variables section below, replace user and password with your own MySQL credentials as created on your server $servername = "$WEBSITE"; $username = "$DB_NAME"; $password = "$DB_PASSWORD";// Create MySQL connection $conn = mysqli_connect($servername, $username, $password);// Check connection - if it fails, output will include the error message if (!$conn) { die('<p>Connection failed:<p>' . mysqli_connect_error()); } echo '<p>Connected successfully</p>'; ?></body></html> " > index.html

cd

rm /var/www/html/index.html

#Link your virtual host file from the sites-available directory to the sites-enabled directory:

sudo a2ensite $WEBSITE.conf

#Disable the default virtual host to minimize security risks:

a2dissite 000-default.conf

# restart apache

systemctl reload apache2

systemctl restart apache2

# Install MySQL Server in a Non-Interactive mode. Default root password will be "root"

echo "mysql-server mysql-server/root_password password $DB_PASSWORD" | sudo debconf-set-selections

echo "mysql-server mysql-server/root_password_again password $DB_PASSWORD" | sudo debconf-set-selections

apt-get -y install mysql-server

mysql -uroot -p$DB_PASSWORD -e "create database $DB_NAME"

service mysql restart

 

#installing php

apt-get update -y

apt-get upgrade -y

apt-get install software-properties-common -y

apt-get update -y

apt-get install php7.3 php7.3-cli php7.3-common php7.3-curl php7.3-mbstring php7.3-mysql php7.3-xml -y

# making directory for php? giving apache permissions to that log? restarting php

mkdir /var/log/php

chown www-data /var/log/php

systemctl restart apache2