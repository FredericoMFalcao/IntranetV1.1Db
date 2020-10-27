
DROP PROCEDURE IF EXISTS DOC_onFileCreated;
DELIMITER //
CREATE PROCEDURE DOC_onFileCreated (
 IN in_Options JSON
 )
 BEGIN
  DECLARE MimeType TEXT;
  SET MimeType = JSON_VALUE('$.MimeType', in_Options);
  
  IF MimeType = "application/pdf"
  THEN
    CALL DocumentosCriar(in_Options);
  END IF;
 
 END;
 //
 DELIMITER ;
 
 INSERT INTO SYS_EventHandlers (EventName, AfterStoredProcedure) VALUES ('FileCreated','DOC_onFileCreated');
