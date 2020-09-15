-- View: VIW_Fornecedores
-- Descrição: Lista todos os fornecedores
-- Depende de: tabela 'Contas'

DROP VIEW IF EXISTS VIW_Fornecedores;

CREATE VIEW VIW_Fornecedores AS
SELECT
	Conta AS Codigo,
	Nome,
	SELECT JSON_EXTRACT (Extra, '$.NomeCurto') AS NomeCurto,
	SELECT JSON_EXTRACT (Extra, '$.NIF') AS NIF
FROM Contas
WHERE Tipo = 'Fornecedor'
;
