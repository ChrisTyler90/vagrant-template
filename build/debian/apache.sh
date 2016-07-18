#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

echo "- Installing Apache"
sudo service apache2 stop > /dev/null 2>&1
sudo apt-get install apache2 -y > /dev/null 2>&1

echo "- Installing Apache Modules"
for module in ${@:5}
do
    echo "  - $module"
    sudo apt-get install -y $module > /dev/null 2>&1
    sudo a2enmod $module > /dev/null 2>&1
done

echo "- Stopping Apache Service"
sudo service apache2 stop > /dev/null 2>&1

echo "- Configuring Apache"
sudo sed -i "s/User \${APACHE_RUN_USER}/User $2/g" /etc/apache2/apache2.conf > /dev/null 2>&1
sudo sed -i "s/Group \${APACHE_RUN_GROUP}/Group $2/g" /etc/apache2/apache2.conf > /dev/null 2>&1
cat << END > /etc/apache2/sites-available/000-default.conf
<VirtualHost *:80>
    DocumentRoot $3
    DirectoryIndex index.html index.php
    ErrorLog $4/error.log
    CustomLog $4/access.log combined

    <Directory "$3">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
        Require all granted
    </Directory>

    <IfModule mod_php5.c>
        AddType application/x-httpd-php .php
    </IfModule>

    EnableSendfile off
</VirtualHost>
END
sudo a2ensite 000-default.conf > /dev/null 2>&1

cat << END > /etc/apache2/sites-available/000-ssl.conf
<IfModule mod_ssl.c>
	<VirtualHost *:443>
		DocumentRoot $3
		DirectoryIndex index.html index.php
		ErrorLog $4/ssl-error.log
		CustomLog $4/ssl-access.log combined

		SSLEngine on

		SSLCertificateFile	/etc/ssl/certs/ssl-cert-snakeoil.pem
		SSLCertificateKeyFile /etc/ssl/private/ssl-cert-snakeoil.key

		<FilesMatch "\.(cgi|shtml|phtml|php)$">
            SSLOptions +StdEnvVars
		</FilesMatch>

		<Directory /usr/lib/cgi-bin>
            SSLOptions +StdEnvVars
		</Directory>

		<Directory "$3">
            Options Indexes FollowSymLinks MultiViews
            AllowOverride All
            Order allow,deny
            Allow from all
            Require all granted
        </Directory>

        <IfModule mod_php5.c>
            AddType application/x-httpd-php .php
        </IfModule>

		BrowserMatch "MSIE [2-6]" \
				nokeepalive ssl-unclean-shutdown \
				downgrade-1.0 force-response-1.0
		BrowserMatch "MSIE [17-9]" ssl-unclean-shutdown
	</VirtualHost>
</IfModule>
END
sudo a2ensite 000-ssl.conf > /dev/null 2>&1

echo "- Starting Apache Service"
sudo service apache2 restart > /dev/null 2>&1