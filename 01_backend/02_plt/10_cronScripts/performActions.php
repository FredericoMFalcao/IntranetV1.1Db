#!/usr/bin/php
<?php
require_once __DIR__."/../../../db_support_functions.php";

$sqlQuery  = "SELECT ";
$sqlQuery .= "id, SqlCode, PhpCode ";
$sqlQuery .= "FROM PLT_CalendarActions ";
$sqlQuery .= "WHERE Active = 1 AND ";
$sqlQuery .= "NextActiveDate - NOW() > 0  ";

foreach(sql($sqlQuery) as $row) {
	extract($row);
	if ($SqlCode) {
		$errorInfo = [];
		if (!sql($SqlCode, $errorInfo))
			// Log the Error return value
			sql("UPDATE PLT_CalendarActions SET Log = '".str_replace("'", '"', print_r($errorInfo,1))."' WHERE id = $id");  continue; }
		else
			// Log the SUCCESS return value
			sql("UPDATE PLT_CalendarActions SET Log = 'Success' WHERE id = $id");
		
	}
	if ($PhpCode) {
		try { $output = eval($PhpCode); }
		// Log the Error return value
		catch (Exception $e) { sql("UPDATE PLT_CalendarActions SET Log = '".str_replace("'", '"', $e->getMessage())."' WHERE id = $id");  continue; }

		// Log the SUCCESS return value
		sql("UPDATE PLT_CalendarActions SET Log = '".str_replace("'", '"', $output)."' WHERE id = $id");
	}
}
