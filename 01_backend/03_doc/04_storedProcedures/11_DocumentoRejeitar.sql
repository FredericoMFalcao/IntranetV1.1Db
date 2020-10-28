DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //
-- ------------------------
--  Tabela (sql): Documento Funcao: Rejeitar
--
-- Descrição: Move um "documento" específico um estado para trás no "workflow" programado 
--            Extra:
--                (1) Chama a função correspondente para o tipo de documento em questão
-- ------------------------
CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_DocId INT, IN in_Extra JSON)

  BEGIN
  
    IF EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId AND Tipo = 'FaturaFornecedor') THEN
      CALL <?=tableNameWithModule("FaturaFornecedorRejeitar","ACC")?> (in_DocId, in_Extra);
      
    END IF;

  END;
  
//

DELIMITER ;
