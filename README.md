# Vagrant Template
Starting template for LAMP vagrant box

# Supported Software
* [CentOS](https://www.centos.org/) & [Ubuntu](https://www.ubuntu.com/)
* [Apache](https://httpd.apache.org/) (Latest version)
* [PHP](https://www.php.net/)
* [MySQL](https://www.mysql.com/) (Latest version)
* [Adminer](https://www.adminer.org/)
* [FTP](https://security.appspot.com/vsftpd.html)
* [Nano](http://www.nano-editor.org/)

# Configuration
Configuration settings are found in the config_example.yaml file in the root of the repo.
I recommend creating a copy of this file, and renaming it to `config.yaml`

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

## MySQL
You may supply MySQL dump files to be imported on load of the vagrant box.
To add a file, add an entry to the `sql_file` section.
e.g.
>
    mysql:
        ...
        import:
            - schema.sql
            - data.sql
