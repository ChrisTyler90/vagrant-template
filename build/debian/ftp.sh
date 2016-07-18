#!/usr/bin/env bash

if [ $1 -ne "1" ]; then
    exit
fi

echo "- Installing FTP Server + Client"
sudo apt-get install vsftpd -y > /dev/null 2>&1
sudo apt-get install ftp -y > /dev/null 2>&1
echo "- Configuring FTP Server"
sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
echo "  - Restarting FTP service"
sudo service vsftpd restart > /dev/null 2>&1