DROP PROCEDURE IF EXISTS DocumentoAprovar;

DELIMITER //

-- ------------------------
--  Tabela (sql): Documentos Funcao: Aprovar
--
--  Descrição: Mover um "documento" específico um estado para a frente no "workflow" programado
-- ------------------------

CREATE PROCEDURE DocumentoAprovar (IN in_Extra JSON)

  BEGIN
    DECLARE in_DocId INT;
    SET in_DocId = JSON_VALUE(in_Extra, '$.DocId');
  
    IF EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId AND Tipo = 'FaturaFornecedor') THEN
      CALL FaturaFornecedorAprovar (in_Extra);
      
    END IF;

  END;
  
//

DELIMITER ;
