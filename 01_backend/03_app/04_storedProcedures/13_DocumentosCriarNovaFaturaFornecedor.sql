DROP PROCEDURE IF EXISTS DocumentosCriarNovaFaturaFornecedor;

DELIMITER //

-- Descrição: transforma um ficheiro no disco numa fatura de fornecedor por classificar
--
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox
--

CREATE PROCEDURE DocumentosCriarNovaFaturaFornecedor (IN in_FileId TEXT)
  BEGIN
 
    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM SYS_Files WHERE Id = in_FileId)
      THEN signal sqlstate '23000' set message_text = 'FileId inexistente.';
    END IF;
   
    -- 1. Inserir em Documentos 
    INSERT INTO <?=tableNameWithModule("Documentos")?> (Tipo, Estado, FileId) 
    VALUES ('FaturaFornecedor', 'PorClassificarFornecedor', in_FileId);
  
  END;
  
//

DELIMITER ;
