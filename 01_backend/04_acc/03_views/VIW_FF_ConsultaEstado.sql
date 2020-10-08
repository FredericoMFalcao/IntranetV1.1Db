-- View: VIW_FF_ConsultaEstado
-- Descrição: Lista todas as faturas de fornecedores excepto as que se encontram no estado 'PorClassificarFornecedor'
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FF_ConsultaEstado;

CREATE VIEW VIW_FF_ConsultaEstado AS
SELECT
	a.FileId,
	'CPagamento123.pdf' AS ComprovativoPagamento,                           -- provisório
	a.NumSerie,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	JSON_EXTRACT (a.Extra, '$.NumFatura') AS NumFatura,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	FF_ValorTotal(a.Extra) AS Valor,
	JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	JSON_EXTRACT (a.Extra, '$.Projeto') AS Projeto,
	a.Estado
FROM <?=tableNameWithModule("Documentos","DOC")?> AS a
INNER JOIN <?=tableNameWithModule("Lancamentos")?> AS b ON a.NumSerie = b.DocNumSerie
INNER JOIN <?=tableNameWithModule("Contas")?> AS c ON b.Conta = c.Conta
WHERE a.Tipo = 'FaturaFornecedor'
	AND a.Estado != 'PorClassificarFornecedor'
	AND LEFT(c.Conta,2) = 'FO'
;
