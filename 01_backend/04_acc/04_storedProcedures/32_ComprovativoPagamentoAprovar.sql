DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

-- ------------------------
-- Tabela (virtual): ComprovativosPagamento Funcao: Aprovar 
--
-- Descrição: antes de um comprovativo de pagamento ser aprovado, acrescenta informação específica ao documento
-- ------------------------

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_ComprovativoPagamentoId INT, IN in_Extra JSON)
  BEGIN
    DECLARE in_NumSerie TEXT;
    DECLARE in_ContaBancaria TEXT;
    DECLARE in_DataPagamento DATE;
    SET in_NumSerie = JSON_VALUE(JSON_EXTRACT(in_Extra, '$.Extra'), '$.NumSerie');
    SET in_ContaBancaria = JSON_VALUE(JSON_EXTRACT(in_Extra, '$.Extra'), '$.ContaBancaria');
    SET in_DataPagamento = JSON_VALUE(JSON_EXTRACT(in_Extra, '$.Extra'), '$.DataPagamento');

    UPDATE <?=tableNameWithModule("Documentos","DOC")?>
    SET 
      NumSerie = in_NumSerie,
      Extra = JSON_SET(Extra, '$.ContaBancaria', in_ContaBancaria, '$.DataPagamento', in_DataPagamento)
    WHERE Id = in_ComprovativoPagamentoId;
  
  END;
  
//

DELIMITER ;
