<?php

function report_error(string $msg, int $error_Code = 500) { 
	// Handle DEBUG MODE - print human-friendly text
	if (isset($_GET['__debug'])) {
		header("Content-type", "text/plain");
		print_r(["status"=>$error_Code, "message"=> $msg]); 
		die();

	} 
	
	// Normal MODE - print computer-friendly code
	header("Content-type", "application/json"); 
	echo json_encode(["status"=>$error_Code, "message"=> $msg]); 
	die(); 
}

function output_array(array $arr) {
	// Handle DEBUG MODE - print human-friendly text
	if (isset($_GET['__debug'])) {
		header("Content-type", "text/plain");
		print_r(["status"=>200, "content"=> $arr]);
		die();

	} 
	
	// Normal MODE - print computer-friendly code
	header("Content-type", "application/json");
	echo json_encode(["status"=>200, "content"=> $arr]);
	die();
}

