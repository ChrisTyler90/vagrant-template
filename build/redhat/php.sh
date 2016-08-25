#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

version_orig=$2
version_plain=${version_orig//./}
version_redhat=${version_plain}w

sudo rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-6.noarch.rpm > /dev/null 2>&1
sudo rpm -Uvh http://mirror.webtatic.com/yum/el6/latest.rpm > /dev/null 2>&1

echo "- Installing PHP $2"
sudo yum update > /dev/null 2>&1
sudo yum install php${version_redhat} -y  > /dev/null 2>&1

echo " - Installing PHP Modules"
for module in ${@:3}
do
    echo "  - $module"
    sudo yum install -y php${version_redhat}-$module > /dev/null 2>&1
done;

echo " - Configuring PHP"

echo "  - Enabling PHP Errors"
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php.ini