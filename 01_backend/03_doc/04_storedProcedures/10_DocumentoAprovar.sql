-- ------------------------
--  Tabela (sql): Documentos Funcao: Aprovar
--
--  Descrição: Mover um "documento" específico um estado para a frente no "workflow" programado
-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
    DECLARE v_DocTipo TEXT;
    DECLARE v_Estado TEXT;
    SET v_DocTipo = (SELECT Tipo FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
  
    -- 1. Alterar estado do documento
    -- --------------------------
    
    -- 1.1 Espoletar evento BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> ("DocumentoAprovado",JSON_OBJECT("DocId", in_DocId, "Extra", in_Arguments));
    
    -- 1.2 Executar acção
    
      -- 1.2.1 Alterar o estado do documento
      
        -- 1.2.1.1 Fatura de fornecedor
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
          
        -- 1.2.1.2 Comprovativo de pagamento
        ELSEIF v_DocTipo = 'ComprovativoPagamento' THEN
          UPDATE <?=tableNameWithModule("Documentos")?>  
          SET Estado = 'Concluido'
          WHERE Id = in_DocId;
          
        END IF;
      
      -- 1.2.2 Se o documento tinha sido rejeitado, reverter essa condição
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Extra = JSON_SET(Extra, '$.Rejeitado', 0, '$.MotivoRejeicao', NULL)
      WHERE Id = in_DocId; 
    
    -- 1.3 Espoletar evento AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> ("DocumentoAprovado",JSON_OBJECT("DocId", in_DocId, "Extra", in_Arguments));

  END;
  
//

DELIMITER ;

INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoAprovado', 'Quando um documento é aprovado (i.e. passa um estado para a frente no "workflow" programado)');
