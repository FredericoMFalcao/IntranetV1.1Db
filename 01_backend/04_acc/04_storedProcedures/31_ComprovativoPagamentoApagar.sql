DROP PROCEDURE IF EXISTS ComprovativoPagamentoApagar;

DELIMITER //
-- ------------------------
--  Tabela (virtual): ComprovativoPagamento Funcao: Apagar
--
-- Descrição: apaga um "documento", i.e. uma entrada na tabela sql de documentos
--            Por consequência (manual / não implícita):
--                (1) Elimina a associação das faturas que referenciavam este comprovativo de pagamento (i.e. set null)
--                (2) Elimina os lançamentos contabilísticos associados a este comprovativo de pagamento
-- ------------------------
CREATE PROCEDURE ComprovativoPagamentoApagar (IN in_ComprovativoPagamentoId INT)

  BEGIN

    -- Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_ComprovativoPagamentoId AND Tipo = 'ComprovativoPagamento')
      THEN signal sqlstate '23000' set message_text = 'Comprovativo de pagamento inexistente.';
      
    ELSE
   
      -- Apagar o comprovativo de pagamento da tabela de documentos (provisório)
      DELETE FROM <?=tableNameWithModule("Documentos","DOC")?>
      WHERE Id = in_ComprovativoPagamentoId;
      
      -- Apagar lançamentos
      DELETE FROM <?=tableNameWithModule("Lancamentos")?>
      WHERE DocNumSerie = (
        SELECT NumSerie
        FROM <?=tableNameWithModule("Documentos","DOC")?>
        WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId
      );
      
      -- Voltar a lançar dívida de fornecedor e custos
      CALL LancamentosLancarCustoFornecedor (
        (SELECT NumSerie
        FROM <?=tableNameWithModule("Documentos","DOC")?>
        WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId
        ),
        (SELECT JSON_VALUE(Extra, '$.ClassificacaoAnalitica')
        FROM <?=tableNameWithModule("Documentos","DOC")?>
        WHERE Id = in_FaturaId
        )
      );
      
      -- Eliminar a associação das faturas que referenciavam este comprovativo de pagamento
      UPDATE <?=tableNameWithModule("Documentos","DOC")?>
      SET Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', 0)
      WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId;
      
      
    END IF;

  END;
  
//

DELIMITER ;
