-- ------------------------
--  Module: Documentos  EventListner: onProcessingDocumentoRejeitado
--
--  Descrição: altera o estado de um documento (para trás no workflow)
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, in_MotivoRejeicao TEXT)

  BEGIN
    DECLARE v_Estado TEXT;
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId); 

    -- 1. Acrescentar a rejeição (e respectivo motivo) aos dados do documento
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Extra = JSON_SET(Extra, '$.Rejeitado', 1, '$.MotivoRejeicao', in_MotivoRejeicao);
      
    -- 2. Alterar o estado do documento
    IF v_Estado = 'PorClassificarAnalitica' THEN
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Estado = 'PorClassificarFornecedor'
      WHERE Id = in_DocId;
   
    ELSEIF v_Estado = 'PorRegistarContabilidade' THEN
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Estado = 'PorClassificarAnalitica'
      WHERE Id = in_DocId;
   
    ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Estado = 'PorRegistarContabilidade'
      WHERE Id = in_DocId;
   
    ELSEIF v_Estado = 'PorRegistarPagamentoContab' THEN 
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Estado = 'PorAnexarCPagamento'
      WHERE Id = in_DocId;
      
    END IF;

  END;
  
//

DELIMITER ;

-- Inserir Event Handler:
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, ProcessingStoredProcedure) VALUES ('DocumentoRejeitado', 'DOC_onProcessingDocumentoRejeitado');
