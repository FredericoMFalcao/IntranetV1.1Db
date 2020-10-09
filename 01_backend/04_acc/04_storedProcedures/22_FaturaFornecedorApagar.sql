DROP PROCEDURE IF EXISTS FaturaFornecedorApagar;

DELIMITER //

-- ------------------------
--  Tabela (virtual): FaturasFornecedor Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
--            Por consequência (implicita - foreign key):
--                (1) Apaga todos os lancamentos contabílisticos associados a esta fatura
-- ------------------------
CREATE PROCEDURE FaturaFornecedorApagar (IN in_FaturaId INT)

  BEGIN

	IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId AND Tipo = 'FaturaFornecedor')
	  THEN signal sqlstate '23000' set message_text = 'Fatura de fornecedor inexistente.';
	ELSE
	  DELETE FROM <?=tableNameWithModule("Documentos","DOC")?>
	  WHERE Id = in_FaturaId;
	END IF;

  END;
  
//

DELIMITER ;
