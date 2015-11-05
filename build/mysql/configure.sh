#!/usr/bin/env bash
# MySQL Configuration Script

echo "- Configuring MySQL"
echo "  - Starting MySQL Service"
service mysqld start > /dev/null 2>&1
echo "  - Changing root user password"
mysqladmin -u$1 password $2 > /dev/null 2>&1
echo "  - Creating database"
mysql -u$1 -p$2 -e "CREATE DATABASE IF NOT EXISTS $1" > /dev/null 2>&1
echo "  - Creating database user"
mysql -u$1 -p$2 -e "GRANT ALL ON $1.* TO '$1'@'localhost' IDENTIFIED BY '$1'" > /dev/null 2>&1
mysql -u$1 -p$2 -e "FLUSH PRIVILEGES" > /dev/null 2>&1