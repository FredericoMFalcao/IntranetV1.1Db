DROP PROCEDURE IF EXISTS FF_NovaFatura;

DELIMITER //

-- Descrição: transforma um ficheiro no disco numa fatura de fornecedor por classificar
--
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox
--

CREATE PROCEDURE FF_NovaFatura (IN FileId TEXT )
 BEGIN
 
  -- 0. Verificar validade dos argumentos
  IF NOT EXISTS (SELECT Id FROM SYS_Files WHERE Id = FileId)
   THEN signal sqlstate '1452' set message_text = 'FileId inexistente.';
  END IF;
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 1. Inserir em Documentos 
  INSERT INTO Documentos (Tipo, Estado, FileId) 
  VALUES ('FaturaFornecedor', 'PorClassificarFornecedor', FileId);
  
  -- 10. Salvar
  COMMIT;
 END;
//

DELIMITER ;
