-- View: VIW_Projectos
-- Descrição: Lista todos os projectos (primeiro nível dos centros de resultados)
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
