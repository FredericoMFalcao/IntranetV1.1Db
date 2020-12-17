-- ------------------------
--  Module: Documentos | EventListner: onProcessingDocumentoAprovado
--
--  Descrição: altera o estado de um documento (para a frente no workflow)
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_Options TEXT)

  BEGIN
    DECLARE in_DocId INT;
    DECLARE v_DocTipo TEXT;
    DECLARE v_Estado TEXT;
    SET in_DocId = JSON_VALUE(in_Options, '$.DocId');
    SET v_DocTipo = (SELECT Tipo FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);

    -- 1. Alterar o estado do documento
      
      -- 1.1. Fatura de fornecedor
      IF v_DocTipo = 'FaturaFornecedor' THEN

        IF v_Estado = 'PorClassificarFornecedor' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'PorClassificarAnalitica'
          WHERE Id = in_DocId;
      
        ELSEIF v_Estado = 'PorClassificarAnalitica' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'PorRegistarContabilidade'
          WHERE Id = in_DocId;
      
        ELSEIF v_Estado = 'PorRegistarContabilidade' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'PorAnexarCPagamento'
          WHERE Id = in_DocId;
      
        ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'PorRegistarPagamentoContab'
          WHERE Id = in_DocId;
      
        ELSEIF v_Estado = 'PorRegistarPagamentoContab' THEN
          UPDATE <?=tableNameWithModule("Documentos")?>  
          SET Estado = 'Concluido'
          WHERE Id = in_DocId;
          
        END IF;
        
      -- 1.2. Comprovativo de pagamento
      ELSEIF v_DocTipo = 'ComprovativoPagamento' THEN
        UPDATE <?=tableNameWithModule("Documentos")?>  
        SET Estado = 'Concluido'
        WHERE Id = in_DocId;
      
      -- 1.3. Fatura de cliente
      ELSEIF v_DocTipo = 'FaturaCliente' THEN
      
        IF v_Estado = 'PorClassificarCliente' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'PorClassificarAnalitica'
          WHERE Id = in_DocId;
      
        ELSEIF v_Estado = 'PorClassificarAnalitica' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'PorAnexarCPagamento'
          WHERE Id = in_DocId;
      
        ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
          UPDATE <?=tableNameWithModule("Documentos")?> 
          SET Estado = 'Concluido'
          WHERE Id = in_DocId;
          
        END IF;
        
      END IF;
      
    -- 2. Se o documento tinha sido rejeitado, reverter essa condição
    IF (SELECT JSON_VALUE(Extra, '$.Rejeitado') FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId) = 1 THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Extra = JSON_SET(Extra, '$.Rejeitado', 0, '$.MotivoRejeicao', NULL)
      WHERE Id = in_DocId; 
      
    END IF;
    
  END;
  
//

DELIMITER ;

-- Inserir Event Handler:
INSERT INTO <?=tableNameWithModule("EventHandlers","SYS")?> (EventName, ProcessingStoredProcedure) VALUES ('DocumentoAprovado', 'DOC_onProcessingDocumentoAprovado');
