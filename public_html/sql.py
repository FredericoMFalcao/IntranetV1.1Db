#!/usr/bin/python3
from project_root import db_support_functions as db
import cgi, cgitb, json,sys, os
cgitb.enable()    
print("Content-Type: text/html;charset=utf-8")
print("")


			

# 1. Connect to Database Server
#####################
db_cred = json.loads(''.join(open('./project_root/.db_credentials_rawSql.json', 'r').readlines()))
branch_name = os.path.dirname(os.path.abspath(__file__)).split("/")[-2]
db_cred["defaultDb"] = "IntranetV2" + ("_"+branch_name if branch_name != "master" else "")
if not "server" in db_cred or not "user" in db_cred or not "password" in db_cred or not "defaultDb" in db_cred :
	print("Wrong .db_credentials_rawSql.json format. Missing server or user or password or defaultDb.")
	sys.exit(1)
else:
	db.connectToMariaDBServer(db_cred['server'], db_cred['user'], db_cred['password'], db_cred['defaultDb'])

# 2. Run the Query
#####################
get_arguments = cgi.FieldStorage()
if "q" in get_arguments :
	errorInfo = []
	queryResult = db.sql(get_arguments["q"].value, errorInfo)
	print(json.dumps(queryResult if queryResult != False else errorInfo))
else :
	print("ERROR: No query provided.");
