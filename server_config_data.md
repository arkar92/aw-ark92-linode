#Test_LAMP_Server6 Installation Step by Step

#1
sudo apt update && sudo apt upgrade

#2
sudo apt install tasksel
sudo tasksel install lamp-server

ပြီးရင် web server ip ကို ခေါ်ပြီး စစ်ကြည့် 

စစ် လို့ အဆင်ပြေရင် နောက်တစ်ဆင့် က php install လုပ်ရန် 

sudo apt update
sudo apt upgrade

sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

sudo apt install php7.3

php -v

sudo apt install php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip php7.3-intl -y

php -v

php 7.3 တင် ပြီးပြီ ဆိုရင် laravel install လုပ်ရန်

sudo apt install curl git unzip

ပြီးရင် composer install လုပ်ရန် 

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer

ပြီးရင် cd /var/www/html ထဲ သွားပြီး laravel ကို composer ကနေ တဆင့် install လုပ်ရန်

sudo composer create-project laravel/laravel laravel --prefer-dist

ပြီးရင် apache server ကို laravel အတွက် config လုပ်ရန်

sudo chgrp -R www-data /var/www/html/laravel
sudo chmod -R 775 /var/www/html/laravel/storage

ပြီးရင် mysql server ကို laravel နဲ့ ချိတ်လို့ ရအောင် config လုပ်ရန် / database create လုပ်ရန် 

ပြီးရင် .env file ကို example file နဲ့ copy ကူပြီး database info ထည့်ရန် ပြီးရင် key generate လုပ်ရန်

ပြီးရင် web server ip ကို ခေါ်တာနဲ့ laravel site ပေါ်လာရန် virtual host ကို config လုပ်ပေးရန် 



#3
nano /etc/apache2/apache2.conf

KeepAlive On
MaxKeepAliveRequests 50
KeepAliveTimeout 5

nano /etc/apache2/mods-available/mpm_prefork.conf

<IfModule mpm_prefork_module>
        StartServers            4
        MinSpareServers         3
        MaxSpareServers         40
        MaxRequestWorkers       200
        MaxConnectionsPerChild  10000
</IfModule>

sudo a2dismod mpm_event
sudo a2enmod mpm_prefork

sudo systemctl restart apache2


sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/laravel.conf


<Directory /var/www/html/laravel/public>

    Require all granted

</Directory>

<VirtualHost *:80>

        #ServerName $WEBSITE

        #ServerAlias www.$WEBSITE

        ServerAdmin webmaster@localhost

        DocumentRoot /var/www/html/laravel/public
        
        ErrorLog ${APACHE_LOG_DIR}/error.log
        
        CustomLog ${APACHE_LOG_DIR}/access.log combined

</VirtualHost>

sudo a2ensite laravel.conf

sudo a2dissite 000-default.conf

# restart apache

systemctl reload apache2

systemctl restart apache2


#4
sudo mysql -u root

SELECT user,authentication_string,plugin,host FROM mysql.user;

FLUSH PRIVILEGES;

ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY '@wt3chC30';

EXIT;

sudo mysql -u root -p

CREATE DATABASE laravel;

GRANT ALL ON laravel.* to 'root'@'localhost' IDENTIFIED BY '@wt3chC30';

FLUSH PRIVILEGES;

quit


#5

sudo apt update
sudo apt upgrade

sudo apt install software-properties-common
sudo add-apt-repository ppa:ondrej/php
sudo apt update

sudo apt install php7.3

sudo apt install php7.3-common php7.3-mysql php7.3-xml php7.3-xmlrpc php7.3-curl php7.3-gd php7.3-imagick php7.3-cli php7.3-dev php7.3-imap php7.3-mbstring php7.3-opcache php7.3-soap php7.3-zip php7.3-intl -y

php -v

#6

curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
sudo chmod +x /usr/local/bin/composer


cd /var/www/html/

sudo composer create-project laravel/laravel your-project --prefer-dist

