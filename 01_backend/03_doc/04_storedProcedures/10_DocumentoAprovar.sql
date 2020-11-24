-- ------------------------
--  Tabela (sql): Documentos Funcao: Aprovar
--
--  Descrição: Mover um "documento" específico um estado para a frente no "workflow" programado
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
    DECLARE v_DocTipo TEXT;
    DECLARE v_Estado TEXT;
    SET v_DocTipo = (SELECT Tipo FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);

    
    -- 1. Espoletar procedimentos BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> (
      "DocumentoAprovado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", CONCAT('"', "DocId", '"'), in_DocId),
          CONCAT_WS(":", CONCAT('"', "Extra", '"'), in_Arguments)
        ),
      "}")
    );
    
    -- 2. Executar a acção (espoletar procedimentos PROCESSING)
    CALL <?=tableNameWithModule("TriggerProcessingEvent","SYS")?> (in_DocId);
    
    -- 3. Espoletar procedimentos AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> (
      "DocumentoAprovado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", CONCAT('"', "DocId", '"'), in_DocId),
          CONCAT_WS(":", CONCAT('"', "Extra", '"'), in_Arguments)
        ),
      "}")
    );

  END;
  
//

DELIMITER ;

-- Inserir evento:
INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoAprovado', 'Quando um documento é aprovado (i.e. passa um estado para a frente no "workflow" programado)');
