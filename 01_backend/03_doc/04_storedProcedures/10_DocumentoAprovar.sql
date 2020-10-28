DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- ------------------------
--  Tabela (sql): Documentos Funcao: Aprovar
--
--  Descrição: Mover um "documento" específico um estado para a frente no "workflow" programado
-- ------------------------

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Extra JSON)

  BEGIN
  
    IF EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId AND Tipo = 'FaturaFornecedor') THEN
      CALL <?=tableNameWithModule("FaturaFornecedorAprovar","ACC")?> (in_DocId, in_Extra);
      
    END IF;

  END;
  
//

DELIMITER ;
