-- ------------------------
-- Tabela (sql): Documentos Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
  
    -- 1. Apagar o documento
    -- --------------------------
    
    -- 1.1 Espoletar evento BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> ("DocumentoApagado",JSON_OBJECT("DocId", in_DocId, "Extra", in_Arguments));
    
    -- 1.2 Executar acção
    DELETE FROM <?=tableNameWithModule("Documentos")?>
    WHERE Id = in_DocId;
    
    -- 1.3 Espoletar evento AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> ("DocumentoApagado",JSON_OBJECT("DocId", in_DocId, "Extra", in_Arguments));

  END;
  
//

DELIMITER ;

INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoApagado', 'Quando um documento contabilístico é apagado');