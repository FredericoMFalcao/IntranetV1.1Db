<?php require_once __DIR__."/../../db_support_functions.php"; 

function aggregateData($unaggregatedData) {
	$data = [];
	// Initializing Agregador
	foreach($unaggregatedData as $row)
		$data[$row['Agregador']] = [    
		"Agregador" => "<a href='?".http_build_query(array_merge($_GET,["Agregador"=>$row["Agregador"]]))."'>".$row['Agregador']."</a>",
						"Jan"=> 0,
						"Fev"=> 0,
						"Mar"=> 0,
						"Abr"=> 0,
						"Mai"=> 0,
						"Jun"=> 0,
						"Jul"=> 0,
						"Ago"=> 0,
						"Set"=> 0,
						"Out"=> 0,
						"Nov"=> 0,
						"Dez"=> 0
		];
	// Fill in with data
	foreach($unaggregatedData as $row)
		$data[$row['Agregador']][array_keys($data[$row['Agregador']])[intval(substr($row['Periodo'],4,2))]] 
			= number_format($row['Valor']);

	return $data;
}



?>

<html>
<head>
<title>Explorador de Resultados</title>
</head>
<body>

<h1>Explorador de Resultados </h1>
<h2>beta version - build tool</h2>

<?php if (isset($_GET['rawQuery'])) : 
	$data = aggregateData(sql($_GET['rawQuery']));
?>
<?php elseif (isset($_GET['Visao'])) : 
	$_GET['Ano'] = intval($_GET['Ano']);
	$data = aggregateData(sql("CALL ACC_ExplorarResultados('".json_encode($_GET)."')"));
?>
<?php else : ?>
	<form action="" method="GET">
		Raw Query: <input type="text" name="rawQuery" />
		<input type="submit" value="submit" />
	</form>
<hr>
	<form action="" method="GET">
		Agregador: <input type="text" name="Agregador" />
		Visao: <select name="Visao"><option>F</option><option>G</option><option>T</option></select>
		Movimento: <select name="Movimento"><option>C</option><option>P</option><option>R</option><option>-</option></select>
		Ano: <select name="Ano"><?php foreach(range(2015,2025) as $y) echo "<option>$y</option>"; ?></select>		
		<input type="submit" value="submit" />
	</form>
<?php endif; ?>
<table border="1">
<thead>
	<tr>
		<tr>
			<?php foreach($data[array_keys($data)[0]] as $colName => $dummy) : ?>
			<th><?= $colName ?></th>
			<?php endforeach; ?>
		</tr>
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


</body>
</html>
