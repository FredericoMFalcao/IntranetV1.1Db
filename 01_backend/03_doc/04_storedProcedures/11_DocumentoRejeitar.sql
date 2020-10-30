-- ------------------------
-- Tabela (sql): Documento Funcao: Rejeitar
--
-- Descrição: Move um "documento" específico um estado para trás no "workflow" programado

-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Arguments JSON)

  BEGIN
    DECLARE in_MotivoRejeicao TEXT;
    DECLARE v_Estado TEXT;
    SET in_MotivoRejeicao = JSON_VALUE(in_Arguments, '$.MotivoRejeicao');
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId); 
    
    -- 1. Alterar estado do documento
    -- --------------------------
    
    -- 1.1 Espoletar evento BEFORE
    CALL <?=tableNameWithModule("TriggerBeforeEvent","SYS")?> ("DocumentoRejeitado",JSON_OBJECT("DocId", in_DocId, "Extra", in_Arguments));
    
    -- 1.2 Executar acção
    
      -- 1.2.1 Alterar dados do documento, acrescentando a rejeição e respectivo motivo    
      UPDATE <?=tableNameWithModule("Documentos")?>
      SET Extra = JSON_SET(Extra, '$.Rejeitado', 1, '$.MotivoRejeicao', in_MotivoRejeicao);
      
      -- 1.2.2 Alterar o estado do documento
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
      
    -- 1.3 Espoletar evento AFTER
    CALL <?=tableNameWithModule("TriggerAfterEvent","SYS")?> ("DocumentoRejeitado",JSON_OBJECT("DocId", in_DocId, "Extra", in_Arguments));

  END;
  
//

DELIMITER ;

INSERT INTO <?=tableNameWithModule("Events","SYS")?> (Name, Description) VALUES ('DocumentoRejeitado', 'Quando um documento é rejeitado (i.e. passa um estado para trás no "workflow" programado)');
