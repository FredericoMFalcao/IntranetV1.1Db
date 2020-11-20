DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- ------------------------
--  Tabela (virtual): ComprovativosPagamento Funcao: Criar 
--
-- Descrição: faz update de um documento da tabela DOC_Documentos com os campos específicos de comprovativos de pagamento
-- ------------------------

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Arguments JSON)
  BEGIN
    DECLARE in_DocId TEXT;
    SET in_DocId = JSON_VALUE(in_Arguments, '$.Id');

    UPDATE <?=tableNameWithModule("Documentos","DOC")?>
    SET Tipo = 'ComprovativoPagamento', Estado = 'PorAprovar'
    WHERE Id = in_DocId;
  
  END;
  
//

DELIMITER ;
