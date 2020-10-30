-- --------------------
--  Module: Accounting EventListner: onBeforeDocumentoApagado
--
--  Descrição: chama o stored procedure adequado ao tipo do documento que foi apagado
-- --------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Options JSON)
  BEGIN
    DECLARE in_DocId INT;
    DECLARE v_DocTipo TEXT;
    
    SET in_DocId = JSON_VALUE(in_Options, '$.DocId');
    SET v_DocTipo = (SELECT Tipo FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_DocId);
   
    IF v_DocTipo = "ComprovativoPagamento" THEN
      CALL <?=tableNameWithModule("ComprovativoPagamentoApagar")?> (in_DocId);
      
    END IF;
    
  END;
  
//

DELIMITER ;
 
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, BeforeStoredProcedure) VALUES ('DocumentoApagado','<?=tableNameWithModule()?>');