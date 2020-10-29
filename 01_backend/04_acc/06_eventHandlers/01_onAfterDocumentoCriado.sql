-- --------------------
--  Module: Accounting EventListner: onAfterDocumentoCriado 
--
--  Descrição: chama o stored procedure adequado ao tipo do documento que foi criado
-- --------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Options JSON)
  BEGIN
    DECLARE in_DocTipo TEXT;
    SET in_DocTipo = JSON_VALUE(in_Options, '$.Tipo'); 
   
    IF in_DocTipo = "FaturaFornecedor" THEN
      CALL <?=tableNameWithModule("FaturasForncedorCriar")?> (in_Options);
      
    ELSEIF in_DocTipo = "ComprovativoPagamento" THEN
      CALL <?=tableNameWithModule("ComprovativosPagamentoCriar")?> (in_Options);
      
    END IF;
    
  END;
  
//

DELIMITER ;
 
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, AfterStoredProcedure) VALUES ('DocumentoCriado','<?=tableNameWithModule()?>');
