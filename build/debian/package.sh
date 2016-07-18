#!/usr/bin/env bash

echo "- Installing Packages"
for module in $@
do
    echo "  - $module"
    sudo apt-get install -y $module > /dev/null 2>&1
done