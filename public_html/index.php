<html>
<head>
</head>
<body>
<h2>Links</h2>
<ul>
	<li>	<a href="sql_explorer.php">sql explorer</a></li>
	<li>	<a href="update_code.php">update code</a></li>
</ul>
<hr>
<h2>Last Compilation Error</h2>
<pre><?php echo file_get_contents("./last_update_error.txt"); ?></pre>
<hr>
<h2>Last Compilation Text</h2>
<pre><?php echo file_get_contents("./last_compiled_code.txt"); ?></pre>
</body>
</html>
