DROP PROCEDURE IF EXISTS DocumentoMarcar;

DELIMITER //

-- ------------------------
--  Tabela (virtual): Documento Funcao: Marcar
--
-- Descrição: marca um documento para se destacar em listas/tabelas com muitos documentos
-- ------------------------

CREATE PROCEDURE DocumentoMarcar (IN DocId INT, IN in_Marcado BOOLEAN)

  BEGIN

    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId)
      THEN signal sqlstate '23000' set message_text = 'Documento inexistente.';
    END IF;
      
    UPDATE <?=tableNameWithModule("Documentos")?>
    SET Extra = JSON_SET(Extra, '$.Marcado', in_Marcado);

  END;
  
//

DELIMITER ;
