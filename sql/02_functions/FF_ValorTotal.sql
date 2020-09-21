DROP FUNCTION IF EXISTS FF_ValorTotal;

DELIMITER //

CREATE FUNCTION FF_ValorTotal (Extra TEXT)
RETURNS DECIMAL(18,2)
BEGIN
  DECLARE i INT;
  DECLARE Valor DECIMAL(18,2);
  SET i = 0;
  SET Valor = 0;

  WHILE i != JSON_LENGTH(JSON_EXTRACT (Extra, '$.Valor')) DO
  
    SET Valor = Valor + JSON_EXTRACT(JSON_EXTRACT(Extra, '$.Valor'), CONCAT("$.", JSON_EXTRACT(JSON_KEYS(JSON_EXTRACT(Extra, '$.Valor')), CONCAT("$[", i, "]"))));
	
	SET i = i + 1;

  END WHILE;
  
  RETURN Valor;

END;

//
  
DELIMITER ;
