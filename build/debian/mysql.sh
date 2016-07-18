#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

echo "- Installing MySQL $2"
echo "mysql-server mysql-server/root_password password $4" | sudo debconf-set-selections
echo "mysql-server mysql-server/root_password_again password $4" | sudo debconf-set-selections
sudo apt-get install mysql-server-$2 -y > /dev/null 2>&1

echo "- Starting MySQL Service"
sudo /etc/init.d/mysql start > /dev/null 2>&1

echo "- Configuring MySQL"
sudo service mysql restart > /dev/null 2>&1
echo "  - Creating database"
mysql -u$3 -p$4 -e "CREATE DATABASE IF NOT EXISTS $5" > /dev/null 2>&1
echo "  - Creating database user"
mysql -u$3 -p$4 -e "GRANT ALL ON $5.* TO '$3'@'localhost' IDENTIFIED BY '$4'" > /dev/null 2>&1
mysql -u$3 -p$4 -e "FLUSH PRIVILEGES" > /dev/null 2>&1

echo "- Restarting MySQL Service"
sudo service mysql restart > /dev/null 2>&1

echo "- Checking for MySQL files to import"
for sql_file in ${@:6}
do
    if [ -f /vagrant/build/mysql/$sql_file ]; then
        echo "- Importing data file \"$sql_file\""
        mysql -u$3 -p$4 $5 < /vagrant/build/mysql/$sql_file > /dev/null 2>&1
        mv /vagrant/build/mysql/$sql_file /vagrant/build/mysql/imported.$sql_file > /dev/null 2>&1
    fi
done