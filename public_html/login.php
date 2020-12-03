<?php

// Load the sql database connection
require_once __DIR__."/../db_support_functions.php";
require_once __DIR__."/../api_support_functions.php";



// Require USER
if (!isset($_GET['user'])) {report_error("no user provided",400);}
$user = $_GET['user'];

// @todo: write a line to accept only "a-zA-Z0-9_-" in $user

// @todo: require a PASSWORD. Check the password against the password stored in the system.

$session = [];

// 1. Check if an active session exists
$userSession = sql("SELECT User  FROM PLT_WebSessions WHERE User = '$user'");
if (!empty($userSession)) $session = $userSession;

// 2. Create a new session if no session exists for this user
if (empty($session)) {
	$session['Token'] = md5(rand());
	$session['IP'] = $_SERVER['REMOTE_ADDR'];
	$session['User'] = $user;
	$errorInfo = [];
	if ( insert_into("PLT_WebSessions", $session, $errorInfo) === false) 
		report_error(print_r($errorInfo,1), 500);		

}

// 10. Return the session
output_array($session);
