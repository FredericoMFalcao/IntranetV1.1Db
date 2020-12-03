<?php

// Load the sql database connection
require_once __DIR__."/../db_support_functions.php";
require_once __DIR__."/../api_support_functions.php";



// Require SESSION TOKEN
if (!isset($_GET['sessionToken'])) {report_error("no sessionToken provided",400);}
$sessionToken = $_GET['sessionToken'];



// 1. List the events that occurred since last access
$sqlQuery = <<<EOS
SELECT b.EventName AS newEvent
FROM PLT_WebSessions a
INNER JOIN SYS_EventBacklog b ON b.DateTime > a.LastAccessed AND JSON_CONTAINS(a.ListeningToEvents, CONCAT('"',b.EventName,'"'))
WHERE a.Token = '$sessionToken'
EOS;

$newEvents = sql($sqlQuery); 
$newEventsArray = [];
// Unwrap the results
if (!empty($newEvents)) 
	foreach($newEvents as $rowNo => $row)
		$newEventsArray[] = $row['newEvent'];

// 2. Update the LAST ACCESSED web session field
sql("UPDATE PLT_WebSessions SET LastAccessed = NOW() WHERE Token = '$sessionToken'");

// 10. Return a list of events
output_array(array_unique($newEventsArray));
