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
->go();
