#!/bin/bash -e

LC_ALL=C.UTF-8

# 0.1 Change to the dir of the current script
cd "$( dirname "${BASH_SOURCE[0]}" )"

#0.2 Redirect output to file
exec 1>public_html/last_update_error.txt
exec 2>&1
echo "["$(date)"]"

#0.3 Get a temporary filename
TMP_FILE=$(mktemp)

# 1. Capture DB Credentials
SERVER="$(cat .db_credentials.json | jq -r .server)"
USER="$(cat .db_credentials.json | jq -r .user)"
PASSWORD="$(cat .db_credentials.json | jq -r .password)"
defaultDb="$(cat .db_credentials.json | jq -r .defaultDb)"


MYSQL_CMD="mysql -u $USER -p$PASSWORD"

git pull
# 2. Destroy old runtime (i.e. delete the database, and all its structure and data)
$MYSQL_CMD -e "DROP DATABASE IF EXISTS $defaultDb; CREATE DATABASE $defaultDb;"

# 3. Write all the source code as text
echo > $TMP_FILE # Clear the contents
for f in $(find . -name "*.sql" | sort)
do
	printf '\n<?php $outerScopeCompleteFilePath = "%s"; ?>\n' "$f" >> $TMP_FILE
	cat "$f" >> $TMP_FILE
done 

# 4. Write the code about to be deployed with line number (easier for debugging)
cat -n $TMP_FILE > public_html/last_compiled_code_0.txt
cat $TMP_FILE | php | cat -n > public_html/last_compiled_code.txt

# 9. Generate SQL instructions to populate GUI javascript table
echo > 02_gui/gui_js_funcs.dml.sql 
for i in $(ls 02_gui/*.js)
do
	FUNC_NAME=${i##*/}
	cat "$i" | 02_gui/js2sql "${FUNC_NAME%.js}" >> 02_gui/gui_js_funcs.dml.sql
done

# 10. Deploy the code - run it at the sql server - after parsing through PHP template engine
cat $TMP_FILE | php  | $MYSQL_CMD $defaultDb

# 11. Run the unit tests
#########################
echo > public_html/last_unit_test_results.html
for f in $(find 01_sql/03_app/05_tests/ -name "*.php")
do
	HTML_MODE=1 php "$f" >> public_html/last_unit_test_results.html
done

rm $TMP_FILE > /dev/null 2> /dev/null
