DROP PROCEDURE IF EXISTS ComprovativosPagamentoCriar;

DELIMITER //

CREATE PROCEDURE ComprovativosPagamentoCriar (IN in_Extra JSON)
  BEGIN
    DECLARE in_DocTipo TEXT;
    DECLARE in_FileId TEXT;
    DECLARE in_ContaBancaria TEXT;
    SET in_DocTipo = JSON_VALUE(in_Extra, '$.DocTipo');
    SET in_FileId = JSON_VALUE(in_Extra, '$.FileId');
    SET in_ContaBancaria = JSON_VALUE(in_Extra, '$.ContaBancaria');

    IF in_DocTipo = 'ComprovativoPagamento' THEN
      INSERT INTO <?=tableNameWithModule("Documentos","DOC")?> (Tipo, Estado, FileId) 
      VALUES (in_DocTipo, 'Concluido', in_FileId);
      UPDATE <?=tableNameWithModule("Documentos","DOC")?>
      SET Extra = JSON_SET(Extra, '$.ContaBancaria', in_ContaBancaria)
      WHERE FileId = in_FileId;
      
    END IF;
  
  END;
  
//

DELIMITER ;
