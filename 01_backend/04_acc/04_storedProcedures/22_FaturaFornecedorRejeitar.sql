-- ------------------------
-- Tabela (virtual): FaturasFornecedor Funcao: Rejeitar
--
-- Descrição: antes do estado de uma fatura (de fornecedor) passar para trás no "workflow" previamente definido,
--                apaga (se necessário) os lançamentos contabílisticos referentes à última aprovação
-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_FaturaId INT, IN in_Extra JSON)

  BEGIN
    DECLARE in_MotivoRejeicao TEXT;
    DECLARE v_Estado TEXT;
    DECLARE v_NumSerie TEXT;
    SET in_MotivoRejeicao = JSON_VALUE(in_Extra, '$.MotivoRejeicao');
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);
    SET v_NumSerie = (SELECT NumSerie FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);

    
    -- 1. 'PorClassificarAnalitica' -> 'PorClassificarFornecedor'


    -- 2. 'PorRegistarContabilidade' -> 'PorClassificarAnalitica'
    IF v_Estado = 'PorRegistarContabilidade' THEN
    
      -- Apagar lançamentos
      DELETE FROM <?=tableNameWithModule("Lancamentos")?>
      WHERE DocNumSerie = v_NumSerie;

    -- 3. 'PorAnexarCPagamento' -> 'PorRegistarContabilidade'


    -- 4. 'PorRegistarPagamentoContab' -> 'PorAnexarCPagamento'
    ELSEIF v_Estado = 'PorRegistarPagamentoContab' THEN 
    
      -- Apagar lançamentos
      DELETE FROM <?=tableNameWithModule("Lancamentos")?>
      WHERE DocNumSerie = v_NumSerie;
      
      -- Voltar a lançar dívida de fornecedor e custos:
      CALL <?=tableNameWithModule("LancamentosLancarCustoFornecedor")?>  (
        v_NumSerie,
        (SELECT JSON_VALUE(Extra, '$.ClassificacaoAnalitica') FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId)
      );


    END IF;

  END;
  
//

DELIMITER ;
