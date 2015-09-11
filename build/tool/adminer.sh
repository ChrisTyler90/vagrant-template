#!/usr/bin/env bash

echo "- Installing Adminer"
sudo mkdir -p /var/www/default/adminer
# Fetch the latest version of Adminer
sudo wget http://www.adminer.org/latest.php -O /var/www/default/adminer/index.php > /dev/null 2>&1
# Set up the Adminer Virtual Host
cat << END > /etc/httpd/conf.d/adminer.conf
Alias /adminer /var/www/default/adminer
<Directory "/var/www/default/adminer">
    Options Indexes FollowSymLinks MultiViews
    AllowOverride None
    Order allow,deny
    Allow from all
</Directory>
END

# Restart the Apache service
echo "- Restarting Apache Service"
sudo apachectl restart > /dev/null 2>&1