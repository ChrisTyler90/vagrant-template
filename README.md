# Vagrant Template
Starting template for LAMP vagrant box

# Software
* [CentOS](https://www.centos.org/) (6.7)
* [Apache](https://httpd.apache.org/) (Latest)
    - mod_ssl
    - openssl
* [PHP](https://www.php.net/) (Latest)
    - php55w-common
    - php55w-mysql
    - php55w-xmlrpc
    - php55w-gd
    - php55w-mbstring
    - php55w-mcrypt
    - php55w-pdo
    - php55w-xml
    - php55w-pecl-xdebug
* [MySQL](https://www.mysql.com/) (Latest)
* [Nano](http://www.nano-editor.org/)
* [Adminer](https://www.adminer.org/)
* [FTP](https://security.appspot.com/vsftpd.html)

# Configuration
Configuration settings are found in the config.yaml file in the root of the repo.

## Access
By default, the hostname is set to `test.dev`.
To change this, amend the `hostname` entry in the config.

The public-facing IP address is set to `192.168.33.10`
To change this, amend the `private_network` entry in the config.

Apache is bound to port `80` by default, and reached from port `80` in your VM software
To change the access port, amend the `forwarded_port` values in the config.

MySQL is installed with the user `root`, password `root` and creates the database `root` by default.
These can be changed in the config, under the `mysql` entry.

## Apache Modules/PHP Modules/Tools
Modules and tools are installed on provision.
To add a new module, simply add it to the corresponding `modules` entry in the config.
*Module name must match that in the OS software repo*

# MySQL
You may supply MySQL dump files to be imported on load of the vagrant box.
To add a file, add an entry to the `sql_file` section.
e.g.
>
    mysql:
        ...
        sql_file:
            - schema.sql
            - data.sql
