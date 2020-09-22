-- View: VIW_Projetos
-- Descrição: Lista todos os projetos (primeiro nível dos centros de resultados)
-- Depende de: tabela 'Contas'

DROP VIEW IF EXISTS VIW_Projetos;

CREATE VIEW VIW_Projetos AS
SELECT
  Conta,
  Nome
FROM Contas
WHERE LEFT(Conta,2) = 'CR' AND LENGTH(Conta) = 4
;
