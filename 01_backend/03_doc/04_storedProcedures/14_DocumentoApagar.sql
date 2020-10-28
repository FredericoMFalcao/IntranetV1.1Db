DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- ------------------------
--  Tabela (sql): Documento Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
--            Por consequência:
--                (1) Chama o processo apropriado para cada tipo de documento (antes de apagar)
-- ------------------------
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT)

  BEGIN
    DECLARE v_TipoDoc TEXT;
    SET v_TipoDoc = (SELECT Tipo FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
  
    -- Chamar processo apropriado:
    IF v_TipoDoc = 'ComprovativoPagamento' THEN
      CALL <?=tableNameWithModule("ComprovativoPagamentoApagar","ACC")?> (in_DocId);
    END IF;
    
    -- Apagar o documento:
    DELETE FROM <?=tableNameWithModule("Documentos")?>
    WHERE Id = in_DocId;

  END;
  
//

DELIMITER ;
