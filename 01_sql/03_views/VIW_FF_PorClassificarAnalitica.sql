-- View: VIW_FF_PorClassificarAnalitica
-- Descrição: Lista as faturas de fornecedores no estado 'PorClassificarAnalitica'
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FF_PorClassificarAnalitica;

CREATE VIEW VIW_FF_PorClassificarAnalitica AS
SELECT
	a.FileId,
	a.NumSerie,
	CONVERT(JSON_EXTRACT(a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT(c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	JSON_EXTRACT(a.Extra, '$.NumFatura') AS NumFatura,
	JSON_EXTRACT(a.Extra, '$.Moeda') AS Moeda,
	FF_Valor_Total(a.Extra) AS Valor
FROM Documentos AS a
INNER JOIN Lancamentos AS b ON a.NumSerie = b.DocNumSerie
INNER JOIN Contas AS c ON b.Conta = c.Conta
WHERE a.Tipo = 'FaturaFornecedor'
	AND LEFT(c.Conta,2) = 'FO'
	AND a.Estado = 'PorClassificarAnalitica'
;
