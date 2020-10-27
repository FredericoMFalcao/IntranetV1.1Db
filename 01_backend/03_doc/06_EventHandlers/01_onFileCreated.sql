-- --------------------
--  Module: Documentos EventListner: onFileCreated 
--
--  Descrição: se o FICHEIRO novo criado no sistema é do tipo PDF,
--             então cria um DOCUMENTO novo
-- --------------------


DROP PROCEDURE IF EXISTS DOC_onFileCreated;
DELIMITER //
CREATE PROCEDURE DOC_onFileCreated (
 IN in_Options JSON
 )
 BEGIN
  DECLARE MimeType TEXT;
  SET MimeType = JSON_VALUE(in_Options, '$.MimeType');
  
  IF MimeType = "application/pdf"
  THEN
    CALL DocumentosCriar(in_Options);
  END IF;
 
 END;
 //
 DELIMITER ;
 
 INSERT INTO SYS_EventHandlers (EventName, AfterStoredProcedure) VALUES ('FileCreated','DOC_onFileCreated');
