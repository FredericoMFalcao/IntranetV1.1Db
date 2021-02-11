<?php require_once __DIR__."/../db_support_functions.php"; 

//
// 1. DRIVER : converts HTTP queries to SQL Stored Procedure Calls
//

// 1.1 Checks if stored procedure exists
// 1.2 Checks which arguments are required

$url = $_SERVER['REQUEST_URI'];
$url = str_replace("?".$_SERVER['QUERY_STRING'],"", $url);

$storedProcedure = explode("/",$url);
$storedProcedure = $storedProcedure[count($storedProcedure)-1];

$requiredArguments = sql("SELECT PARAMETER_NAME, DATA_TYPE FROM information_schema.Parameters WHERE SPECIFIC_SCHEMA = 'IntranetV2' AND ROUTINE_TYPE = 'PROCEDURE' AND SPECIFIC_NAME = '$storedProcedure' ORDER BY ORDINAL_POSITION ASC",$errorInfo);
if ($query === false) die("ERROR: Stored procedure not found.");


foreach($requiredArguments as $row) {
	$argName = $row['PARAMETER_NAME'];
	$argType = $row['DATA_TYPE'];

	if (!isset($_GET[$argName])) die("ERROR: Argument $argName not provided.");

	if ($argType == "int")
		$argumentValues[] = $_GET[$argName];
	else
		$argumentValues[] = "'".$_GET[$argName]."'";
}

if (sql( "CALL $storedProcedure(".implode(", ",$argumentValues).")",$errorInfo) === false)
	print_r($errorInfo);




