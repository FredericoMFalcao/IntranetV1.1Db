DROP PROCEDURE IF EXISTS DocumentosCriar;

DELIMITER //

-- Descrição: transforma um ficheiro no disco num documento
--
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox
--

CREATE PROCEDURE DocumentosCriar (IN in_Extra JSON)
  BEGIN
  
    -- Inputs comuns a todos os tipos de documento:
    DECLARE in_DocTipo TEXT;
    DECLARE in_FileId TEXT;
    
    -- Inputs específicos para comprovativos de pagamento:
    DECLARE in_ContaBancaria TEXT;
    
    SET in_DocTipo = JSON_VALUE(in_Extra, '$.DocTipo');
    SET in_FileId = JSON_VALUE(in_Extra, '$.FileId');
    SET in_ContaBancaria = JSON_VALUE(in_Extra, '$.ContaBancaria');
 
 
    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM SYS_Files WHERE Id = in_FileId)
      THEN signal sqlstate '23000' set message_text = 'FileId inexistente.';
    END IF;
   
   
    -- 1. Inserir em Documentos
    
    -- 1.1. Inserir fatura de fornecedor
    IF in_DocTipo = 'FaturaFornecedor' THEN
      INSERT INTO <?=tableNameWithModule("Documentos")?> (Tipo, Estado, FileId) 
      VALUES (in_DocTipo, 'PorClassificarFornecedor', in_FileId);
      
      
    -- 1.2. Inserir comprovativo de pagamento
    ELSEIF in_DocTipo = 'ComprovativoPagamento' THEN
      INSERT INTO <?=tableNameWithModule("Documentos")?> (Tipo, Estado, FileId) 
      VALUES (in_DocTipo, 'Concluido', in_FileId);
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Extra = JSON_SET(Extra, '$.ContaBancaria', in_ContaBancaria)
      WHERE FileId = in_FileId;
      
      
    END IF;
  
  END;
  
//

DELIMITER ;
