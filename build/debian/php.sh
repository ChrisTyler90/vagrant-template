#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

sudo add-apt-repository -y ppa:ondrej/php > /dev/null 2>&1

echo "- Installing PHP $2"
sudo apt-get update > /dev/null 2>&1
sudo apt-get install php$2 -y > /dev/null 2>&1

echo " - Installing PHP Modules"
for module in ${@:3}
do
    echo "  - $module"
    sudo apt-get install -y php$2-$module > /dev/null 2>&1
    sudo php5enmod $module > /dev/null 2>&1
done;

echo " - Configuring PHP"

echo "  - Enabling PHP Errors"
sudo sed -i 's/display_errors = Off/display_errors = On/' /etc/php/$2/apache2/php.ini