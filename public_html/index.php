<?php require_once __DIR__."/../db_support_functions.php"; ?>
<html>
<head>
<?php 
     /* 1. APP's EXTERNAL JAVASCRIPT LIBs / CSS Stylesheets
     *    
     *   Include all the Apps requires external assets (js, css)
     */
     echo "<!-- External LIBs (3rd party code) -->\n";
     // 1.1 Include Javascript external libs
     foreach(sql("SELECT Url FROM PLT_GUI_ExternalLib WHERE Active = 1 AND Type = 'Javascript'") as $url) {
                $url = $url['Url'];
                echo '<script src="'.$url.'" ></script>';
		echo "\n";
     }

     // 1.2 Include CSS external libs
     foreach(sql("SELECT Url FROM PLT_GUI_ExternalLib WHERE Active = 1 AND Type = 'CSS'") as $url) {
                $url = $url['Url'];
                echo '<link rel="stylesheet" href="'.$url.'" >';
		echo "\n";
     }
     

     /* 2. APP's CUSTOM JAVASCRIPT FUNCTIONS
     *    
     *   Include all the Apps global script functions defined in the SQL database 
     */
     echo "<!-- Internal LIBs (custom code) -->\n";

     echo "<script>";
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
