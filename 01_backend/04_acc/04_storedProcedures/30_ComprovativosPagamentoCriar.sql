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
    DECLARE in_NumSerie TEXT; -- TEMPORÁRIO: falta definir em que fase é atribuído um 'NumSerie' ao comprovativo de pagamento
    DECLARE in_ContaBancaria TEXT;
    DECLARE in_DataPagamento DATE;
    SET in_DocId = JSON_VALUE(in_Arguments, '$.Id');
    SET in_NumSerie = JSON_VALUE(JSON_EXTRACT(in_Arguments, '$.Extra'), '$.NumSerie');
    SET in_ContaBancaria = JSON_VALUE(JSON_EXTRACT(in_Arguments, '$.Extra'), '$.ContaBancaria');
    SET in_DataPagamento = JSON_VALUE(JSON_EXTRACT(in_Arguments, '$.Extra'), '$.DataPagamento');

    UPDATE <?=tableNameWithModule("Documentos","DOC")?>
    SET 
      Tipo = 'ComprovativoPagamento', 
      Estado = 'Concluido',
      Extra = JSON_SET(Extra, '$.ContaBancaria', in_ContaBancaria, '$.DataPagamento', in_DataPagamento)
    WHERE Id = in_DocId;
  
  END;
  
//

DELIMITER ;
