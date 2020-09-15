<?php

/*
*	0. CONNECT to database
*
*/


/* 0. Get the credentials to connect to database */
extract(json_decode(file_get_contents(__DIR__."/.db_credentials.json"),1));
$dsn = "mysql:host=$server;dbname=$defaultDb;";

/* 1. Attempt to connect */
/* 1.1 Create global database object (dbo) */
try {$dbo = new PDO($dsn, $user, $password);} 
catch (PDOException $e) {die('Database Connection failed: ' . $e->getMessage());}    

// Set the default database
$dbo->prepare("USE $defaultDb;")->execute();

/*
*	1. SQL - raw sql query
*
*/
/* TESTED! works both for SELECT and INSERT/UPDATE/DELETE queries */
/*
* ERROR returns e.g.: 
*     (1) syntax: ["42000",1064,"You have an error in your SQL syntax; ...' at line 1"] 
*     (2) invalid table name: ["42S02",1146,"Table 'IntranetV2.Documentoz' doesn't exist"] 
*     (3) invalid column name: ["42S22",1054,"Unknown column 'Estadoz' in 'field list'"] 
*     (4) Constraint violations: ["23000",1062,"Duplicate entry 'asdsa' for key 'PRIMARY'"]
*     (5) User-defined exception condition: ["xxxx",1644,"NumSerie com formato inv\u00c3\u00a1lido"]
*/
define('MARIADB_ERRORINFO_CODE_FOR_SUCCESS',"00000");
function sql(string $sql, string &$errorInfo = null) {
	global $dbo;
	$query = $dbo->prepare($sql);
	$query->execute();
	$errorInfo = $query->errorInfo();
	if ($errorInfo[0] != MARIADB_ERRORINFO_CODE_FOR_SUCCESS)
		return false;
	else
		return $query->fetchAll(PDO::FETCH_ASSOC);
}
