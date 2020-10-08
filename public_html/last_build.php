<html>
	<head>
		<!-- BOOTSTRAP LIBRARIES -->

		<link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css" integrity="sha384-JcKb8q3iqJ61gNV9KGb8thSsNjpSL0n8PARn9HuZOnIxN0hoP+VmmDGMN5t9UJ0Z" crossorigin="anonymous">
		
		<script src="https://code.jquery.com/jquery-3.5.1.slim.min.js" integrity="sha384-DfXdz2htPH0lsSSs5nCTpuj/zy4C+OGpamoFVy38MVBnE+IbbVYUew+OrCXaRkfj" crossorigin="anonymous"></script>
		<script src="https://cdn.jsdelivr.net/npm/popper.js@1.16.1/dist/umd/popper.min.js" integrity="sha384-9/reFTGAW83EW2RDu2S0VKaIzap3H66lZH81PoYlFhbGU+6BZp6G7niu735Sk7lN" crossorigin="anonymous"></script>
		<script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js" integrity="sha384-B4gt1jrGC7Jh4AgTPSdUtOBvfO8shuf57BaghqFfPlYxofvL8/KUEfYiJOMMV+rV" crossorigin="anonymous"></script>

		<!-- highlight.js LIBRARIES -->
		<link rel="stylesheet" href="/css/default.css">
		<script src="/js/highlight.min.js"></script>
		<script>hljs.initHighlightingOnLoad();</script>

			

	</head>
	<body class="container">
		<h2>Links</h2>
			<ul class="list-group list-group-horizontal">
				<li class="list-group-item">	<a class="btn btn-default" href="sql_explorer.php">sql explorer</a></li>
				<li class="list-group-item">	<a class="btn btn-danger" href="deploy_code.sh">force code deployment</a></li>
				<li class="list-group-item">	<button class="btn btn-primary" onclick="alert('not yet implemented');">Merge Branch Into Master</button></li>
				<li class="list-group-item">	<button class="btn btn-primary" onclick="alert('not yet implemented');">Fork</button></li>
			</ul>
		<hr>
		
		<h2>Last WebServer Errors</h2>
		<pre><?php passthru("tail ../log/apache2_error.log");  ?></pre>
		<hr>
		
		<h2>Last Compilation Status</h2>
		<pre><?php echo file_get_contents("./last_update_error.txt"); ?></pre>
		<hr>
		
		<h2>Last Unit Test Results</h2>
		<pre><?php echo file_get_contents("./last_unit_test_results.html"); ?></pre>

		<h2>Last Compilation Text</h2>
		<?php
		$contentGroup = [
			["title"=> "Before PHP preprocessing", "body" => file_get_contents("./last_compiled_code_0.txt")],
			["title"=> "After PHP preprocessing", "body" => file_get_contents("./last_compiled_code.txt")]
		];
		?>
		<div class="accordion" id="accordionExample">
			<?php foreach($contentGroup as $i => $content): ?>
		  <div class="card">
		    <div class="card-header" id="headingOne">
		      <h2 class="mb-0">
			<button class="btn btn-link btn-block text-left" type="button" data-toggle="collapse" data-target="#collapseGroup<?=$i?>" aria-expanded="true" aria-controls="collapseOne">
					<?= $content['title']?>
			</button>
		      </h2>
		    </div>

		    <div id="collapseGroup<?=$i?>" class="collapse" aria-labelledby="headingOne" data-parent="#accordionExample">
		      <div class="card-body">
			      <pre><code class="language-sql" ><?= htmlspecialchars($content['body'])?></code></pre>
		      </div>
		    </div>
		  </div>
			<?php endforeach; ?>
		</div>
		
	</body>
</html>
