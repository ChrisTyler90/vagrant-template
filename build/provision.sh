#!/usr/bin/env bash
# Provisioning script

echo "--------------------------------"

echo "Starting provision script"

if [ -f /etc/vagrant_provisioned_at ]; then
    LAST_PROVISIONED_AT=$(cat /etc/vagrant_provisioned_at)
else
    LAST_PROVISIONED_AT=0
fi
date +"%Y-%m-%d %k:%M:%S"  > /etc/vagrant_provisioned_at

PROJECT_NAME=project
PROJECT_URL=project.dev
MYSQL_USER=root
MYSQL_PASS=root

echo "--------------------------------"

echo "Apache"
echo "- Installing"
sudo service httpd stop > /dev/null 2>&1
sudo yum install httpd mod_ssl openssl -y > /dev/null 2>&1
echo "- Configuring defaults"
sudo rm -f /etc/httpd/conf/httpd.conf
sudo rm -rf /etc/httpd/conf.d/
sudo cp -rf /vagrant/build/apache/conf/ /etc/httpd/
sudo cp -rf /vagrant/build/apache/conf.d/ /etc/httpd/
echo "- Configuring project VHost"
cat << END > /etc/httpd/conf.d/$PROJECT_NAME.conf
<VirtualHost *:80>
    ServerName $PROJECT_URL
    ServerAlias www.$PROJECT_URL
    DocumentRoot "/vagrant/public"
    SetEnv APP_ENV dev
    <Directory "/vagrant/public">
        Options Indexes FollowSymlinks MultiViews
        AllowOverride All
        Order allow,deny
        Allow from all
    </Directory>
    ErrorLog "/vagrant/log/${PROJECT_NAME}_error.log"
    CustomLog "/vagrant/log/${PROJECT_NAME}_access.log" combined
</VirtualHost>
END
echo "- Starting service"
sudo service httpd start > /dev/null 2>&1

echo "--------------------------------"

echo "PHP"
sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm > /dev/null 2>&1
echo "- Installing"
sudo yum install php55w  -y > /dev/null 2>&1
echo "- Installing modules"
sudo yum install php55w-mysql php55w-xmlrpc php55w-gd php55w-mbstring php55w-mcrypt php55w-pdo php55w-xml -y > /dev/null 2>&1
sudo service httpd restart > /dev/null 2>&1
echo "- Restarting Apache"

echo "--------------------------------"

echo "MySQL"
echo "- Installing"
sudo yum install mysql-server -y > /dev/null 2>&1
echo "- Starting service"
sudo service mysqld start > /dev/null 2>&1
echo "- Changing root password"
mysqladmin -u$MYSQL_USER password $MYSQL_PASS > /dev/null 2>&1
echo "- Creating project database"
mysql -u$MYSQL_USER -p$MYSQL_PASS -e "CREATE DATABASE IF NOT EXISTS $PROJECT_NAME"
echo "- Creating project user"
mysql -u$MYSQL_USER -p$MYSQL_PASS -e "GRANT ALL ON $PROJECT_NAME.* TO '$PROJECT_NAME'@'localhost' IDENTIFIED BY '$PROJECT_NAME'"
mysql -u$MYSQL_USER -p$MYSQL_PASS -e "FLUSH PRIVILEGES"
if [ -f /vagrant/build/mysql/schema.sql ]; then
    echo "- Importing schema file"
    mysql -u$MYSQL_USER -p$MYSQL_PASS $PROJECT_NAME < /vagrant/build/mysql/schema.sql > /dev/null 2>&1
fi
if [ -f /vagrant/build/mysql/data.sql ]; then
    if test `find "/vagrant/build/mysql/data.sql" -newermt "$LAST_PROVISIONED_AT"`; then
        echo "- Importing data file"
        mysql -u$MYSQL_USER -p$MYSQL_PASS -e "show tables" $PROJECT_NAME | while read table;
            do mysql -u$MYSQL_USER -p$MYSQL_PASS -e "truncate table $table" $PROJECT_NAME;
        done
        mysql -u$MYSQL_USER -p$MYSQL_PASS $PROJECT_NAME < /vagrant/build/mysql/data.sql > /dev/null 2>&1
    fi
fi

echo "--------------------------------"

echo "Dev Tools"
echo "- Installing Nano"
sudo yum install nano -y > /dev/null 2>&1
echo "- Installing Adminer"
sudo mkdir -p /var/www/default/adminer
sudo wget http://www.adminer.org/latest.php -O /var/www/default/adminer/index.php > /dev/null 2>&1
cat << END > /etc/httpd/conf.d/adminer.conf
<VirtualHost *:80>
    ServerName adminer
    Alias /adminer /var/www/default/adminer
    <Directory "/var/www/default/adminer">
        Options Indexes FollowSymLinks MultiViews
        AllowOverride None
        Order allow,deny
        Allow from all
    </Directory>
    ErrorLog "/vagrant/log/adminer_error.log"
    CustomLog "/vagrant/log/adminer_access.log" combined
</VirtualHost>
END
echo "Restarting Apache"
sudo service httpd restart > /dev/null 2>&1

echo "--------------------------------"

echo "All done! Project URL: $PROJECT_URL"