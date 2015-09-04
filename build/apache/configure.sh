#!/usr/bin/env bash
# Apache Installation Script

echo "- Configuring Apache"
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

    <IfModule mod_php5.c>
        AddType application/x-httpd-php .php
    </IfModule>
</VirtualHost>
END

# Restart the Apache service
echo "- Restarting Apache Service"
sudo service httpd restart > /dev/null 2>&1