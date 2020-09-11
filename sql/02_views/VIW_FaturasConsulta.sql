-- View: VIW_FaturasConsulta
-- Descrição: Lista todas as faturas para a window 'Estado das Faturas'
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FaturasConsulta;

CREATE VIEW VIW_FaturasConsulta AS
SELECT
	a.NumSerie,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	JSON_EXTRACT (a.Extra, '$.NumFatura') AS NumFatura,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	CONVERT(JSON_EXTRACT (a.Extra, '$.Valor'), DECIMAL(18,2)) AS Valor,
	JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	JSON_EXTRACT (a.Extra, '$.Projeto') AS Projeto
FROM Documentos AS a
INNER JOIN Lancamentos AS b ON a.NumSerie = b.DocNumSerie
INNER JOIN Contas AS c      ON b.Conta = c.Conta AND b.TipoConta = c.Tipo
WHERE a.Tipo = 'FaturaFornecedor'
	AND c.Tipo = 'Fornecedor'
;
