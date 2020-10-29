#!/usr/bin/python
from project_root import db_support_functions as db
import cgi
import cgitb
import json
cgitb.enable()    
print("Content-Type: text/html;charset=utf-8")
print("")

get_arguments = cgi.FieldStorage()
if "q" in get_arguments :
	print json.dumps(db.sql(get_arguments["q"].value))
else :
	print "ERROR: No query provided."
