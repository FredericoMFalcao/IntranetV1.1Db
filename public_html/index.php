<html>
<head>

<script>
<?php 

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
	
?>
</script>
</head>
<body>

<script>
	var rootController = RootController();
	document.body.append(rootController.renderDOM())
</script>
</body>
</html>
