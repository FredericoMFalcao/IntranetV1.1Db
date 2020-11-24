-- ------------------------
--  Tabela (sql): Documentos Funcao: Criar 
--
--  Descrição: transforma um ficheiro no disco num documento (entrada/linha na base de dados)
--        será chamada pelo sistema quando:
--         (1) recebe um email com anexo PDF
--         (2) ficheiro Dropbox é adicionado a uma pasta partilhada
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_Arguments JSON)

  BEGIN
    DECLARE in_FileId, v_Extra TEXT;
    SET in_FileId = JSON_VALUE(in_Arguments, '$.Id');
    SET v_Extra = CONCAT("{", 
                    CONCAT_WS(":",'"FileExtra"', JSON_EXTRACT(in_Arguments,'$.Extra'))
                  ,"}");
                                                        
    -- 1. Espoletar procedimentos BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> (
      "DocumentoCriado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", '"FileId"', CONCAT('"',in_FileId,'"')),
          CONCAT_WS(":", '"Extra"', v_Extra)
        ),
      "}")
    );
    
    -- 2. Executar a acção (espoletar procedimentos PROCESSING)
    CALL <?=tableNameWithModule("TriggerProcessingEvent","SYS")?> (
      "DocumentoCriado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", '"FileId"', CONCAT('"',in_FileId,'"')),
          CONCAT_WS(":", '"Extra"', v_Extra)
        ),
      "}")
    );
      
    -- 3. Espoletar procedimentos AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> (
      "DocumentoCriado",
      (SELECT
        CONCAT(
          "{", 
          CONCAT_WS(
            ",", 
            CONCAT_WS(":", '"DocId"', MAX(Id)),
            CONCAT_WS(":", '"Tipo"', CONCAT('"',Tipo,'"')),
            CONCAT_WS(":", '"FileId"', CONCAT('"',FileId,'"')),
            CONCAT_WS(":", '"Extra"', Extra)
          ),
          "}"
        )  
      FROM <?=tableNameWithModule("Documentos","DOC")?>)
    );
      
  END;
  
//

DELIMITER ;

-- Inserir evento:
INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoCriado', 'Quando é criado um documento contabilístico novo (e.g. quando é recebido um anexo PDF numa caixa de email)');
