-- ------------------------
-- Visualizar Extrato (complementar ao Explorador de Resultados)
--
-- Descrição: devolve os movimentos referentes a uma combinação específica agregador/mês
--              de um output do Explorador de Resultados
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE ACC_VisualizarExtrato (in_Arguments JSON)
  
  BEGIN
  
    -- Inputs obrigatórios:
    DECLARE in_Agregador TEXT;     -- "CR01", "AN0202", "CO123", "FO0000111", "CL001", etc
    DECLARE in_Visao CHAR(1);      -- "F": Faturação, "G": Gestão, "T": Tesouraria
    
    -- Inputs exclusivos às visões F e G:
    DECLARE in_Movimento CHAR(1);  -- "C": Custos, "P": Proveitos, "R": Resultados
    DECLARE in_AnoMes INT;         -- e.g. 201804
    
    SET in_Agregador = JSON_VALUE(in_Arguments, '$.Agregador');
    SET in_Visao = JSON_VALUE(in_Arguments, '$.Visao');


    -- -------
    -- 1. Visão: F / G (Agregador: CR / AN / CO, Movimento: C / P / R, AnoMes: 20XXXX)
    -- -------
    IF in_Visao IN ("F", "G") THEN
    
    SET in_Movimento = JSON_VALUE(in_Arguments, '$.Movimento');
    SET in_AnoMes = JSON_VALUE(in_Arguments, '$.AnoMes');
    
    SELECT
      CASE in_Visao
        WHEN "F" THEN JSON_VALUE(b.Extra, '$.DataFatura')
        WHEN "G" THEN a.Mes
      END AS Dia,
      ACC_ExtrairConta("CR", a.Conta) AS CentroResultados,
      ACC_ExtrairConta("AN", a.Conta) AS Analitica,
      JSON_VALUE(b.Extra, '$.Descricao') AS Descricao,
      CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra)) AS DECIMAL(18, 2)) AS Valor,
      b.FileId
    FROM ACC_Lancamentos AS a
      LEFT JOIN DOC_Documentos AS b ON a.DocNumSerie = b.NumSerie
    WHERE a.Conta LIKE CONCAT("%", in_Agregador, "%") AND
      CASE in_Movimento
        WHEN "C" THEN a.CoefRateio < 0
        WHEN "P" THEN a.CoefRateio > 0
      ELSE 1 END
    GROUP BY Dia, FileId, CentroResultados, Analitica
    HAVING EXTRACT(YEAR_MONTH FROM Dia) = in_AnoMes
    ORDER BY Dia;
    
    
    -- -------
    -- 2. Visão: T (Agregador: FOXXX / CLXXX, Movimento: -, AnoMes: -)
    -- -------
    ELSEIF in_Visao = "T" THEN
    
      SELECT
        JSON_VALUE(b.Extra, '$.DataFatura') AS DataFatura,
        JSON_VALUE(b.Extra, '$.Descricao') AS Descricao,
        CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra)) AS DECIMAL(18, 2)) AS Valor,
        b.FileId
      FROM ACC_Lancamentos AS a
        LEFT JOIN DOC_Documentos AS b ON a.DocNumSerie = b.NumSerie
      WHERE a.Conta = in_Agregador
      GROUP BY a.Conta, a.DocNumSerie
      HAVING Valor != 0
      ORDER BY DataFatura;
      
    END IF;
    
  END;
  
//

DELIMITER ;
