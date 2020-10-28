DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- Descrição: separa lancamentos por meses. 
-- Função de suporte para outros stored procedures poderem criar linhas na tabela lançamentos. 
-- Cada linha é automaticamente desdobrada nas linhas necessárias para que fique uma linha por cada mês incluído no período dado na chamada desta função.

CREATE PROCEDURE <?=tableNameWithModule()?> (
  in_Conta TEXT,
  in_CoefRateio FLOAT,
  in_Periodo TEXT, -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
  in_DocNumSerie TEXT
  )
  BEGIN
    DECLARE d DATE;
    DECLARE n INT;
    DECLARE c INT;
    DECLARE i INT;
    SET d = LAST_DAY(JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Inicio'))) + INTERVAL 1 DAY - INTERVAL 1 MONTH;
    -- d: primeiro dia do mês em que se inicia o período
    SET n = MONTH(JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Fim'))) - MONTH(JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Inicio'))) + 1;
    -- n: número de meses abrangidos pelo período
    SET c = LENGTH(in_Conta) - LENGTH(REPLACE(in_Conta, ":", "")) + 1;
    -- c: número de contas (para o caso de contas multi, e.g. 'CR0101:AN0202')
    SET i = 1;
    

    -- 0. Verificar validade dos argumentos
    WHILE i <= c DO
  
      IF NOT EXISTS (SELECT Conta FROM <?=tableNameWithModule("Contas")?> WHERE Conta = SUBSTRING_INDEX(SUBSTRING_INDEX(in_Conta, ":", i - c - 1), ":", 1))
        THEN signal sqlstate '23000' set message_text = 'Conta inexistente.';
      END IF;
      
      SET i = i + 1;
    
    END WHILE;
      
    
    -- 1. Criar linhas na tabela de lançamentos
    WHILE d <= JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Fim')) DO
    
      -- a) Caso em que o período é composto apenas por meses completos:
      IF (
        DAY(JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Inicio'))) = 1 AND
        JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Fim')) = LAST_DAY(JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Fim')))
        ) THEN
          INSERT INTO <?=tableNameWithModule("Lancamentos")?> (Conta, CoefRateio, Mes, DocNumSerie)
          VALUES (in_Conta, in_CoefRateio / n, d, in_DocNumSerie);
          
      -- b) Caso em que o período começa e/ou acaba a meio de um mês:
      ELSE
        INSERT INTO <?=tableNameWithModule("Lancamentos")?> (Conta, CoefRateio, Mes, DocNumSerie)
        VALUES (
          in_Conta,
          in_CoefRateio * (
            (DATEDIFF(LEAST(LAST_DAY(d), JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Fim'))), GREATEST(d, JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Inicio')))) + 1) /
            (DATEDIFF(JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Fim')), JSON_UNQUOTE(JSON_EXTRACT(in_Periodo, '$.Inicio'))) + 1)
            ),
          d,
          in_DocNumSerie
        );
      END IF;
    
      SET d = d + INTERVAL 1 MONTH;
      
    END WHILE;
    
  END;
//

DELIMITER ;
