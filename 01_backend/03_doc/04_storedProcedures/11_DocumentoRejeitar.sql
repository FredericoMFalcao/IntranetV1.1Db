-- ------------------------
-- Tabela (sql): Documento Funcao: Rejeitar
--
-- Descrição: Move um "documento" específico um estado para trás no "workflow" programado
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
    DECLARE in_MotivoRejeicao TEXT;
    SET in_MotivoRejeicao = JSON_VALUE(in_Arguments, '$.MotivoRejeicao');
    
    -- 1. Espoletar procedimentos BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> (
      "DocumentoRejeitado",
      CONCAT("{",
        CONCAT_WS(",",
          CONCAT_WS(":", CONCAT('"', "DocId", '"'), in_DocId),
          CONCAT_WS(":", CONCAT('"', "Extra", '"'), in_Arguments)
        ),
      "}")
    );
    
    -- 2. Executar a acção (espoletar procedimentos PROCESSING)
    CALL <?=tableNameWithModule("TriggerProcessingEvent","SYS")?> (in_DocId, in_MotivoRejeicao);
      
    -- 3. Espoletar procedimentos AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> (
      "DocumentoRejeitado",
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
INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoRejeitado', 'Quando um documento é rejeitado (i.e. passa um estado para trás no "workflow" programado)');
