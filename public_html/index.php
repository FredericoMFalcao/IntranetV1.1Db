<html>
<head>
</head>
<body>
<h2>Links</h2>
<ul>
	<li>	<a href="sql_explorer.php">sql explorer</a></li>
	<li>	<a href="deploy_code.php">force code deployment</a></li>
</ul>
<hr>
<h2>Last WebServer Errors</h2>
<pre><?php passthru("tail ../log/apache2_error.log");  ?></pre>
<hr>
<h2>Last Compilation Status</h2>
<pre><?php echo file_get_contents("./last_update_error.txt"); ?></pre>
<hr>
<h2>Last Compilation Text</h2>
<pre><?php echo file_get_contents("./last_compiled_code.txt"); ?></pre>
<h2>Last Unit Test Results</h2>
<pre><?php echo file_get_contents("./last_unit_test_results.html"); ?></pre>
</body>
</html>
