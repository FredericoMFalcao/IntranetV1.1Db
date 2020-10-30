-- ------------------------
--  Tabela (virtual): ComprovativoPagamento Funcao: Apagar
--
-- Descrição: Faz as alterações necessárias antes de ser apagado um comprovativo de pagamento:
--                (1) Elimina os lançamentos contabilísticos associados a este comprovativo de pagamento
--                (2) Elimina a associação das faturas que referenciavam este comprovativo de pagamento (i.e. set null)
-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_ComprovativoPagamentoId INT)

  BEGIN
  
      -- Apagar lançamentos
      DELETE FROM <?=tableNameWithModule("Lancamentos")?>
      WHERE DocNumSerie = (
        SELECT NumSerie
        FROM <?=tableNameWithModule("Documentos","DOC")?>
        WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId
      );
      
      -- Voltar a lançar dívida de fornecedor e custos
      CALL <?=tableNameWithModule("LancamentosLancarCustoFornecedor")?> (
        (SELECT NumSerie
        FROM <?=tableNameWithModule("Documentos","DOC")?>
        WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId
        ),
        (SELECT JSON_VALUE(Extra, '$.ClassificacaoAnalitica')
        FROM <?=tableNameWithModule("Documentos","DOC")?>
        WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId
        )
      );
      
      -- Eliminar a associação das faturas que referenciavam este comprovativo de pagamento
      UPDATE <?=tableNameWithModule("Documentos","DOC")?>
      SET Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', 0)
      WHERE JSON_VALUE(Extra, '$.ComprovativoPagamentoId') = in_ComprovativoPagamentoId;

  END;
  
//

DELIMITER ;
