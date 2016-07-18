#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

echo "- Installing Adminer"
sudo mkdir -p /usr/share/adminer
# Fetch the latest version of Adminer
sudo wget http://www.adminer.org/latest.php -O /usr/share/adminer/index.php > /dev/null 2>&1
# Set up the Adminer Virtual Host
cat << END > /etc/apache2/sites-available/adminer.conf
Alias /adminer /usr/share/adminer
<Directory "/usr/share/adminer">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>
END

sudo a2ensite adminer.conf > /dev/null 2>&1
sudo service apache2 restart > /dev/null 2>&1