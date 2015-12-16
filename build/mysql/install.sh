#!/usr/bin/env bash
# MySQL Installation Script

echo "- Installing MySQL"
wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm > /dev/null 2>&1
sudo yum localinstall mysql-community-release-el6-*.noarch.rpm -y > /dev/null 2>&1
sudo yum install mysql-community-server -y > /dev/null 2>&1

echo "- Starting MySQL Service"
service mysqld start > /dev/null 2>&1