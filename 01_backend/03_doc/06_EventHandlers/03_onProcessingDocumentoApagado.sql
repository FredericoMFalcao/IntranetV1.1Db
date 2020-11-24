-- ------------------------
--  Module: Documentos  EventListner: onProcessingDocumentoApagado
--
--  Descrição: apaga uma linha da tabela Documentos
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT)

  BEGIN

    DELETE FROM <?=tableNameWithModule()?> WHERE Id = in_DocId;
      
  END;
  
//

DELIMITER ;

-- Inserir Event Handler:
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, ProcessingStoredProcedure) VALUES ('DocumentoApagado', 'DOC_onProcessingDocumentoApagado');
