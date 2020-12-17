-- ------------------------
--  Module: Documentos | EventListner: onProcessingDocumentoCriado
--
--  Descrição: insere uma linha na tabela Documentos
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_Options TEXT)

  BEGIN
    DECLARE in_FileId TEXT;
    DECLARE in_Extra JSON;
    SET in_FileId = JSON_VALUE(in_Options, '$.FileId');
    SET in_Extra = JSON_EXTRACT(in_Options, '$.Extra');

    INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (FileId, Extra) VALUES (in_FileId, in_Extra);
      
  END;
  
//

DELIMITER ;

-- Inserir Event Handler:
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, ProcessingStoredProcedure) VALUES ('DocumentoCriado', 'DOC_onProcessingDocumentoCriado');
