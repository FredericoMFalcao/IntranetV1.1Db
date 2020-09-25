<?php
// vim: syntax=php

function tableNameWithModule(string $tblName, string $moduleName) {
//   $key = array_search(__FUNCTION__, array_column(debug_backtrace(), 'function'));
//   $callerFileNameAndPath = debug_backtrace()[$key]['file'];

//  $path = explode("/",$callerFileNameAndPath);
//  $moduleName = $path[count($path)-3];
  
//  return strtoupper(substr($moduleName, 3))."_".$tblName;
  
  return strtoupper($moduleName)."_".$tblName;

}
?>
