-- View: VIW_FF_PorAnexarCPagamento
-- Descrição: Lista todas as faturas de fornecedores no estado 'PorAnexarCPagamento'
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FF_PorAnexarCPagamento;

CREATE VIEW VIW_FF_PorAnexarCPagamento AS
SELECT
	a.FileId,
	a.NumSerie,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	JSON_EXTRACT (a.Extra, '$.Projeto') AS Projeto,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	JSON_EXTRACT (a.Extra, '$.NumFatura') AS NumFatura,
	ACC_FaturaValorTotal(a.Extra) AS ValorTotal,
	0 AS Retencao,                                          -- provisório
	ACC_FaturaValorTotal(a.Extra) - 0 AS ValorLiquido,             -- provisório
	JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	'CPagamento123.pdf' AS DocComprovativo                  -- provisório
FROM <?=tableNameWithModule("Documentos","DOC")?> AS a
INNER JOIN <?=tableNameWithModule("Lancamentos")?> AS b ON a.NumSerie = b.DocNumSerie
INNER JOIN <?=tableNameWithModule("Contas")?> AS c ON b.Conta = c.Conta
WHERE a.Tipo = 'FaturaFornecedor'
	AND LEFT(c.Conta,2) = 'FO'
	AND a.Estado = 'PorAnexarCPagamento'
;
