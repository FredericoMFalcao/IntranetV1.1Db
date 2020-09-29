<?php

require_once __DIR__."/_tests_lib.php";


(new TestSuite("Faturas Fornecedor"))
->addTest(
	(new UnitTest())
	->describe("Criar fatura de fornecedor e associar a um ficheiro inexistente e receber erro")
	->expectQuery('CALL FF_NovaFatura("ficheironaoexistente.pdf");')
	->toErrWithCode("23000")
)
->addTest(
	(new UnitTest())
	->describe("Criar fatura de fornecedor e associar a um ficheiro existente")
	->expectQuery('INSERT INTO SYS_Files (Id) VALUES ("12345.pdf"); CALL FF_NovaFatura("12345.pdf");')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("Classificar fatura de fornecedor com múltiplos campos")
	->expectQuery('CALL FF_ClassificarFornecedor("12345.pdf","NumFatura","01 Geral","2012-12-12","2012-12-12","{\"Inicio\": \"2011-11-25\", \"Fim\": \"2011-11-25\"}","2012-12-12","0000111","{\"Bens\": {\"ValorBase\": 0.00, \"Iva\": 0.00}, \"Servicos\": {\"ValorBase\":0.00,\"Iva\":0.00}}","AKZ","Fatura de teste");')
	->toSucceed()
)
	
->go();
