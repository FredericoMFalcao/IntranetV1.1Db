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
	    $pythonCode = "";
	    // Add necessary LIBs
	    if (isset($_POST['DBConnection']) && $_POST['DBConnection']) $pythonCode .= $pythonDBLib."\n\n";
	    if (isset($_POST['importJSON']) && $_POST['importJSON']) $pythonCode .= "\nimport json\n";
	    // Add Code
	    $pythonCode .= $_POST['pythonCode'];

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
db_cred = json.loads(''.join(open('./project_root/.db_credentials.json', 'r').readlines()))
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

$PythonPlaceholderCode = <<<EOS
# Usage (sample):
# errorInfo = []
# import json
# # single query:
# print(db.sql("SELECT * FROM ACC_Contas"))
# # multi query:
# print(db.sql("CALL ACC_ExplorarResultados('"+json.dumps({"Ano":2020,"Visao":"F","Agregador":"CR"})+"')",errorInfo,True))



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
	<h1>Code Sandbox</h1>
	<ul>
		<li><a href="#python">Python</a></li>
		<li><a href="#sql">SQL</a></li>
	</ul>
	<hr>
	<h2 id="python">Python</h2>
	<form method="POST" action="">
		<input type="checkbox" checked="checked" name="DBConnection" value="DBConnection" />DB : db.sql()<br>
		<input type="checkbox" checked="checked" name="importJSON" value="importJSON" />JSON : json.dump(), json.loads()<br>
		<hr>
		<input type="submit" value="Run" /><br>
		<textarea 
			name="pythonCode" 
			rows="10" 
			cols="120"
		><?=(isset($_POST['pythonCode'])?$_POST['pythonCode']:$PythonPlaceholderCode)?></textarea>
	</form>
	<textarea rows="10" cols="120"><?=(isset($pythonRes)?$pythonRes:"Output will be shown here")?></textarea>
<br><br>

	<hr>
	<hr>
	<h2 id="sql">SQL </h2>
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

