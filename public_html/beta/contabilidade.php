<?php require_once __DIR__."/../../db_support_functions.php"; 
?>

<html>
<head>
<title>Contabilidade</title>
</head>
<body>

<h2>beta version - build tool</h2>

<a href="#system_tools_anchor" >System tools</a>
<a href="#faturas_fornecedor_anchor" >Faturas Forncedor</a>
<a href="#faturas_cliente_anchor" >Faturas Cliente</a>


<h1 id="system_tools_anchor">System tools</h1>
<h3>Upload new file</h3>
<form action="/receiveEmail.php" method="POST" enctype="multipart/form-data" >
	<select name="RecipientMailbox">
		<option>faturasfornecedor@intranetafm.com</option>
		<option>faturascliente@intranetafm.com</option>
		<option>comprovativospagamento@intranetafm.com</option>
	</select>
	<br>
	<input type="file" name="genericFile" id="genericFile" /><br>
	<input type="submit" name="submitFile" />
</form>

<h1>Documentos</h1>
<table border="1">
<thead>
	<tr>
		<th>Id</th>
		<th>NumSerie</th>
		<th>Tipo</th>
		<th>Estado</th>
		<th>FileId</th>
		<th>Extra</th>
	</tr>
</thead>
<tbody>
<?php foreach(sql("SELECT Id, NumSerie,Tipo,Estado, FileId, Extra FROM DOC_Documentos") as $rowNo => $row) : ?>
	<tr>
		<td><?=$row['Id']?></td>
		<td><?=$row['NumSerie']?></td>
		<td><?=$row['Tipo']?></td>
		<td><?=$row['Estado']?></td>
		<td><?=$row['FileId']?></td>
		<td><?=$row['Extra']?></td>
	</tr>
<?php endforeach;?>
</tbody>
</table>

<h1 id="faturas_fornecedor_anchor">Faturas Fornecedor </h1>
<h3>Classificar Fornecedor</h3>
<table border="1">
<thead>
	<tr>
		<th>FileId</th>
		<th>Fornecedor</th>
		<th>Button</th>
	</tr>
</thead>
<tbody>
<?php foreach(sql("SELECT FileId, Id FROM VIW_FF_PorClassificarFornecedor") as $rowNo => $row) : ?>
	<tr>
		<form action="/sql/DOC_DocumentoAprovar" method="GET" >
			<td><a href="/FileAccess/<?=$row['FileId']?>">PDF Icon</a></td>
			<td>
					<input type="hidden" name="in_DocId"     value="<?=$row['Id']?>" />
					<input type="text"   name="in_Arguments" value="" />
			</td>
			<td><input type="submit" name="aprovar" /></td>
		</form>
	</tr>
<?php endforeach;?>
</tbody>
</table>



<h3>Classificar Analitica</h3>
<h3>Registar na Contabilidade</h3>
<h3>Anexar Comprovativo de Pagamento</h3>
<h3>Registar Pagamento na Contabilidade</h3>
<h3>Consulta</h3>

<br>
<br>
<br>
<hr>
<h1 id="faturas_cliente_anchor">Faturas Cliente </h1>



</body>
</html>
