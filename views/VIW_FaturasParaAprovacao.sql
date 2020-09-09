-- View: VIW_FaturasParaAprovacao
-- Descrição: Lista todas as faturas à espera de aprovação
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FaturasFornecedor;

CREATE VIEW VIW_FaturasFornecedor AS
SELECT
	a.NumSerie,
	CAST(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	JSON_EXTRACT (a.Extra, '$.NumFatura') AS NumFatura,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	CAST(JSON_EXTRACT (a.Extra, '$.Valor'), DECIMAL(18,2)) AS Valor,
	JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	JSON_EXTRACT (a.Extra, '$.Projecto') AS Projecto
FROM Documentos AS a
	JOIN Lancamentos AS b
		ON a.NumSerie = b.DocNumSerie
	JOIN Contas AS c
		ON b.Conta = c.Conta AND b.TipoConta = c.Tipo
WHERE a.Tipo = 'FacturaFornecedor'
	AND c.TipoConta = 'Fornecedor'
;
