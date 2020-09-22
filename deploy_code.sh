#!/bin/bash -e

LC_ALL=C.UTF-8

# 0.1 Change to the dir of the current script
cd "$( dirname "${BASH_SOURCE[0]}" )"

#0.2 Redirect output to file
exec 1>public_html/last_update_error.txt
exec 2>&1
echo "["$(date)"]"

# 1. Capture DB Credentials
SERVER="$(cat .db_credentials.json | jq -r .server)"
USER="$(cat .db_credentials.json | jq -r .user)"
PASSWORD="$(cat .db_credentials.json | jq -r .password)"
defaultDb="$(cat .db_credentials.json | jq -r .defaultDb)"


MYSQL_CMD="mysql -u $USER -p$PASSWORD"

git pull
# 2. Destroy old runtime (i.e. delete the database, and all its structure and data)
$MYSQL_CMD -e "DROP DATABASE IF EXISTS $defaultDb; CREATE DATABASE $defaultDb;"

# 3. Preserver the source code (i.e. write the code about to be deployed with line number (easier for debugging))
cat -n $(find . -name "*.sql" | sort) | php > public_html/last_compiled_code.txt

# 10. Deploy the code - run it at the sql server
cat $(find . -name "*.sql" | sort) | php | $MYSQL_CMD $defaultDb

# 11. Run the unit tests
#########################
echo > public_html/last_unit_test_results.html
for f in $(find 01_sql/05_tests/ -name "*.php")
do
	HTML_MODE=1 php "$f" >> public_html/last_unit_test_results.html
done
