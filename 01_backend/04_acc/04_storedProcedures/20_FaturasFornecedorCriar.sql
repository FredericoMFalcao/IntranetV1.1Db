DROP PROCEDURE IF EXISTS FaturasFornecedorCriar;

DELIMITER //

-- ------------------------
--  Tabela (virtual): FaturasFornecedor Funcao: Criar 
--
-- Descrição: cria um "documento" novo, i.e. entrada na tabela sql de documentos
-- ------------------------


CREATE PROCEDURE FaturasFornecedorCriar (IN in_Extra JSON)
  BEGIN
    DECLARE in_DocTipo TEXT;
    DECLARE in_FileId TEXT;
    SET in_DocTipo = JSON_VALUE(in_Extra, '$.DocTipo');
    SET in_FileId = JSON_VALUE(in_Extra, '$.FileId');

    IF in_DocTipo = 'FaturaFornecedor' THEN
      INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (Tipo, Estado, FileId) 
      VALUES (in_DocTipo, 'PorClassificarFornecedor', in_FileId);
      
    END IF;
  
  END;
  
//

DELIMITER ;
