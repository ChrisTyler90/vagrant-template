#!/usr/bin/env bash
# Apache Installation Script

echo "- Stopping Apache Service"
sudo service httpd stop > /dev/null 2>&1

echo "- Configuring Apache"
# Stop the Apache service
sudo service httpd stop > /dev/null 2>&1
# Run Apache as vagrant/log
sudo sed -i 's/User apache/User vagrant/g' /etc/http/conf/httpd.conf > /dev/null 2>&1
sudo sed -i 's/Group apache/Group vagrant/g' /etc/http/conf/httpd.conf > /dev/null 2>&1
# Remove the default Apache log directory
rm /etc/httpd/logs > /dev/null 2>&1
# Link the logs directory to our own
ln -fs /vagrant/log /etc/httpd/logs > /dev/null 2>&1
# Set up the VirtualHost
cat << END > /etc/httpd/conf.d/000-default.conf
<VirtualHost *:80>
    DocumentRoot "/vagrant/public_html"
    DirectoryIndex index.html index.php
    ErrorLog "logs/error.log"
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

# Start the Apache service on 'vagrant-mounted'
# http://stackoverflow.com/a/22763606
cat << END > /etc/init/httpd.conf
# start apache on vagrant mounted
start on vagrant-mounted
exec sudo service httpd start
END

# Start the Apache service
echo "- Starting Apache Service"
sudo service httpd start > /dev/null 2>&1