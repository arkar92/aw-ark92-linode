<Directory /var/www/html/laravel/public>

    Require all granted

</Directory>

<VirtualHost *:80>

        #ServerName $WEBSITE

        #ServerAlias www.$WEBSITE

        ServerAdmin webmaster@localhost

        DocumentRoot /var/www/html/laravel/public

        ErrorLog /var/www/html/$WEBSITE/logs/error.log

        CustomLog /var/www/html/$WEBSITE/logs/access.log combined

</VirtualHost>


