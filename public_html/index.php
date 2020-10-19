<html>
<head>
<?php 
     /* 1. APP's EXTERNAL JAVASCRIPT LIBs / CSS Stylesheets
     *    
     *   Include all the Apps requires external assets (js, css)
     */
?>
	
	<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" ></script>
	<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" ></script>
	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" ></script>
	
	<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" >
<!--	<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.3/js/bootstrap.bundle.min.js" integrity="sha384-ho+j7jyWK8fNQe+A12Hb8AhRq26LrZ/JpcUGGOn+Y7RsweNrtN/tE3MoK7ZeZDyx" crossorigin="anonymous"></script> -->

<?php 
     /* 2. APP's CUSTOM JAVASCRIPT FUNCTIONS
     *    
     *   Include all the Apps global script functions defined in the SQL database 
     */
     echo "<script>";
      require_once __DIR__."/../db_support_functions.php";
      if(($js_funcs = sql("SELECT FuncName, InputArgs_json, Code  FROM PLT_GUI_Javascript")) !== false)  
	foreach($js_funcs as $js_func) {
		extract($js_func);
		echo "\nfunction ".$FuncName."(".implode(", ",array_keys($InputArgs_json)).") {\n";
		/* Add runtime typecheck and errors */
		echo "/* Check type validity */\n";
		foreach($InputArgs_json as $name => $type) {
			if (strpos($type, "?") !== false) {$optional = true; $type = str_replace("?","",$type);} else $optional = false;
			echo "if (";
			echo "typeof $name != \"$type\" ";
			if ($optional) echo " && typeof $name != \"undefined\"";
			echo ") ";
			echo "throw \"Invalid type for $name. Expected $type got \"+typeof $name;\n";
		}
		echo $Code;
		echo "\n}\n";
	}
     echo "</script>";
?>

</head>
<body>

<script>
	var rootController = RootController();
	document.body.append(rootController.renderDOM())
</script>
</body>
</html>
