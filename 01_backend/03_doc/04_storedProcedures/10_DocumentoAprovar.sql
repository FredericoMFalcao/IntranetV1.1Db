DROP PROCEDURE IF EXISTS DocumentoAprovar;

DELIMITER //

CREATE PROCEDURE DocumentoAprovar (IN in_Extra JSON)

  BEGIN
    DECLARE in_DocId INT;
    SET in_DocId = JSON_VALUE(in_Extra, '$.DocId');
  
    IF EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId AND Tipo = 'FaturaFornecedor') THEN
      CALL FaturaFornecedorAprovar (in_Extra);
      
    END IF;

  END;
  
//

DELIMITER ;
