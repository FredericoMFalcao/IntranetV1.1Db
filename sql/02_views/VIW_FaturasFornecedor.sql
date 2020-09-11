-- View: VIW_FaturasFornecedor
-- Descrição: Lista todas as faturas de fornecedores e algumas propriedades
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FaturasFornecedor;

CREATE VIEW VIW_FaturasFornecedor AS
SELECT
	a.NumSerie,
	JSON_EXTRACT (a.Extra, '$.NumFatura') AS NumFatura,
	JSON_EXTRACT (a.Extra, '$.Projeto') AS Projeto,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataRecebida'), DATE) AS DataRecebida,
	CONVERT(JSON_EXTRACT (a.Extra, '$.PeriodoFaturacaoInicio'), DATE) AS PeriodoFaturacaoInicio,
	CONVERT(JSON_EXTRACT (a.Extra, '$.PeriodoFaturacaoFim'), DATE) AS PeriodoFaturacaoFim,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataValFatura'), DATE) AS DataValFatura,
	a.Estado,
	c.Conta AS FornecedorCodigo,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	CONVERT(JSON_EXTRACT (a.Extra, '$.Valor'), DECIMAL(18,2)) AS Valor,
	JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	JSON_EXTRACT (a.Extra, '$.Descricao') AS Descricao
FROM Documentos AS a
	JOIN Lancamentos AS b
		ON a.NumSerie = b.DocNumSerie
	JOIN Contas AS c
		ON b.Conta = c.Conta AND b.TipoConta = c.Tipo
WHERE a.Tipo = 'FacturaFornecedor'
	AND c.TipoConta = 'Fornecedor'
;
