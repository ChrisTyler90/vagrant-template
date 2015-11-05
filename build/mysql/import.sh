#!/usr/bin/env bash
# MySQL Configuration Script

# Import SQL files
echo "- Checking for MySQL files to import"
for sql_file in "${@: +2}"
do
    if [ -f /vagrant/build/mysql/$sql_file ]; then
        echo "- Importing data file \"$sql_file\""
        mysql -u$1 -p$2 -e "show tables" $1 | while read table;
            do mysql -u$1 -p$2 -e "truncate table $table" $1;
        done
        mysql -u$1 -p$2 $1 < /vagrant/build/mysql/$sql_file > /dev/null 2>&1
        mv /vagrant/build/mysql/$sql_file /vagrant/build/mysql/imported.$sql_file > /dev/null 2>&1
    fi
done