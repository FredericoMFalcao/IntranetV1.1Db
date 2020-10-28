DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- ------------------------
--  Tabela (virtual): ComprovativosPagamento Funcao: Criar 
--
-- Descrição: cria um "documento" novo, i.e. entrada na tabela sql de documentos
-- ------------------------
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_Extra JSON)
  BEGIN
    DECLARE in_NumSerie TEXT;
    DECLARE in_DocTipo TEXT;
    DECLARE in_FileId TEXT;
    DECLARE in_ContaBancaria TEXT;
    SET in_NumSerie = JSON_VALUE(in_Extra, '$.NumSerie');
    SET in_DocTipo = JSON_VALUE(in_Extra, '$.DocTipo');
    SET in_FileId = JSON_VALUE(in_Extra, '$.FileId');
    SET in_ContaBancaria = JSON_VALUE(in_Extra, '$.ContaBancaria');

    IF in_DocTipo = 'ComprovativoPagamento' THEN
      INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (NumSerie, Tipo, Estado, FileId) 
      VALUES (in_NumSerie, in_DocTipo, 'Concluido', in_FileId);
      UPDATE <?=tableNameWithModule("Documentos","DOC")?>
      SET Extra = JSON_SET(Extra, '$.ContaBancaria', in_ContaBancaria)
      WHERE FileId = in_FileId;
      
    END IF;
  
  END;
  
//

DELIMITER ;
