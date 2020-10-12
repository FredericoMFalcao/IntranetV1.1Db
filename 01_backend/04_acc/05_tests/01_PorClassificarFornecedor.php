<?php

require_once __DIR__."/_tests_lib.php";


(new TestSuite("Faturas Fornecedor"))
->addTest(
	(new UnitTest())
	->describe("Criar fatura de fornecedor, associar a um ficheiro inexistente e receber erro")
	->expectQuery('
		CALL DocumentosCriar ("{\"DocTipo\": \"FaturaFornecedor\", \"FileId\": \"ficheiroinexistente.pdf\"}");
	')
	->toErrWithCode("23000")
)
->addTest(
	(new UnitTest())
	->describe("1. Criar fatura de fornecedor e associar a um ficheiro existente")
	->expectQuery('
		INSERT INTO SYS_Files (Id) VALUES ("fatura123.pdf");
		CALL DocumentosCriar ("{\"DocTipo\": \"FaturaFornecedor\", \"FileId\": \"fatura123.pdf\"}");
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("2. Classificar fornecedor")
	->expectQuery('
		CALL DocumentoAprovar (1, "{\"NumSerie\": \"FTAn12#123.pdf\", \"NumFatura\": \"123\", \"Projeto\": \"01\", \"DataFatura\": \"2012-12-12\", \"DataRecebida\": \"2012-12-12\", \"PeriodoFaturacao\": {\"Inicio\": \"2011-11-01\", \"Fim\": \"2011-12-31\"}, \"DataValidade\": \"2012-12-12\", \"FornecedorCodigo\": \"FO0000111\", \"Valor\": {\"Bens\": {\"ValorBase\": 0.00, \"Iva\": 0.00}, \"Servicos\": {\"ValorBase\":900,\"Iva\":100}}, \"Moeda\": \"AKZ\", \"Descricao\": \"Fatura de teste\", \"ImpostoConsumo\": 0, \"Amortizacao\": 0}");
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("3. Classificar analítica")
	->expectQuery('
		CALL DocumentoAprovar (1, "{\"NumSerie\": \"FTAn12#123.pdf\", \"ClassificacaoAnalitica\": [{\"CentroResultados\": \"CR0101\", \"Analitica\": \"AN0202\", \"Colaborador\": \"CO123\", \"Valor\": 800}, {\"CentroResultados\": \"CR0101\", \"Analitica\": \"AN0202\", \"Colaborador\": \"CO456\", \"Valor\": 200}]}");
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("4. Registar na contabilidade")
	->expectQuery('
		CALL DocumentoAprovar (1, NULL);
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("5. Anexar comprovativo de pagamento")
	->expectQuery('
		INSERT INTO SYS_Files (Id) VALUES ("cpagamento123.pdf");
		CALL DocumentosCriar ("{\"DocTipo\": \"ComprovativoPagamento\", \"FileId\": \"cpagamento123.pdf\", \"ContaBancaria\": \"CB01\"}");
		CALL DocumentoAprovar (1, "{\"ComprovativoPagamentoId\": 2}");
	')
	->toSucceed()
)
->addTest(
	(new UnitTest())
	->describe("6. Registar pagamento na contabilidade")
	->expectQuery('
		CALL DocumentoAprovar (1, NULL);
	')
	->toSucceed()
)
	
->go();
