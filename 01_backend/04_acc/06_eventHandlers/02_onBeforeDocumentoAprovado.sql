-- --------------------
--  Module: Accounting EventListner: onBeforeDocumentoAprovado
--
--  Descrição: chama o stored procedure adequado ao tipo do documento que foi aprovado
-- --------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Options JSON)
  BEGIN
    DECLARE in_DocId INT;
	DECLARE in_Extra JSON;
    DECLARE v_DocTipo TEXT;
	
	SET in_DocId = JSON_VALUE(in_Options, '$.DocId');
	SET in_Extra = JSON_EXTRACT(in_Options, '$.Arguments');
    SET v_DocTipo = (SELECT Tipo FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_DocId);
   
    IF v_DocTipo = "FaturaFornecedor" THEN
      CALL <?=tableNameWithModule("FaturaFornecedorAprovar")?> (in_DocId, in_Extra);
      
    END IF;
    
  END;
  
//

DELIMITER ;
 
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, BeforeStoredProcedure) VALUES ('DocumentoAprovado','<?=tableNameWithModule()?>');
