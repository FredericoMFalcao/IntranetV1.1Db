<?php
// vim: syntax=php

ini_set("display_errors", "stderr");
ini_set("error_reporting", E_ALL);

function tableNameWithModule(string $tblName = '', string $moduleName = '') {
  // Import variables from outer scope
  global $outerScopeCompleteFilePath;
  // Set default of no value was provided
  if ($tblName == "") {
	if(!preg_match(";[0-9]{2}_([A-Za-z0-9_]+)\.sql$;", $outerScopeCompleteFilePath,$matches)) 
		die("INTERNAL ERROR! Could not figure out tableName from current file name. ($outerScopeCompleteFilePath)");
	$tblName = $matches[1]; 
  }
  // Extract module name
  if ($moduleName == '') {
	  $moduleName = array_slice(explode("/", $outerScopeCompleteFilePath),-3,1)[0];
	  $moduleName = substr($moduleName, 3);
  }

  return strtoupper($moduleName)."_".$tblName." ";
  
}
?>
