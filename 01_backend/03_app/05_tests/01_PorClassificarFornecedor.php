<?php

require_once __DIR__."/_tests_lib.php";


(new TestSuite("Faturas Fornecedor"))
->addTest(
	(new UnitTest())
	->describe("Criar fatura de fornecedor, associar a um ficheiro inexistente e receber erro")
	->expectQuery('
		CALL DocumentosCriar ("FaturaFornecedor", "PorClassificarFornecedor", "ficheironaoexistente.pdf");
	')
	->toErrWithCode("23000")
)
->addTest(
	(new UnitTest())
	->describe("Criar fatura de fornecedor e associar a um ficheiro existente")
	->expectQuery('
		INSERT INTO SYS_Files (Id) VALUES ("fatura123.pdf");
		CALL DocumentosCriar ("FaturaFornecedor", "PorClassificarFornecedor", "fatura123.pdf");
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("Classificar fornecedor")
	->expectQuery('
		CALL DocumentoAprovar (1,"FTAn12#123.pdf","123","01","2012-12-12","2012-12-12","{\"Inicio\": \"2011-11-01\", \"Fim\": \"2011-12-31\"}","2012-12-12","FO0000111","{\"Bens\": {\"ValorBase\": 0.00, \"Iva\": 0.00}, \"Servicos\": {\"ValorBase\":900,\"Iva\":100}}","AKZ","Fatura de teste",0,0,NULL,NULL);
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("Classificar analítica")
	->expectQuery('
		CALL DocumentoAprovar (1,"FTAn12#123.pdf",NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,NULL,"[{\"CentroResultados\": \"CR0101\", \"Analitica\": \"AN0202\", \"Colaborador\": \"CO123\", \"Valor\": 800}, {\"CentroResultados\": \"CR0101\", \"Analitica\": \"AN0202\", \"Colaborador\": \"CO456\", \"Valor\": 200}]",NULL);
	')
	->toSucceed()
)
	
->go();
