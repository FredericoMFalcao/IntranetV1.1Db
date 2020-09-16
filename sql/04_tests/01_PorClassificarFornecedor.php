<?php

require_once __DIR__."/_tests_lib.php";


(new TestSuite("Faturas Fornecedor"))
->addTest(
	/* #1 : Formato do número de série */
	(new UnitTest())
	->describe("Classificar fatura de fornecedor com num de série válido (FTAn19#001.pdf).")
	->expectQuery('CALL NovaFaturaFornecedor("FTAn19#001.pdf","xxx-xxx")')
	->toSucceed()
)
->addTest(
	/* #2 : Formato do número de série */
	(new UnitTest())
	->describe("Bloquear fatura de fornecedor com num de série inválido.")
	->expectQuery('CALL NovaFaturaFornecedor("GG19#001.pdf","xxx-xxx")')
	->toErrWithCode("20000")
)
->addTest(
	/* #3 : Classificar um documento com fornecedor */
	(new UnitTest())
	->describe("Classificar fatura de fornecedor com múltiplos campos")
	->expectQuery('CALL FatFornecedor_ClassificarFornecedor("FTAn12#001.pdf","NumFatura","01 Geral","2012-12-12","2012-12-12","{\"Inicio\": \"2011-11-25\", \"Fim\": \"2011-11-25\"}","2012-12-12","0000111","{\"Bens\": {\"ValorBase\": 0.00, \"Iva\": 0.00}, \"Servicos\": {\"ValorBase\":0.00,\"Iva\":0.00}}","AKZ","Fatura de teste");')
	->toSucceed()
)

->go();
