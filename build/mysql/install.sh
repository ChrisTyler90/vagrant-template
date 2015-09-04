#!/usr/bin/env bash
# MySQL Installation Script

echo "- Installing MySQL"
wget http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm -y
sudo yum localinstall mysql-community-release-el6-*.noarch.rpm -y
sudo yum install mysql-community-server -y