-- ------------------------
-- Tabela (virtual): FaturasFornecedor  Funcao: Criar 
--
-- Descrição: faz update de um documento da tabela DOC_Documentos com os campos específicos de faturas de fornecedor
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_Arguments JSON)

  BEGIN
    DECLARE in_FileId TEXT;
    DECLARE in_DocId INT;
    SET in_FileId = JSON_VALUE(in_Arguments, '$.FileId');
    SET in_DocId = (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE FileId = in_FileId);

    UPDATE <?=tableNameWithModule("Documentos","DOC")?>
    SET Tipo = 'FaturaFornecedor', Estado = 'PorClassificarFornecedor'
    WHERE Id = in_DocId;
  
  END;
  
//

DELIMITER ;
