-- View: VIW_FF_PorRegistarPagamentoContab
-- Descrição: Lista todas as faturas de fornecedores no estado 'PorRegistarPagamentoContab'
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FF_PorRegistarPagamentoContab;

CREATE VIEW VIW_FF_PorRegistarPagamentoContab AS
SELECT
	a.FileId,
	'CPagamento123.pdf' AS ComprovativoPagamento,                            -- provisório
	a.NumSerie,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	FF_ValorTotal(a.Extra) - 0 AS ValorLiquido,                              -- provisório
	FF_ValorTotal(a.Extra) AS ValorTotal,
	FF_ValorTotal(a.Extra) * 1 AS ValorPagoAKZ                               -- provisório
FROM <?=tableNameWithModule("Documentos","DOC")?> AS a
INNER JOIN <?=tableNameWithModule("Lancamentos")?> AS b ON a.NumSerie = b.DocNumSerie
INNER JOIN <?=tableNameWithModule("Contas")?> AS c ON b.Conta = c.Conta
WHERE a.Tipo = 'FaturaFornecedor'
	AND LEFT(c.Conta,2) = 'FO'
	AND a.Estado = 'PorRegistarPagamentoContab'
;
