<?php require_once __DIR__."/../db_support_functions.php"; ?>
<?php 
	if (!isset($_GET["q"])) 
		$_GET["q"] = "SELECT * FROM Contas";
	$data = sql($_GET["q"]); 
?>
<html>
<head>
</head>
<body>
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

