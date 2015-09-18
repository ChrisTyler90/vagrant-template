#!/usr/bin/env bash
# Apache Installation Script

echo "- Configuring Apache"
# Stop the Apache service
sudo service httpd stop > /dev/null 2>&1
# Remove the default Apache log directory
rm /etc/httpd/logs > /dev/null 2>&1
# Link the logs directory to our own
ln -fs /vagrant/log /etc/httpd/logs > /dev/null 2>&1
# Set up the VirtualHost
cat << END > /etc/httpd/conf.d/000-default.conf
<VirtualHost *:80>
    DocumentRoot "/vagrant/public"
    DirectoryIndex index.html index.php
    ErrorLog "logs/error.log"
    CustomLog "logs/access.log" combined

    <Directory "/vagrant/public">
        AllowOverride All
    </Directory>

    <IfModule mod_php5.c>
        AddType application/x-httpd-php .php
    </IfModule>

    EnableSendfile off
</VirtualHost>
END

# Restart the Apache service
echo "- Restarting Apache Service"
sudo service httpd restart > /dev/null 2>&1