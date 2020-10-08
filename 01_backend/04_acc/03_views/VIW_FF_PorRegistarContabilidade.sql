-- View: VIW_FF_PorRegistarContabilidade
-- Descrição: Lista todas as faturas de fornecedores no estado 'PorRegistarContabilidade'
-- Depende de: tabelas 'Documentos', 'Lancamentos' e 'Contas'

DROP VIEW IF EXISTS VIW_FF_PorRegistarContabilidade;

CREATE VIEW VIW_FF_PorRegistarContabilidade AS
SELECT
	a.FileId,
	a.NumSerie,
	CONVERT(JSON_EXTRACT (a.Extra, '$.DataFatura'), DATE) AS DataFatura,
	c.Nome AS FornecedorNome,
	JSON_EXTRACT (c.Extra, '$.FornecedorNIF') AS FornecedorNIF,
	'Centro' AS CentroResultados,                                     -- provisório
	'Analitica' AS Analitica,                                         -- provisório
	FF_ValorTotal(a.Extra) AS Valor,
	JSON_EXTRACT (a.Extra, '$.Moeda') AS Moeda,
	JSON_EXTRACT (a.Extra, '$.Projeto') AS Projeto,
	'C. Geral' AS CGeral,                                             -- provisório
	0 AS Acrescimo,                                                   -- provisório
	0 AS Amortizacao                                                  -- provisório
FROM <?=tableNameWithModule("Documentos","DOC")?> AS a
INNER JOIN <?=tableNameWithModule("Lancamentos")?> AS b ON a.NumSerie = b.DocNumSerie
INNER JOIN <?=tableNameWithModule("Contas")?> AS c ON b.Conta = c.Conta
WHERE a.Tipo = 'FaturaFornecedor'
	AND LEFT(c.Conta,2) = 'FO'
	AND a.Estado = 'PorRegistarContabilidade'
;
