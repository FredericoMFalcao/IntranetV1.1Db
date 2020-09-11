<?php
/* 1. Fetch the database credentials from the local JSON file */
$db_cred = json_decode(file_get_contents(__DIR__."/.db_credentials.json"),1);
/* 2. Build the shell command, passing the credentials as environmental variables */
$shell_cmd = ""; foreach($db_cred as $k => $v) $shell_cmd .= "$k=$v ";
/* 3. Execute the shell script */
$status = 0;
$errorMsg = "";
exec($shell_cmd.__DIR__.'/_update_code.sh 2>&1',$errorMsg,$status);
file_put_contents("public_html/last_update_error.txt", ($status?$errorMsg:"Success!"));
