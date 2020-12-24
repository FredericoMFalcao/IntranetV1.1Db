import json
import mysql.connector
import sys, os



#
#	0. CONNECT to database
#
isConnected = False

# 0. Get the credentials to connect to database
#    ( not default MariaDB user. Each script will have to connect with its own MariaDB user, i.e. with its own set of permissions)
# db_cred = json.loads(''.join(open('./project_root/.db_credentials.json', 'r').readlines()))

# 1. Attempt to connect
# 1.1 Create global database object 
def connectToMariaDBServer ( host, user, password, defaultDb ) :
        global cnx, isConnected, cursor
        try:
           cnx = mysql.connector.connect(
              host=host, 
              user=user, 
              password=password, 
              database=defaultDb
           )
           cursor = cnx.cursor(dictionary=True)
           # 1.2 Set the default database
           cursor.execute("USE "+defaultDb)
           isConnected = True
        except mysql.connector.Error as err:
            print(err)
            sys.exit(1)



# 
#	1. SQL - raw sql query
#
# 
# TESTED! works both for SELECT and INSERT/UPDATE/DELETE queries */
# 
# ERROR returns e.g.: 
#     (1) syntax: ["42000",1064,"You have an error in your SQL syntax; ...' at line 1"] 
#     (2) invalid table name: ["42S02",1146,"Table 'IntranetV2.Documentoz' doesn't exist"] 
#     (3) invalid column name: ["42S22",1054,"Unknown column 'Estadoz' in 'field list'"] 
#     (4) Constraint violations: ["23000",1062,"Duplicate entry 'asdsa' for key 'PRIMARY'"]
#     (5) User-defined exception condition: ["xxxx",1644,"NumSerie com formato inv\u00c3\u00a1lido"]
# 

MARIADB_ERRORINFO_CODE_FOR_SUCCESS="00000"
def sql(query, errorInfo = [], mutli = False):
   global cnx, isConnected, cursor
   if not isConnected:
      errorInfo.extend([0,0,"Not connected to any database server."])
      return False
   try:
      if mutli:
        gen = cursor.execute(query, multi=True); output = []
        for g in gen:
         output.append(g.fetchall() if g.with_rows else None)
        return output
      else:
        cursor.execute(query)
        return cursor.fetchall()
   except mysql.connector.Error as err:
      errorInfo.extend([err.errno,err.sqlstate,err.msg])
   return False
   
   
   

# cnx.close()

# vim: tabstop=3 expandtab
