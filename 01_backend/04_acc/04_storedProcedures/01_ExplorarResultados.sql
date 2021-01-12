-- ------------------------
-- Explorador de Resultados
--
-- Descrição: devolve os movimentos contabilísticos agregados mensalmente, dados:
--              - o tipo de movimento (e.g. custos, proveitos, resutados)
--              - a data do movimento (e.g. emissão da fatura, período faturado, data de pagamento)
--              - um agregador (e.g. centros de resultados, contas analíticas, colaboradores, fornecedores, clientes)
--              - o período pretendido
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (in_Arguments JSON)

  BEGIN
  
    -- Inputs obrigatórios:
    DECLARE in_Agregador TEXT;     -- "CR", "AN", "CO", "FO", "CL", "CR01", "AN0202", "CO123", "FO0000111", "CL001", etc
    DECLARE in_Visao CHAR(1);      -- "F": Faturação, "G": Gestão, "T": Tesouraria
    -- in_Moeda CHAR(3)
    
    -- Inputs exclusivos às visões F e G:
    DECLARE in_Movimento CHAR(1);  -- "C": Custos, "P": Proveitos, "R": Resultados
    DECLARE in_Periodo INT;        -- e.g. 2018 (ano completo 2018), 201802201806 (entre Fev e Jun de 2018)
    DECLARE v_AnoMesInicio INT;
    DECLARE v_AnoMesFim INT;
    
    SET in_Agregador = JSON_VALUE(in_Arguments, '$.Agregador');
    SET in_Visao = JSON_VALUE(in_Arguments, '$.Visao');
    
    
    -- -------
    -- 1. Visão: F / G (Agregador: CR / AN / CO, Movimento: C / P / R, Ano: 20XX)
    -- -------
    IF in_Visao IN ("F", "G") THEN
    
      SET in_Movimento = JSON_VALUE(in_Arguments, '$.Movimento');
      SET in_Periodo = JSON_VALUE(in_Arguments, '$.Periodo');
      IF LENGTH(in_Periodo) = 4 THEN
        SET v_AnoMesInicio = (in_Periodo * 100) + 1;
        SET v_AnoMesFim = (in_Periodo * 100) + 12;
      ELSEIF LENGTH(in_Periodo) = 12 THEN
        SET v_AnoMesInicio = LEFT(in_Periodo, 6);
        SET v_AnoMesFim = RIGHT(in_Periodo, 6);
      END IF;
  
      SELECT
        CASE
          WHEN LEFT(in_Agregador, 2) = "CO" THEN ACC_ExtrairConta("CO", a.Conta)
          ELSE LEFT(ACC_ExtrairConta(LEFT(in_Agregador, 2), a.Conta), LENGTH(in_Agregador) + 2)
        END AS Agregador,
        CASE in_Visao
          WHEN "F" THEN EXTRACT(YEAR_MONTH FROM JSON_VALUE(b.Extra, '$.DataFatura'))
          WHEN "G" THEN EXTRACT(YEAR_MONTH FROM a.Mes)
        END AS AnoMes,
        CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra)) AS DECIMAL(18, 2)) AS Valor
      FROM <?=tableNameWithModule("Lancamentos")?> AS a
        LEFT JOIN <?=tableNameWithModule("Documentos","DOC")?> AS b ON a.DocNumSerie = b.NumSerie
      WHERE
        CASE
          WHEN in_Movimento = "C" THEN a.CoefRateio < 0
          WHEN in_Movimento = "P" THEN a.CoefRateio > 0
        ELSE 1 END
      GROUP BY Agregador, AnoMes
      HAVING 
        AnoMes >= v_AnoMesInicio AND
        AnoMes <= v_AnoMesFim AND
        LEFT(Agregador, LENGTH(in_Agregador)) = in_Agregador
      ORDER BY Agregador, AnoMes;
      
      
    -- -------
    -- 2. Visão: T (Agregador: FO / CL)
    -- -------
    ELSEIF in_Visao = "T" THEN
    
      SELECT
        a.Conta AS Agregador,
        CAST(SUM(a.CoefRateio * ACC_FaturaValorTotal(b.Extra)) AS DECIMAL(18, 2)) AS ValorEmDivida
      FROM <?=tableNameWithModule("Lancamentos")?> AS a
        LEFT JOIN <?=tableNameWithModule("Documentos","DOC")?> AS b ON a.DocNumSerie = b.NumSerie
      WHERE LEFT(a.Conta, LENGTH(in_Agregador)) = in_Agregador
      GROUP BY Agregador
      ORDER BY Agregador;
      
    END IF;
  
  END;
  
//

DELIMITER ;
