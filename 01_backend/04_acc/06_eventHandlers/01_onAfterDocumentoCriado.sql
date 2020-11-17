-- --------------------
--  Module: Accounting EventListner: onAfterDocumentoCriado 
--
--  Descrição: chama o stored procedure adequado ao tipo do documento que foi criado
--               1. baseado na caixa de correio onde o ficheiro foi recebido
--               2. o stored procedure chamado reclassifica o documento para o tipo adequado
-- --------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Options JSON)
  BEGIN
    DECLARE in_ReceivedAtEmailInbox TEXT DEFAULT JSON_VALUE(in_Options, '$.Extra.FileExtra.receivedAtEmailInbox');
   
    IF LOWER(SUBSTRING_INDEX(in_ReceivedAtEmailInbox, '@', 1)) = "faturasfornecedor" THEN
      CALL <?=tableNameWithModule("FaturasFornecedorCriar")?> (in_Options);
      
    ELSEIF LOWER(SUBSTRING_INDEX(in_ReceivedAtEmailInbox, '@', 1)) = "comprovativospagamento" THEN
      CALL <?=tableNameWithModule("ComprovativosPagamentoCriar")?> (in_Options);
      
    END IF;
    
  END;
  
//

DELIMITER ;
 
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, AfterStoredProcedure) VALUES ('DocumentoCriado','<?=tableNameWithModule()?>');
