#!/usr/bin/env bash
# PHP Installation Script

echo "- Installing PHP"
# Add the webtatic repo prior to install
sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm > /dev/null 2>&1
# Install with the specified version ($1)
sudo yum install $1 -y > /dev/null 2>&1

echo "- Installing PHP Modules"
for module in ${@:2}
do
    echo "  - $module"
    sudo yum install -y $module > /dev/null 2>&1
done1