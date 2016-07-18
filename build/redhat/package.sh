#!/usr/bin/env bash

echo "- Installing Packages"
for module in $@
do
    echo "  - $module"
    sudo yum install -y $module > /dev/null 2>&1
done