#!/usr/bin/python
from project_root import db_support_functions as db
import cgitb
import json
cgitb.enable()    
print("Content-Type: text/html;charset=utf-8")
print("")

print(json.dumps(db.sql("SELECT * FROM DocEstados")))
