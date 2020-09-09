-- View: VIW_FaturasFornecedor
-- Descrição: Lista todas as Faturas de Fornecedores e algumas propriedades
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FaturasFornecedor;

CREATE VIEW VIW_FaturasFornecedor AS
SELECT
	SELECT a.NumSerie,
	SELECT JSON_EXTRACT (a.Extra, '$.NumFatura') AS NumFatura,
	SELECT JSON_EXTRACT (a.Extra, '$.Projecto') AS Projecto,
	CAST(SELECT JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	CAST(SELECT JSON_EXTRACT (a.Extra, '$.DataRecebida'), DATE) AS DataRecebida,
	CAST(SELECT JSON_EXTRACT (a.Extra, '$.PeriodoFaturacaoInicio'), DATE) AS PeriodoFaturacaoInicio,
	CAST(SELECT JSON_EXTRACT (a.Extra, '$.PeriodoFaturacaoFim'), DATE) AS PeriodoFaturacaoFim,
	CAST(SELECT JSON_EXTRACT (a.Extra, '$.DataValFatura'), DATE) AS DataValFatura,
	SELECT c.Conta AS FornecedorCodigo,
	SELECT c.Nome AS FornecedorNome,
	SELECT JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	CAST(SELECT JSON_EXTRACT (a.Extra, '$.Valor'), DECIMAL(18,2)) AS Valor,
	SELECT JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	SELECT JSON_EXTRACT (a.Extra, '$.Descricao') AS Descricao
FROM Documentos AS a
	JOIN Lancamentos AS b
		ON a.NumSerie = b.DocNumSerie
	JOIN Contas AS c
		ON b.Conta = c.Conta AND b.TipoConta = c.Tipo
WHERE a.Tipo = 'FacturaFornecedor'
	AND c.TipoConta = 'Fornecedor'
;
