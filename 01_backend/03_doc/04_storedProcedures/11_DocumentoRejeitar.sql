DROP PROCEDURE IF EXISTS DocumentoRejeitar;

DELIMITER //
-- ------------------------
--  Tabela (sql): Documento Funcao: Rejeitar
--
-- Descrição: Move um "documento" específico um estado para trás no "workflow" programado 
--            Extra:
--                (1) Chama a função correspondente para o tipo de documento em questão
-- ------------------------
CREATE PROCEDURE DocumentoRejeitar (IN in_DocId INT, IN in_Extra JSON)

  BEGIN
  
    IF EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_DocId AND Tipo = 'FaturaFornecedor') THEN
      CALL FaturaFornecedorRejeitar (in_DocId, in_Extra);
      
    END IF;

  END;
  
//

DELIMITER ;
