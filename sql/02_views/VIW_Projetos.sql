-- View: VIW_Projetos
-- Descrição: Lista todos os projetos (primeiro nível dos centros de resultados)
-- Depende de: tabela 'Contas'

DROP VIEW IF EXISTS VIW_Projetos;

CREATE VIEW VIW_Projetos AS
SELECT
  Conta AS Codigo,
  Nome
FROM Contas
WHERE Tipo = 'CentroResultados' AND LENGTH(Conta) = 2
;
