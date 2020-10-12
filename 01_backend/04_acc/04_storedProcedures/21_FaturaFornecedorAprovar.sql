DROP PROCEDURE IF EXISTS FaturaFornecedorAprovar;

DELIMITER //

-- ------------------------
--  Tabela (virtual): FaturaFornecedor Funcao: Aprovar
--
-- Descrição: move o estado de uma fatura (de fornecedor) para a frente no "workflow" previamente definido
--        Faz também:
--         (1) anexa informação extra que lhe é dada em cada passo
--         (2) chama o procedimento que faz os lançamentos contabílisticos relevantes em cada passo
-- ------------------------


CREATE PROCEDURE FaturaFornecedorAprovar (IN in_FaturaId INT, IN in_Extra JSON)

  BEGIN
    -- Inputs para classificar fornecedor:
    DECLARE in_NumSerie                   TEXT;
    DECLARE in_NumFatura                  TEXT;
    DECLARE in_Projeto                    TEXT;
    DECLARE in_DataFatura                 DATE;
    DECLARE in_DataRecebida               DATE;
    DECLARE in_PeriodoFaturacao           JSON;  -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-12-25"}
    DECLARE in_DataValidade               DATE;
    DECLARE in_FornecedorCodigo           TEXT;
    DECLARE in_Valor                      JSON;  -- e.g. {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase":0.00,"Iva":0.00}}
    DECLARE in_Moeda                      TEXT;
    DECLARE in_Descricao                  TEXT;
    DECLARE in_ImpostoConsumo             DECIMAL(18,2);
    DECLARE in_Amortizacao                BOOLEAN;
    -- Inputs para classificar analítica:
    DECLARE in_ClassificacaoAnalitica     JSON;  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "CO123", "Valor": 1000}, {...}]
    -- Inputs para anexar comprovativo de pagamento:
    DECLARE in_ComprovativoPagamentoId    INT;
    -- Variável representativa do estado actual do documento
    DECLARE v_Estado TEXT;
    
    SET in_NumSerie = JSON_VALUE(in_Extra, '$.NumSerie');
    SET in_NumFatura = JSON_VALUE(in_Extra, '$.NumFatura');
    SET in_Projeto = JSON_VALUE(in_Extra, '$.Projeto');
    SET in_DataFatura = JSON_VALUE(in_Extra, '$.DataFatura');
    SET in_DataRecebida = JSON_VALUE(in_Extra, '$.DataRecebida');
    SET in_PeriodoFaturacao = JSON_EXTRACT(in_Extra, '$.PeriodoFaturacao');
    SET in_DataValidade = JSON_VALUE(in_Extra, '$.DataValidade');
    SET in_FornecedorCodigo = JSON_VALUE(in_Extra, '$.FornecedorCodigo');
    SET in_Valor = JSON_EXTRACT(in_Extra, '$.Valor');
    SET in_Moeda = JSON_VALUE(in_Extra, '$.Moeda');
    SET in_Descricao = JSON_VALUE(in_Extra, '$.Descricao');
    SET in_ImpostoConsumo = JSON_VALUE(in_Extra, '$.ImpostoConsumo');
    SET in_Amortizacao = JSON_VALUE(in_Extra, '$.Amortizacao');
    SET in_ClassificacaoAnalitica = JSON_EXTRACT(in_Extra, '$.ClassificacaoAnalitica');
    SET in_ComprovativoPagamentoId = JSON_VALUE(in_Extra, '$.ComprovativoPagamentoId');
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);


    -- 0. Verificar validade dos argumentos
    IF NOT EXISTS (SELECT Id FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId AND Tipo = 'FaturaFornecedor')
      THEN signal sqlstate '20000' set message_text = 'Fatura de fornecedor inexistente.';
    END IF;


    -- 1. 'PorClassificarFornecedor' -> 'PorClassificarAnalitica'
    --
    -- Descrição: atualiza o estado do documento e
    --             dá ao "sistema" os dados da fatura contidos no documento em papel,
    --             acrescentando pequenos dados implícitos
    IF v_Estado = 'PorClassificarFornecedor' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET
        NumSerie = in_NumSerie,
        Estado = 'PorClassificarAnalitica',
        Extra = JSON_MERGE (
          Extra,
          JSON_MERGE(
            JSON_MERGE(
              JSON_OBJECT(
                'NumFatura', in_NumFatura,
                'ProjetoProvisorio', in_Projeto,
                'DataFatura', in_DataFatura,
                'DataRecebida', in_DataRecebida,
                'DataValidade', in_DataValidade,
                'FornecedorCodigo', in_FornecedorCodigo,
                'Moeda', in_Moeda,
                'Descricao', in_Descricao,
                'ImpostoConsumo', in_ImpostoConsumo,
                'Amortizacao', in_Amortizacao        
              ),
              CONCAT("{\"PeriodoFaturacao\":", in_PeriodoFaturacao, "}")
            ),
            CONCAT("{\"Valor\":", in_Valor, "}")
          )
        )
      WHERE Id = in_FaturaId;


    -- 2. 'PorClassificarAnalitica' -> 'PorRegistarContabilidade'
    -- Descrição: atualiza o estado do documento e
    --            lança na contabilidade analítica os movimentos que o custo/proveito desta fatura implicam

    ELSEIF v_Estado = 'PorClassificarAnalitica' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET
        Estado = 'PorRegistarContabilidade',
        Extra = JSON_MERGE(Extra, CONCAT("{\"ClassificacaoAnalitica\":", in_ClassificacaoAnalitica, "}"))
      WHERE Id = in_FaturaId;
      
      -- Lançar dívida de fornecedor e custos:
      CALL LancamentosLancarCustoFornecedor  (in_NumSerie, in_ClassificacaoAnalitica);


    -- 3. 'PorRegistarContabilidade' -> 'PorAnexarCPagamento'
    -- Descrição: atualiza o estado do documento e
    --            (no futuro) lança o custo/proveito desta fatura num software externo de contabilidade financeira

    ELSEIF v_Estado = 'PorRegistarContabilidade' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Estado = 'PorAnexarCPagamento'
      WHERE Id = in_FaturaId;


    -- 4. 'PorAnexarCPagamento' -> 'PorRegistarPagamentoContab'
    -- Descrição: atualiza o estado do documento e
    --            lança o pagamento por contrapartida da dívida existente (criada aquando da recepção da fatura) a fornecedor
    --            e associa o documento do tipo comprovativo de pagamento ao documento do tipo fatura

    ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET
        Estado = 'PorRegistarPagamentoContab',
        Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', in_ComprovativoPagamentoId)
      WHERE Id = in_FaturaId;
      
      -- Lançar pagamento e abater à conta de fornecedores:
      CALL LancamentosPagarDividaFornecedor  (in_FaturaId, in_ComprovativoPagamentoId);


    -- 5. 'PorRegistarPagamentoContab' -> 'Concluido'
    -- Descrição: atualiza o estado do documento e
    --            envia os dados do pagamento para o software externo de contabilidade financeira

    ELSEIF v_Estado = 'PorRegistarPagamentoContab' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Estado = 'Concluido'
      WHERE Id = in_FaturaId;

    END IF;
    
    
    -- 6. Se a fatura tinha sido rejeitada, reverter essa condição
    UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
    SET Extra = JSON_SET(Extra, '$.Rejeitada', 0, '$.MotivoRejeicao', NULL)
    WHERE Id = in_FaturaId; 

  END;
  
//

DELIMITER ;
