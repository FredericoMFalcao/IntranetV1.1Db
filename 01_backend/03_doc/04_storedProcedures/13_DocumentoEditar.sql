DROP PROCEDURE IF EXISTS DocumentoEditar;

DELIMITER //

-- ------------------------
--  Tabela (sql): Documentos Funcao: Editar
--
--  Descrição: Editar um ou mais campos de um documento já existente
-- ------------------------

CREATE PROCEDURE DocumentoEditar (IN in_DocId INT, IN in_Extra JSON)

  BEGIN
  
    -- 1. Separar os inputs de acordo com os campos da tabela Documentos:
    DECLARE in_NumSerie TEXT;
    DECLARE in_Tipo TEXT;
    DECLARE in_Estado TEXT;
    DECLARE in_FileId TEXT;
    DECLARE in_Extra2 JSON;
    SET in_NumSerie = JSON_VALUE(in_Extra, '$.NumSerie');
    SET in_Tipo = JSON_VALUE(in_Extra, '$.Tipo');
    SET in_Estado = JSON_VALUE(in_Extra, '$.Estado');
    SET in_FileId = JSON_VALUE(in_Extra, '$.FileId');
    SET in_Extra2 = JSON_REMOVE(in_Extra, '$.NumSerie', '$.Tipo', '$.Estado', '$.FileId');
  
  
    -- 2. Verificar se existe o documento:
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId)
      THEN signal sqlstate '23000' set message_text = 'Documento inexistente.';
    END IF;
    
  
    -- 3. Fazer as alterações à tabela, no caso de existirem alterações nos dados:
    IF in_NumSerie IS NOT NULL THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET NumSerie = in_NumSerie 
      WHERE Id = in_DocId;
    END IF;
      
    IF in_Tipo IS NOT NULL THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Tipo = in_Tipo 
      WHERE Id = in_DocId;
    END IF;
      
    IF in_Estado IS NOT NULL THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = in_Estado 
      WHERE Id = in_DocId;
    END IF;
      
    IF in_FileId IS NOT NULL THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET FileId = in_FileId 
      WHERE Id = in_DocId;
    END IF;
      
    UPDATE <?=tableNameWithModule("Documentos")?>
    SET Extra = JSON_MERGE_PATCH(Extra, in_Extra2)
    WHERE Id = in_DocId;

  END;
  
//

DELIMITER ;
