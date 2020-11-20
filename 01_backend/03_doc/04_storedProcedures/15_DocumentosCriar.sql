
-- ------------------------
--  Tabela (sql): Documentos Funcao: Criar 
--
-- Descrição: transforma um ficheiro no disco num documento (entrada/linha na base de dados)
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox é adicionado a uma pasta partilhada
-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;
DELIMITER //
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Arguments JSON)
  BEGIN
    DECLARE in_FileId, v_Extra TEXT;
    SET in_FileId = JSON_VALUE(in_Arguments, '$.Id');
    
    SET v_Extra = CONCAT("{", 
                    CONCAT_WS(":",'"FileExtra"', JSON_EXTRACT(in_Arguments,'$.Extra'))
                  ,"}");
                                                        
    -- 0. Verificar validade dos argumentos

    -- 1. Criar linha na tabela
    -- --------------------------
    
    -- 1.1 Espoletar evento BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> (
      "DocumentoCriado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", CONCAT('"', "FileId", '"'), in_FileId),
          CONCAT_WS(":", CONCAT('"', "Extra", '"'), v_Extra)
        ),
      "}");
    );
    
    -- 1.2 Executar acção
    INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (FileId, Extra) VALUES (in_FileId, v_Extra);
      
    -- 1.3 Espoletar evento AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> (
      "DocumentoCriado",
      (SELECT
        CONCAT(
          "{", 
          CONCAT_WS(
            ",", 
            CONCAT_WS(":", '"Id"', Id),
            CONCAT_WS(":", '"Tipo"', CONCAT('"',Tipo,'"')),
            CONCAT_WS(":", '"FileId"', CONCAT('"',FileId,'"')),
            CONCAT_WS(":", '"Extra"', Extra)
          ),
          "}"
        )  
      FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = LAST_INSERT_ID())
    );
      
  END;
  
//

DELIMITER ;

INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoCriado', 'Quando é criado um documento contabilístico novo (e.g. quando é recebido um anexo PDF numa caixa de email)');
