DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- ------------------------
--  Tabela (virtual): FaturasFornecedor Funcao: Criar 
--
-- Descrição: faz update de um documento da tabela DOC_Documentos com os campos específicos de faturas de fornecedor
-- ------------------------

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Arguments JSON)
  BEGIN
    DECLARE in_DocId TEXT;
    SET in_DocId = JSON_VALUE(in_Arguments, '$.Id');

    UPDATE <?=tableNameWithModule("Documentos","DOC")?>
    SET Tipo = 'FaturaFornecedor', Estado = 'PorClassificarFornecedor'
    WHERE Id = in_DocId;
  
  END;
  
//

DELIMITER ;
