#!/usr/bin/env bash
# Apache Installation Script

echo "- Stopping Apache Service"
sudo service httpd stop > /dev/null 2>&1

echo "- Configuring Apache"
# Stop the Apache service
sudo service httpd stop > /dev/null 2>&1
# Run Apache as vagrant
sudo sed -i 's/User apache/User vagrant/g' /etc/http/conf/httpd.conf > /dev/null 2>&1
sudo sed -i 's/Group apache/Group vagrant/g' /etc/http/conf/httpd.conf > /dev/null 2>&1
# Remove the default Apache log directory
rm /etc/httpd/logs > /dev/null 2>&1
# Link the logs directory to our own
ln -fs /vagrant/logs /etc/httpd/logs > /dev/null 2>&1
# Set up the VirtualHost
cat << END > /etc/httpd/conf.d/000-default.conf
<VirtualHost *:80>
    DocumentRoot "/vagrant/public_html"
    DirectoryIndex index.html index.php
    ErrorLog "logs/error.logs"
    CustomLog "logs/access.log" combined

    <Directory "/vagrant/public_html">
        AllowOverride All
    </Directory>

    <IfModule mod_php5.c>
        AddType application/x-httpd-php .php
    </IfModule>

    EnableSendfile off
</VirtualHost>
END