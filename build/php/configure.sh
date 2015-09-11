#!/usr/bin/env bash
# PHP Configuration Script

echo "- Configuring PHP"

echo "  - Enabling PHP Errors"
cat << END > /etc/php.ini
ini_set('display_errors', 1);
error_reporting(E_ALL);
END

# Restart the Apache service
echo "- Restarting Apache Service"
sudo apachectl restart > /dev/null 2>&1