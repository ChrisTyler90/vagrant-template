#!/usr/bin/env bash

echo "- Installing FTP Server + Client"
# VSFTP - Server
sudo yum install vsftpd -y > /dev/null 2>&1
# FTP - Client
sudo yum install ftp -y > /dev/null 2>&1
# Update vsftpd config
echo "- Configuring FTP Server"
sudo sed -i 's/anonymous_enable=YES/anonymous_enable=NO/g' /etc/vsftpd/vsftpd.conf
echo "  - Restarting FTP service"
sudo service vsftpd restart > /dev/null 2>&1