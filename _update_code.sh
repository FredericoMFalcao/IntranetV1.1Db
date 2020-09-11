#!/bin/bash
MYSQL_CMD="mysql -u $user -p$password"

git pull
$MYSQL_CMD -e "DROP DATABASE IF EXISTS $defaultDb; CREATE DATABASE $defaultDb;"
# Write the code about to be deployed with line number (easier for debugging)
cat -n $(find sql/ -name "*.sql" | sort) > public_html/last_compiled_code.txt
# Deploy the code
cat $(find sql/ -name "*.sql" | sort) | $MYSQL_CMD $defaultDb
