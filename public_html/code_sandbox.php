<?php require_once __DIR__."/../db_support_functions.php"; ?>

<?php 
/*
*   0. SUPPORT LIBs 
*
*/
function runPythonInterpreter() {
	global $pythonDBLib;
	$descriptorspec = [["pipe","r"],["pipe","w"],["pipe","w"]];

	/* proc_open(bin, pipeDescription, pipes, cwd, env); */
	$process = proc_open('/usr/bin/python3', $descriptorspec, $pipes, __DIR__, []);

	if (is_resource($process)) {
	    if (isset($_POST['DBConnection']) && $_POST['DBConnection'])
		$pythonCode = $pythonDBLib."\n\n".$_POST['pythonCode'];
	    else
		$pythonCode = $_POST['pythonCode'];

	    fwrite($pipes[0], $pythonCode); fclose($pipes[0]);
	    $pythonRes =  stream_get_contents($pipes[1]); fclose($pipes[1]);
	    $pythonRes .=  stream_get_contents($pipes[2]); fclose($pipes[2]);

            $return_value = proc_close($process);

	}
	return $pythonRes;
}

$pythonDBLib = <<<EOS
from project_root import db_support_functions as db
import json,sys, os

# 1. Connect to Database Server
#####################
db_cred = json.loads(''.join(open('./project_root/.db_credentials_rawSql.json', 'r').readlines()))
branch_name = os.path.dirname(os.path.abspath(__file__)).split("/")[-2]
db_cred["defaultDb"] = "IntranetV2" + ("_"+branch_name if branch_name != "master" else "")
if not "server" in db_cred or not "user" in db_cred or not "password" in db_cred or not "defaultDb" in db_cred :
	print("DB Lib: Wrong .db_credentials_rawSql.json format. Missing server or user or password or defaultDb.")
	sys.exit(1)
else:
	db.connectToMariaDBServer(db_cred['server'], db_cred['user'], db_cred['password'], db_cred['defaultDb'])

# queryResult = db.sql(get_arguments["q"].value, errorInfo)
# print(json.dumps(queryResult if queryResult != False else errorInfo))
EOS;

/*
*   1. MAIN APPLICATION 
*
*/

if (isset($_POST['pythonCode'])) $pythonRes = runPythonInterpreter();
?>
<html>
<head>
</head>
<body>
	<h2>Python</h2>
	<form method="POST" action="">
		<input type="checkbox" checked="checked" name="DBConnection" value="DBConnection" />DB Connection<br>
		<hr>
		<input type="submit" value="Run" /><br>
		<textarea name="pythonCode" rows="10" cols="120"><?=(isset($_POST['pythonCode'])?$_POST['pythonCode']:"Use: db.sql(...) to run SQL queries")?></textarea>
	</form>
	<textarea rows="10" cols="120"><?=(isset($pythonRes)?$pythonRes:"Output will be shown here")?></textarea>
<br><br>

	<hr>
	<hr>
	<h2>SQL </h2>
	<form method="GET">
		<input type="text" name="q" placeholder="sql query here..." ></input>
		<input type="submit" value="submit" />
	</form>
	<hr>

	<?php if (isset($data) && isset($data[0])) : ?>
	<table>
	<thead>
		<tr>
			<?php foreach($data[0] as $colName => $dummy) : ?>
			<th><?= $colName ?></th>
			<?php endforeach; ?>
		</tr>
	</thead>
	<tbody>
		<?php foreach($data as $rowNo => $row) : ?>
		<tr>
			<?php foreach($row as $colName => $colValue) : ?>
			<td><?=$colValue?></td>
			<?php endforeach; ?>
		</tr>
		<?php endforeach; ?>
	</tbody>
	</table>
	<?php else : ?>
	Empty result set.
	<?php endif; ?>
</body>
</html>

