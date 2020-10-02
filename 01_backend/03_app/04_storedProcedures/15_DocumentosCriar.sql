DROP PROCEDURE IF EXISTS DocumentosCriar;

DELIMITER //

-- Descrição: transforma um ficheiro no disco num documento
--
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox
--

CREATE PROCEDURE DocumentosCriar (IN in_DocTipo TEXT, IN in_DocEstado TEXT, IN in_FileId TEXT)
  BEGIN
 
    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM SYS_Files WHERE Id = in_FileId)
      THEN signal sqlstate '23000' set message_text = 'FileId inexistente.';
    END IF;
   
    -- 1. Inserir em Documentos 
    INSERT INTO <?=tableNameWithModule("Documentos")?> (Tipo, Estado, FileId) 
    VALUES ('in_DocTipo', 'in_DocEstado', in_FileId);
  
  END;
  
//

DELIMITER ;
