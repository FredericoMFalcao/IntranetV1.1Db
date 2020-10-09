DROP PROCEDURE IF EXISTS DocumentosCriar;

DELIMITER //

-- ------------------------
--  Tabela (sql): Documentos Funcao: Criar 
--
-- Descrição: transforma um ficheiro no disco num documento (entrada/linha na base de dados)
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox é adicionado a uma pasta partilhada
-- ------------------------

CREATE PROCEDURE DocumentosCriar (IN in_Extra JSON)
  BEGIN
    DECLARE in_DocTipo TEXT;
    DECLARE in_FileId TEXT;
    SET in_DocTipo = JSON_VALUE(in_Extra, '$.DocTipo');
    SET in_FileId = JSON_VALUE(in_Extra, '$.FileId');
    
    
    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Files","SYS")?> WHERE Id = in_FileId)
      THEN signal sqlstate '23000' set message_text = 'FileId inexistente.';
    END IF;
 
    
    -- 1. Chamar procedimentos específicos
    IF in_DocTipo = 'FaturaFornecedor' THEN
      CALL FaturasFornecedorCriar (in_Extra);
      
    ELSEIF in_DocTipo = 'ComprovativoPagamento' THEN
      CALL ComprovativosPagamentoCriar (in_Extra);
      
    END IF;
  
  END;
  
//

DELIMITER ;
