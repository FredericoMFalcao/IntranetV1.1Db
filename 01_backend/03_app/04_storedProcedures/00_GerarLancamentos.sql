DROP PROCEDURE IF EXISTS CriarLancamento;

DELIMITER //

-- Descrição: separa lancamentos por meses. 
-- Função de suporte para outros stored procedures poderem criar linhas na tabela lançamentos. 
-- Cada linha é automaticamente desdobradas nas linhas necessárias para que fique uma linha cada mês incluído no período dado na chamada desta função.

CREATE PROCEDURE CriarLancamento (
  Conta TEXT,
  CoefRateio FLOAT,
  Periodo TEXT, -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
  DocNumSerie TEXT
  )
  BEGIN
    DECLARE d DATE;
    DECLARE n INT;
    SET d = LAST_DAY(JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Inicio'))) + INTERVAL 1 DAY - INTERVAL 1 MONTH;
    -- d: primeiro dia do mês em que se inicia o período
    SET n = MONTH(JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Fim'))) - MONTH(JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Inicio'))) + 1;
    -- n: número de meses abrangidos pelo período
    
    WHILE d <= JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Fim')) DO
    
      -- a) Caso em que o período é composto apenas por meses completos:
      IF (
        DAY(JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Inicio'))) = 1 AND
        JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Fim')) = LAST_DAY(JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Fim')))
        ) THEN
          INSERT INTO <?=tableNameWithModule("Lancamentos")?> (Conta, CoefRateio, Mes, DocNumSerie)
          VALUES (Conta, CoefRateio / n, d, DocNumSerie);
      -- b) Caso em que o período começa e/ou acaba a meio de um mês:
      ELSE
        INSERT INTO <?=tableNameWithModule("Lancamentos")?> (Conta, CoefRateio, Mes, DocNumSerie)
        VALUES (
          Conta,
          CoefRateio * (
            (DATEDIFF(LEAST(LAST_DAY(d), JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Fim'))), GREATEST(d, JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Inicio')))) + 1) /
            (DATEDIFF(JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Fim')), JSON_UNQUOTE(JSON_EXTRACT(Periodo, '$.Inicio'))) + 1)
            ),
          d,
          DocNumSerie
        );
      END IF;
    
      SET d = d + INTERVAL 1 MONTH;
      
    END WHILE;
    
  END;
//

DELIMITER ;
