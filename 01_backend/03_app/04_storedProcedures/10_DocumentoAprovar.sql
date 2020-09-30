DROP PROCEDURE IF EXISTS DocumentoAprovar;

DELIMITER //

CREATE PROCEDURE DocumentoAprovar (
  IN _FaturaId                 INT,
  
  -- Inputs para classificar fornecedor:
  IN _NumSerie                 TEXT,
  IN _NumFatura                TEXT,
  IN _Projeto                  TEXT,
  IN _DataFatura               DATE,
  IN _DataRecebida             DATE,
  IN _PeriodoFaturacao         TEXT,  -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
  IN _DataValidade             DATE,
  IN _FornecedorCodigo         TEXT,
  IN _Valor                    TEXT,  -- e.g. {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase":0.00,"Iva":0.00}}
  IN _Moeda                    TEXT,
  IN _Descricao                TEXT,
  IN _ImpostoConsumo           DECIMAL(18,2),
  IN _Amortizacao              BOOLEAN,
  
  -- Inputs para classificar analítica:
  IN _ClassificacaoAnalitica   TEXT,  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
  
  -- Inputs para anexar comprovativo de pagamento:
  IN ComprovativoPagamentoId   INT
)

  BEGIN
    DECLARE Estado TEXT;
    SET Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos")?> WHERE Id = _FaturaId);

    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos")?> WHERE Id = _FaturaId AND Tipo = 'FaturaFornecedor')
      THEN signal sqlstate '20000' set message_text = 'Fatura de fornecedor inexistente.';
    END IF;

    -- 1. 'PorClassificarFornecedor' -> 'PorClassificarAnalitica'
    IF Estado = 'PorClassificarFornecedor' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET
        NumSerie = _NumSerie,
        Estado = 'PorClassificarAnalitica',
        Extra = JSON_SET(Extra, 
          '$.NumFatura', _NumFatura,
          '$.ProjetoProvisorio', _Projeto,
          '$.DataFatura', _DataFatura,
          '$.DataRecebida', _DataRecebida,
          '$.PeriodoFaturacao', _PeriodoFaturacao,
          '$.DataValidade', _DataValidade,
          '$.FornecedorCodigo', _FornecedorCodigo,
          '$.Valor', _Valor,
          '$.Moeda', _Moeda,
          '$.Descricao', _Descricao,
          '$.ImpostoConsumo', _ImpostoConsumo,
          '$.Amortizacao', _Amortizacao
        ) 
      WHERE Id = _FaturaId;

    -- 2. 'PorClassificarAnalitica' -> 'PorRegistarContabilidade'
    ELSEIF Estado = 'PorClassificarAnalitica' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = 'PorRegistarContabilidade'
      WHERE Id = _FaturaId;

    -- 3. 'PorRegistarContabilidade' -> 'PorAnexarCPagamento'
    ELSEIF Estado = 'PorRegistarContabilidade' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = 'PorAnexarCPagamento'
      WHERE Id = _FaturaId;

    -- 4. 'PorAnexarCPagamento' -> 'PorRegistarPagamentoContab'
    ELSEIF Estado = 'PorAnexarCPagamento' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET
        Estado = 'PorRegistarPagamentoContab',
        Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', _ComprovativoPagamentoId)
      WHERE Id = _FaturaId;

    -- 5. 'PorRegistarPagamentoContab' -> 'Concluido'
    ELSEIF Estado = 'PorRegistarPagamentoContab' THEN
      UPDATE <?=tableNameWithModule("Documentos")?> 
      SET Estado = 'Concluido'
      WHERE Id = _FaturaId;

    END IF;

  END;
  
//

DELIMITER ;
