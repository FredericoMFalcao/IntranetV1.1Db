<html>
<head>

<script>
<?php 
      require_once __DIR__."/../db_support_functions.php";
      if(($js_funcs = sql("SELECT Name, InputArgs_json, Code  FROM PLT_GUI_Javascript"))) 
	foreach($js_funcs as $js_func) {
		extract($js_func);
		echo "\bfunction ".$Name."(".implode(", ",array_values($InputArgs_json)).") {\n";
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
