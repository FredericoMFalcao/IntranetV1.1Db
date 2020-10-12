DROP PROCEDURE IF EXISTS FaturaFornecedorRejeitar;

DELIMITER //
-- ------------------------
--  Tabela (virtual): FaturasFornecedor Funcao: Rejeitar
--
--  Descrição: Mover um "documento" específico um estado para trás, acrescentado um descritivo da rejeição
-- ------------------------
CREATE PROCEDURE FaturaFornecedorRejeitar (IN in_FaturaId INT, IN in_Extra JSON)

  BEGIN
    DECLARE in_MotivoRejeicao TEXT;
    SET in_MotivoRejeicao = JSON_VALUE(in_Extra, '$.MotivoRejeicao');


    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId AND Tipo = 'FaturaFornecedor')
      THEN signal sqlstate '20000' set message_text = 'Fatura de fornecedor inexistente.';
    END IF;


    -- 1. Alterar dados do documento acrescentando a rejeição e respectivo motivo    
    UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
    SET Extra = JSON_SET(Extra,
      '$.Rejeitada', 1,
      '$.MotivoRejeicao', in_MotivoRejeicao
    )
    WHERE Id = in_FaturaId;
    

    -- 2. Alterar estado da fatura (e outras alterações necessárias)
    
    -- 2.1. 'PorClassificarAnalitica' -> 'PorClassificarFornecedor'
    IF v_Estado = 'PorClassificarAnalitica' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Estado = 'PorClassificarFornecedor',
      WHERE Id = in_FaturaId;


    -- 2.2. 'PorRegistarContabilidade' -> 'PorClassificarAnalitica'
    ELSEIF v_Estado = 'PorRegistarContabilidade' THEN
    
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Estado = 'PorClassificarAnalitica',
      WHERE Id = in_FaturaId;
      
      -- Apagar lançamentos
      DELETE FROM <?=tableNameWithModule("Lancamentos")?>
      WHERE DocNumSerie = (SELECT NumSerie FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);


    -- 2.3. 'PorAnexarCPagamento' -> 'PorRegistarContabilidade'
    ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Estado = 'PorRegistarContabilidade',
      WHERE Id = in_FaturaId;


    -- 2.4. 'PorRegistarPagamentoContab' -> 'PorAnexarCPagamento'
    ELSEIF v_Estado = 'PorRegistarPagamentoContab' THEN 
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Estado = 'PorAnexarCPagamento',
      WHERE Id = in_FaturaId;
      
      -- Apagar lançamentos
      DELETE FROM <?=tableNameWithModule("Lancamentos")?>
      WHERE DocNumSerie = (SELECT NumSerie FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);
      
      -- Voltar a lançar dívida de fornecedor e custos:
      CALL LancamentosLancarCustoFornecedor  (
        (SELECT NumSerie FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId),
        (SELECT JSON_VALUE(Extra, '$.ClassificacaoAnalitica') FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId)
      );


    END IF;

  END;
  
//

DELIMITER ;
