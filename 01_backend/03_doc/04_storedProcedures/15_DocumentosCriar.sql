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

    -- 1. Criar linha na tabela
    -- --------------------------
    
    -- 1.1 Despoletar evento BEFORE
    CALL SYS_TriggerBeforeEvent("DocumentoCriado",in_Extra);
    
    -- 1.2 Executar acção
    INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (FileId) VALUES (in_FileId);
      
    -- 1.3 Despoletar evento AFTER
    CALL SYS_TriggerAfterEvent("DocumentoCriado",in_Extra);
      
  END;
  
//

DELIMITER ;

INSERT INTO SYS_Events (Name, Description) VALUES ('DocumentoCriado', 'Quando é criado um documento contabilístico novo (e.g. quando é recebido um anexo PDF numa caixa de email)');
