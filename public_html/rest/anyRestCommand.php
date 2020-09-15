<?php
/* REQUIRE DB CONNECTION */
require_once __DIR__."/../../db_support_functions.php";


/* PARSE URL */
$url_parts = explode("/",$_SERVER["REQUEST_URI"]);
array_shift($url_parts); // Eliminate the first "root" slash
array_shift($url_parts); // Eliminate the "/rest/" mention


/* DEFAULTS */
$ouptut_mode = "print_r";
$primaryKeyValueSeparator = "--";

/* OVERRIDE DEFAULTS provided by client in URL */
foreach($_GET as $k => $v) $$k = $v;

if(0) {
} elseif ($_SERVER['REQUEST_METHOD'] == "GET") {
	/* 0. Load all tables/rest-endpoints available, and their respective primary keys */
	$vTables = sql("SELECT Name, PrimaryKey FROM PLT_VirtualTables");
	$vTablesNames = array_map(function($o) {return $o['Name'];},$vTables);
	$vTablesPKs = []; foreach($vTables as $vTable) $vTablesPKs[$vTable["Name"]] = json_decode($vTable["PrimaryKey"],1);
	
	/* 1. Check if whole table contents, or specific record, was requested */
	if (count($url_parts) <= 2) {
		if (count($url_parts) == 1) $mode = "fetch_whole_table";
		if (count($url_parts) == 2) $mode = "fetch_specific_record";

		/* Check if requested table is part of the available tables array */
		if (!in_array($url_parts[0], $vTablesNames)) 
			output_error("Table {$url_parts[0]} is not accessible or does not exist");
	
		/* Fetch the data */
		$errorInfo = 0;
		$sql_query = "SELECT * FROM {$url_parts[0]}";
		
		/* If specific record was requested, filter it */
		if ($mode == "fetch_specific_record") {
			$sql_query .= " WHERE 1"; 
			foreach($vTablesPKs[$url_parts[0]] as $i => $pk_name)
				$sql_query .= " AND `{$pk_name}` = '".explodeAtIdxOrEmpty($primaryKeyValueSeparator, $url_parts[1],$i)."'";
		}

		if(($db_result = sql($sql_query,$errorInfo)) !== false) 
			output(($mode=="fetch_whole_table"?$db_result:(count($db_result)==1?$db_result[0]:$db_result)));
		else	
			output_error("Internal error. Could not SELECT data from table. (".$errorInfo[2].")");
	}

} elseif ($_SERVER['REQUEST_METHOD'] == "POST") {

	output(["POST method is accepted!"]);

} elseif ($_SERVER['REQUEST_METHOD'] == "DELETE") {
	output(["DELETE method is accepted!"]);

} else {
	output_error("Method not supported.");
}

function output(array $a, bool $raw_mode = false) {
	global $ouptut_mode;
	
	if (!$raw_mode) $a = ["status"=>"success", "content"=>$a];

	if ($ouptut_mode == "print_r") { header("Content-type: text/plain"); print_r($a); }
	if ($ouptut_mode == "json")    { header("Content-type: application/json"); echo json_encode($a); }
	
}
function output_error(string $msg) { return output(["status"=>"error", "error_msg" => $msg],true); }

function explodeAtIdxOrEmpty($sep, $value, $idx) { $arr = explode($sep,$value); return isset($arr[$idx])?$arr[$idx]:""; }
