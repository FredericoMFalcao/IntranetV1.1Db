DROP PROCEDURE IF EXISTS DocumentoApagar;

DELIMITER //

-- ------------------------
--  Tabela (sql): Documento Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
--            Por consequência:
--                (1) Chama o processo apropriado para cada tipo de documento
-- ------------------------
CREATE PROCEDURE DocumentoApagar (IN in_DocId INT)

  BEGIN
    DECLARE v_TipoDoc TEXT;
	SET v_TipoDoc = (SELECT Tipo FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId);
  
    IF v_TipoDoc = 'FaturaFornecedor' THEN
	  CALL FaturaFornecedorApagar (in_DocId);
	  
	ELSEIF v_TipoDoc = 'ComprovativoPagamento' THEN
	  CALL ComprovativoPagamentoApagar (in_DocId);
      
    END IF;

  END;
  
//

DELIMITER ;
