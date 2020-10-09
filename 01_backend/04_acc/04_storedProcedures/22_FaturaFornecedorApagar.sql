DROP PROCEDURE IF EXISTS FaturaFornecedorApagar;

DELIMITER //

CREATE PROCEDURE FaturaFornecedorApagar (IN in_FaturaId INT)

  BEGIN

	IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId AND Tipo = 'FaturaFornecedor')
	  THEN signal sqlstate '23000' set message_text = 'Fatura de fornecedor inexistente.';
	ELSE
	  DELETE FROM <?=tableNameWithModule("Documentos","DOC")?>
	  WHERE Id = in_FaturaId;
	END IF;

  END;
  
//

DELIMITER ;
