#!/usr/bin/python3
import cgi, cgitb, json,sys
import os
cgitb.enable()    
from project_root import db_support_functions as db
print("Content-Type: application/json;charset=utf-8")
print("")

# requested_url e.g. /rest/ACC_Contas/0101
requested_url = os.environ["SCRIPT_URL"]


#####################
# 0. Capture HTTP requested:
#####################
# 1. Method (GET, POST, PUT, DELETE)
# 2. TableName 
# 3. (optional) Primary Key
table_name = requested_url.split("/")[2] if requested_url.count("/") > 1 else ""
primary_key = requested_url.split("/")[3] if requested_url.count("/") > 2 else ""
requested_method = os.environ["REQUEST_METHOD"]

def parseQueryResult(sqlResultSet):
	output = []
	for sqlRow in sqlResultSet :
		row = {}
		for colName in sqlRow :
			row[colName] = sqlRow[colName].decode() if isinstance(sqlRow[colName], bytes) else sqlRow[colName]
		output.append(row)
	return output

#####################
# 1. Connect to Database Server
#####################
db_cred = json.loads(''.join(open('./project_root/.db_credentials_restServer.json', 'r').readlines()))
if ( not "server" in db_cred 
or not "user" in db_cred 
or not "password" in db_cred 
or not "defaultDb" in db_cred ):
	print("Wrong .db_credentials_rawSql.json format. Missing server or user or password or defaultDb.")
	sys.exit(1)
else :
	db.connectToMariaDBServer(db_cred['server'], db_cred['user'], db_cred['password'], db_cred['defaultDb'])


# Generate the initial SQL Query
sql_query = f"SELECT * FROM {table_name}"
if primary_key :
	sql_query += f" WHERE Conta = {primary_key}"


## Run SQL query or report error
errorInfo = []; sqlResult = db.sql(sql_query,errorInfo)

sqlResult = parseQueryResult(sqlResult) if sqlResult != False else errorInfo

# Print output
print(json.dumps({"data":sqlResult, "schema":{"Conta":"text", "Nome":"text", "Extra":"json"}}))


