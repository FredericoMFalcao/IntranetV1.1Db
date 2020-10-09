DROP PROCEDURE IF EXISTS ComprovativoPagamentoApagar;

DELIMITER //

CREATE PROCEDURE ComprovativoPagamentoApagar (IN in_ComprovativoPagamentoId INT)

  BEGIN

	IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_ComprovativoPagamentoId AND Tipo = 'ComprovativoPagamento')
	  THEN signal sqlstate '23000' set message_text = 'Comprovativo de pagamento inexistente.';
	  
	ELSE
	
	  DELETE FROM <?=tableNameWithModule("Documentos","DOC")?>
	  WHERE Id = in_ComprovativoPagamentoId;
	  
	  UPDATE <?=tableNameWithModule("Documentos","DOC")?>
	  SET Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', 0)
	  WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId;
	  
	END IF;

  END;
  
//

DELIMITER ;
