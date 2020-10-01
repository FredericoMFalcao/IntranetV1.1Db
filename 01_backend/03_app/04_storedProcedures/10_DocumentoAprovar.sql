DROP PROCEDURE IF EXISTS DocumentoAprovar;

DELIMITER //

CREATE PROCEDURE DocumentoAprovar (
  IN in_FaturaId                 INT,
  
  -- Inputs para classificar fornecedor:
  IN in_NumSerie                 TEXT,
  IN in_NumFatura                TEXT,
  IN in_Projeto                  TEXT,
  IN in_DataFatura               DATE,
  IN in_DataRecebida             DATE,
  IN in_PeriodoFaturacao         TEXT,  -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
  IN in_DataValidade             DATE,
  IN in_FornecedorCodigo         TEXT,
  IN in_Valor                    TEXT,  -- e.g. {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase":0.00,"Iva":0.00}}
  IN in_Moeda                    TEXT,
  IN in_Descricao                TEXT,
  IN in_ImpostoConsumo           DECIMAL(18,2),
  IN in_Amortizacao              BOOLEAN,
  
  -- Inputs para classificar analítica:
  IN in_ClassificacaoAnalitica   TEXT,  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
  
  -- Inputs para anexar comprovativo de pagamento:
  IN in_ComprovativoPagamentoId   INT
)

  BEGIN
    DECLARE v_Estado TEXT;
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId);

    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId AND Tipo = 'FaturaFornecedor')
      THEN signal sqlstate '20000' set message_text = 'Fatura de fornecedor inexistente.';
    END IF;

    -- 1. 'PorClassificarFornecedor' -> 'PorClassificarAnalitica'
    IF v_Estado = 'PorClassificarFornecedor' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET
        NumSerie = in_NumSerie,
        Estado = 'PorClassificarAnalitica',
        Extra = JSON_SET(Extra, 
          '$.NumFatura', in_NumFatura,
          '$.ProjetoProvisorio', in_Projeto,
          '$.DataFatura', in_DataFatura,
          '$.DataRecebida', in_DataRecebida,
          '$.PeriodoFaturacao', in_PeriodoFaturacao,
          '$.DataValidade', in_DataValidade,
          '$.FornecedorCodigo', in_FornecedorCodigo,
          '$.Valor', in_Valor,
          '$.Moeda', in_Moeda,
          '$.Descricao', in_Descricao,
          '$.ImpostoConsumo', in_ImpostoConsumo,
          '$.Amortizacao', in_Amortizacao
        ) 
      WHERE Id = in_FaturaId;
      
      -- Lançar dívida de fornecedor e custos gerais:
      CALL LancamentosLancarCustoFornecedor (in_NumSerie, in_PeriodoFaturacao, in_FornecedorCodigo);

    -- 2. 'PorClassificarAnalitica' -> 'PorRegistarContabilidade'
    ELSEIF v_Estado = 'PorClassificarAnalitica' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = 'PorRegistarContabilidade'
      WHERE Id = in_FaturaId;
      
      -- Lançar custos específicos e anular custos gerais:
      CALL LancamentosReclassificarCusto  (in_NumSerie, in_ClassificacaoAnalitica);

    -- 3. 'PorRegistarContabilidade' -> 'PorAnexarCPagamento'
    ELSEIF v_Estado = 'PorRegistarContabilidade' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = 'PorAnexarCPagamento'
      WHERE Id = in_FaturaId;

    -- 4. 'PorAnexarCPagamento' -> 'PorRegistarPagamentoContab'
    ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET
        Estado = 'PorRegistarPagamentoContab',
        Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', in_ComprovativoPagamentoId)
      WHERE Id = in_FaturaId;

    -- 5. 'PorRegistarPagamentoContab' -> 'Concluido'
    ELSEIF v_Estado = 'PorRegistarPagamentoContab' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = 'Concluido'
      WHERE Id = in_FaturaId;

    END IF;

  END;
  
//

DELIMITER ;
