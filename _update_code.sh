#!/bin/bash
MYSQL_CMD="mysql -u $user -p$password"

git pull
$MYSQL_CMD -e "DROP DATABASE IF EXISTS $defaultDb; CREATE DATABASE $defaultDb;"
cat $(find . -name "*.sql") | $MYSQL_CMD $defaultDb
