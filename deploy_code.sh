#!/bin/bash -e

LC_ALL=C.UTF-8

# 0.1 Change to the dir of the current script
cd "$( dirname "${BASH_SOURCE[0]}" )"

# 0.2 Pulling the latest source code from Github
GIT_RESULT=$(git pull)
if [[ "$GIT_RESULT" == "Already up to date."* && "$FORCE_DEPLOY" == "" ]]
then
	echo "Not re-deploying since source code didn't change"
	exit 0
fi

#0.3 Redirect output to file
exec 1>public_html/last_update_error.txt
exec 2>&1
echo "["$(date)"]"

#0.4 Get a temporary filename
TMP_FILE=$(mktemp)

#############################
# 1. Parse the ApacheConfig file with the current parentFolder
#############################
php apache_config.conf.php > apache_config.conf

#############################
# 2. Capture DB Credentials
#############################
BRANCH_NAME=$(basename $(pwd))
if [ "$BRANCH_NAME" != "master" ]
then defaultDb="IntranetV2_$BRANCH_NAME"
else defaultDb="IntranetV2"
 fi

SERVER="$(cat .db_credentials.json | jq -r .server)"
USER="$(cat .db_credentials.json | jq -r .user)"
PASSWORD="$(cat .db_credentials.json | jq -r .password)"


MYSQL_CMD="mysql -u $USER -p$PASSWORD"


# 2. Destroy old runtime (i.e. delete the database, and all its structure and data)
$MYSQL_CMD -e "DROP DATABASE IF EXISTS $defaultDb; CREATE DATABASE $defaultDb;"

# 3. Run _prebuild scripts
for i in $(find . -name "_prebuild" -executable); do $i; done

#############################
# 3. Write all the SQL source code as text
#############################
echo > $TMP_FILE # Clear the contents
for f in $(find . -name "*.sql" | sort)
do
	printf '\n<?php $outerScopeCompleteFilePath = "%s"; ?>\n' "$f" >> $TMP_FILE
	cat "$f" >> $TMP_FILE
done 


# 4. Generate SQL instructions to populate GUI javascript table
echo > 02_frontend/gui_js_funcs.dml.sql 
for i in $(ls 02_frontend/*.js)
do
	FUNC_NAME=${i##*/}
	cat "$i" | 02_frontend/js2sql "${FUNC_NAME%.js}" >> 02_frontend/gui_js_funcs.dml.sql
done

# 9. Write out the code about to be deployed with line number (easier for debugging)
cat -n $TMP_FILE > public_html/last_compiled_code_0.txt
cat $TMP_FILE | php | cat -n > public_html/last_compiled_code.txt

# 10. Deploy the code - run it at the sql server - after parsing through PHP template engine
echo "Deployed in :"
time ( cat $TMP_FILE | php  | $MYSQL_CMD $defaultDb )

#########################
# 11. Run the unit tests
#########################
echo > public_html/last_unit_test_results.html
for f in $(find 01_backend/ -wholename "*/05_tests/*.php")
do
	HTML_MODE=1 php "$f" >> public_html/last_unit_test_results.html
done

rm $TMP_FILE > /dev/null 2> /dev/null




# Since apache can't be restarted from within an apache script
# write a "flag" file for an async script to perform an apache restart
# CANNOT SIMPLY DO THIS: apachectl restart
echo "" > ../do_restart_apache
