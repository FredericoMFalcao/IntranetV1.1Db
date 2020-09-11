<?php require_once __DIR__."/../db_support_functions.php"; ?>
<?php $data = sql("SELECT * FROM Contas;"); ?>
<html>
<head>
</head>
<body>
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
</body>
</html>

