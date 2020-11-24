-- ------------------------
-- Tabela (sql): Documentos Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
    
    -- 1. Espoletar procedimentos BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> (
      "DocumentoApagado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", '"DocId"', in_DocId),
          CONCAT_WS(":", '"Extra"', in_Arguments)
        ),
      "}")
    );
    
    -- 2. Executar a acção (espoletar procedimentos PROCESSING)
    CALL <?=tableNameWithModule("TriggerProcessingEvent","SYS")?> (
      "DocumentoApagado",
      CONCAT("{",
        CONCAT_WS(":", '"DocId"', in_DocId),
      "}")
    );
    
    -- 3. Espoletar procedimentos AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> (
      "DocumentoApagado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", '"DocId"', in_DocId),
          CONCAT_WS(":", '"Extra"', in_Arguments)
        ),
      "}")
    );

  END;
  
//

DELIMITER ;

-- Inserir evento:
INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoApagado', 'Quando um documento contabilístico é apagado');