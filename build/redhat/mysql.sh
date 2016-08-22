#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

# TODO: Allow specific version to be installed
# version_orig=$2
# version_plain=${version_orig//./}

echo "- Installing MySQL $2"
wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm > /dev/null 2>&1
sudo yum localinstall mysql-community-release-el6-*.noarch.rpm -y > /dev/null 2>&1
sudo yum install mysql-community-server -y > /dev/null 2>&1

echo "- Starting MySQL Service"
sudo service mysqld start > /dev/null 2>&1

echo "- Configuring MySQL"
echo "  - Changing root user password"
mysqladmin -u$3 password $4 > /dev/null 2>&1
echo "  - Creating database"
mysql -u$3 -p$4 -e "CREATE DATABASE IF NOT EXISTS $5" > /dev/null 2>&1
echo "  - Creating database user"
mysql -u$3 -p$4 -e "GRANT ALL ON $5.* TO '$3'@'localhost' IDENTIFIED BY '$4'" > /dev/null 2>&1
mysql -u$3 -p$4 -e "FLUSH PRIVILEGES" > /dev/null 2>&1

echo "- Checking for MySQL files to import"
for sql_file in ${@:6}
do
    if [ -f /vagrant/build/mysql/$sql_file ]; then
        echo "- Importing data file \"$sql_file\""
        mysql -u$3 -p$4 $5 < /vagrant/build/mysql/$sql_file > /dev/null 2>&1
        mv /vagrant/build/mysql/$sql_file /vagrant/build/mysql/imported.$sql_file > /dev/null 2>&1
    fi
done