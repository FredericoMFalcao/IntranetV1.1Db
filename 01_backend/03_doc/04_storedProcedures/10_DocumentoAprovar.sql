-- ------------------------
--  Tabela (sql): Documentos Funcao: Aprovar
--
--  Descrição: Mover um "documento" específico um estado para a frente no "workflow" programado
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
    
    -- 1. Espoletar procedimentos BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> (
      "DocumentoAprovado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", '"DocId"', in_DocId),
          CONCAT_WS(":", '"Extra"', in_Arguments)
        ),
      "}")
    );
    
    -- 2. Executar a acção (espoletar procedimentos PROCESSING)
    CALL <?=tableNameWithModule("TriggerProcessingEvent","SYS")?> (
      "DocumentoAprovado",
      CONCAT("{",
        CONCAT_WS(":", '"DocId"', in_DocId),
      "}")
    );
    
    -- 3. Espoletar procedimentos AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> (
      "DocumentoAprovado",
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
INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoAprovado', 'Quando um documento é aprovado (i.e. passa um estado para a frente no "workflow" programado)');
