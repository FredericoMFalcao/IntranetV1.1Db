#!/bin/bash -e

# 0. Change to the dir of the current script
cd "$( dirname "${BASH_SOURCE[0]}" )"

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
cat -n $(find sql/ -name "*.sql" | sort) > public_html/last_compiled_code.txt

# 10. Deploy the code - run it at the sql server
cat $(find sql/ -name "*.sql" | sort) | $MYSQL_CMD $defaultDb

# 11. Run the unit tests
echo > public_html/last_unit_test_results.html
for f in $(find sql/04_tests/ -name "*.php")
do
	HTML_MODE=1 php "$f" >> public_html/last_unit_test_results.html
done
