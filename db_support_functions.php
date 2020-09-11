<?php

/* 0. Get the credentials to connect to database */
extract(json_decode(file_get_contents(__DIR__."/.db_credentials.json"),1));
$dsn = "mysql:host=$server;dbname=$defaultDb;";

/* 1. Attempt to connect */
/* 1.1 Create global database object (dbo) */
try {$dbo = new PDO($dsn, $user, $password);} 
catch (PDOException $e) {die('Database Connection failed: ' . $e->getMessage());}    

$dbo->prepare("USE $defaultDb;")->execute();


