-- ------------------------
-- Visualizar Extrato (complementar ao Explorador de Resultados)
--
-- Descrição: devolve os movimentos referentes a uma combinação específica agregador/mês
--              de um output do Explorador de Resultados
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (
  in_Visao CHAR(1),  -- "F": Faturação, "G": Gestão, "T": Tesouraria
  in_Conta TEXT,     -- e.g. "CR01", "AN0202", "CO123", "FO0000111"
  in_AnoMes INT      -- e.g. 201804
)

  BEGIN

    SELECT
      CASE in_Visao
        WHEN "F" THEN JSON_VALUE(b.Extra, '$.DataFatura')
        WHEN "G" THEN a.Mes
        WHEN "T" THEN JSON_VALUE(c.Extra, '$.DataPagamento')
        END AS Dia,
      CASE WHEN LEFT(in_Conta, 2) != "FO" THEN ACC_ExtrairConta("CR", a.Conta) END AS CentroResultados,
      CASE WHEN LEFT(in_Conta, 2) != "FO" THEN ACC_ExtrairConta("AN", a.Conta) END AS Analitica,
      JSON_VALUE(b.Extra, '$.Descricao') AS Descricao,
      CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra)) AS DECIMAL(18, 2)) AS Valor,
      b.FileId
    FROM <?=tableNameWithModule("Lancamentos")?> AS a
      LEFT JOIN <?=tableNameWithModule("Documentos","DOC")?> AS b ON a.DocNumSerie = b.NumSerie
      LEFT JOIN <?=tableNameWithModule("Documentos","DOC")?> AS c ON JSON_VALUE(b.Extra, '$.ComprovativoPagamentoId') = c.Id
    WHERE a.Conta LIKE CONCAT("%", in_Conta, "%") AND
      CASE WHEN LEFT(in_Conta, 2) = "FO" THEN a.CoefRateio > 0 ELSE 1 END
    GROUP BY Dia, FileId, CentroResultados, Analitica
    HAVING EXTRACT(YEAR_MONTH FROM Dia) = in_AnoMes
    ORDER BY Dia;
    
  END;
  
//

DELIMITER ;
