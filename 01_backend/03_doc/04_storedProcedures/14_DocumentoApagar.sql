DROP PROCEDURE IF EXISTS DocumentoApagar;

DELIMITER //

CREATE PROCEDURE DocumentoApagar (IN in_DocId INT)

  BEGIN
    DECLARE v_TipoDoc TEXT;
	SET v_TipoDoc = (SELECT Tipo FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
  
    IF v_TipoDoc = 'FaturaFornecedor' THEN
	  CALL FaturaFornecedorApagar (in_DocId);
	  
	ELSEIF v_TipoDoc = 'ComprovativoPagamento' THEN
	  CALL ComprovativoPagamentoApagar (in_DocId);
      
    END IF;

  END;
  
//

DELIMITER ;
