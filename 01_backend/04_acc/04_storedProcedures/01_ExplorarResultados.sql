-- ------------------------
-- Explorador de Resultados
--
-- Descrição: devolve os movimentos contabilísticos agregados mensalmente, dados:
--              - o tipo de movimento (e.g. custos, proveitos, resutados, saldo)
--              - a data do movimento (e.g. emissão da fatura, período faturado, data de pagamento)
--              - um agregador (e.g. centros de resultados, contas analíticas, um fornecedor específico)
--              - o ano pretendido
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (
  in_Visao CHAR(1),   -- "F": Faturação, "G": Gestão, "T": Tesouraria
  in_Agregador TEXT,  -- e.g. "CR", "AN", "CO", "FO", "CR01", "AN0202", "CO123", "FO0000111"
  in_Ano INT
  -- in_TipoMovimento TEXT,  -- Resultados, Custos, Proveitos
  -- in_Moeda CHAR(3)
)

  BEGIN

    SELECT
      CASE
        WHEN LEFT(in_Agregador, 2) IN ("CR", "AN")
          THEN LEFT(ACC_ExtrairConta(LEFT(in_Agregador, 2), a.Conta), LENGTH(in_Agregador) + 2)
        WHEN LEFT(in_Agregador, 2) = "CO"
          THEN ACC_ExtrairConta("CO", a.Conta)
        WHEN LEFT(in_Agregador, 2) = "FO"
          THEN a.Conta
      END AS Agregador,
      CASE in_Visao
        WHEN "F" THEN EXTRACT(YEAR_MONTH FROM JSON_VALUE(b.Extra, '$.DataFatura'))
        WHEN "G" THEN EXTRACT(YEAR_MONTH FROM a.Mes)
        WHEN "T" THEN EXTRACT(YEAR_MONTH FROM (JSON_VALUE(c.Extra, '$.DataPagamento')))
      END AS Periodo,
      CASE
        WHEN LEFT(in_Agregador, 2) = "FO"
          THEN CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra) * (-1)) AS DECIMAL(18, 2))
        ELSE CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra)) AS DECIMAL(18, 2))
      END AS Valor
    FROM <?=tableNameWithModule("Lancamentos")?> AS a
      LEFT JOIN <?=tableNameWithModule("Documentos","DOC")?> AS b ON a.DocNumSerie = b.NumSerie
      LEFT JOIN <?=tableNameWithModule("Documentos","DOC")?> AS c ON JSON_VALUE(b.Extra, '$.ComprovativoPagamentoId') = c.Id
    WHERE CASE WHEN LEFT(in_Agregador, 2) = "FO" THEN a.CoefRateio > 0 ELSE 1 END
    GROUP BY Agregador, Periodo
    HAVING 
      LEFT(Periodo, 4) = in_Ano AND
      LEFT(Agregador, LENGTH(in_Agregador)) = in_Agregador
    ORDER BY Agregador, Periodo;
    
  END;
  
//

DELIMITER ;
