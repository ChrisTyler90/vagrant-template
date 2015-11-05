#!/usr/bin/env bash
# Apache Installation Script

echo "- Installing Apache"
sudo service httpd stop > /dev/null 2>&1
sudo yum install httpd -y > /dev/null 2>&1

echo "- Installing Apache Modules"
for module in $@
do
    echo "  - $module"
    sudo yum install -y $module > /dev/null 2>&1
done