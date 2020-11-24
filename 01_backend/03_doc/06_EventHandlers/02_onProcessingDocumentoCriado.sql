-- ------------------------
--  Module: Documentos  EventListner: onProcessingDocumentoCriado
--
--  Descrição: insere uma linha na tabela Documentos
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_FileId TEXT, IN in_Extra JSON)

  BEGIN

    INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (FileId, Extra) VALUES (in_FileId, in_Extra);
      
  END;
  
//

DELIMITER ;

-- Inserir Event Handler:
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, ProcessingStoredProcedure) VALUES ('DocumentoCriado', <?=tableNameWithModule()?>);
