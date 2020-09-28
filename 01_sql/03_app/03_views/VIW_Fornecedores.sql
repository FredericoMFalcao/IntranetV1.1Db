-- View: VIW_Fornecedores
-- Descrição: Lista todos os fornecedores
-- Depende de: tabela 'Contas'

DROP VIEW IF EXISTS VIW_Fornecedores;

CREATE VIEW VIW_Fornecedores AS
SELECT
  Conta AS Codigo,
  Nome,
  JSON_EXTRACT (Extra, '$.NomeCurto') AS NomeCurto,
  JSON_EXTRACT (Extra, '$.NIF') AS NIF
FROM <?=tableNameWithModule("Contas")?> 
WHERE LEFT(Conta,2) = 'FO'
;
