-- ------------------------
--  Tabela (virtual): FaturaFornecedor Funcao: Aprovar
--
-- Descrição: antes do estado de uma fatura (de fornecedor) passar para a frente no "workflow" previamente definido, faz:
--         (1) anexa informação extra que é dada em cada passo
--         (2) chama o procedimento que faz os lançamentos contabílisticos relevantes em cada passo
--         (3) passa informação relevante para o software externo de contabilidade financeira
--         (4) se a fatura tinha sido rejeitada, reverte essa condição
-- ------------------------

DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_FaturaId INT, IN in_Extra JSON)

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
    -- Inputs para classificar analítica:
    DECLARE in_ClassificacaoAnalitica     JSON;  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "CO123", "Valor": 1000}, {...}]
    -- Inputs para anexar comprovativo de pagamento:
    DECLARE in_ComprovativoPagamentoId    INT;
    -- Variável representativa do estado actual do documento
    DECLARE v_Estado                      TEXT;
    
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
    SET in_ClassificacaoAnalitica = JSON_EXTRACT(in_Extra, '$.ClassificacaoAnalitica');
    SET in_ComprovativoPagamentoId = JSON_VALUE(in_Extra, '$.ComprovativoPagamentoId');
    SET v_Estado = (SELECT Estado FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);


    -- 1. 'PorClassificarFornecedor' -> 'PorClassificarAnalitica'
    --
    -- Descrição: dá ao "sistema" os dados da fatura contidos no documento em papel,
    --             acrescentando pequenos dados implícitos
    IF v_Estado = 'PorClassificarFornecedor' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET
        NumSerie = in_NumSerie,
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
                'Descricao', in_Descricao      
              ),
              CONCAT("{\"PeriodoFaturacao\":", in_PeriodoFaturacao, "}")
            ),
            CONCAT("{\"Valor\":", in_Valor, "}")
          )
        )
      WHERE Id = in_FaturaId;


    -- 2. 'PorClassificarAnalitica' -> 'PorRegistarContabilidade'
    -- Descrição: lança na contabilidade analítica os movimentos que o custo/proveito desta fatura implicam
    ELSEIF v_Estado = 'PorClassificarAnalitica' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Extra = JSON_MERGE(Extra, CONCAT("{\"ClassificacaoAnalitica\":", in_ClassificacaoAnalitica, "}"))
      WHERE Id = in_FaturaId;
      
      -- Lançar dívida de fornecedor e custos:
      CALL <?=tableNameWithModule("LancamentosLancarCustoFornecedor")?>  (in_NumSerie, in_ClassificacaoAnalitica);


    -- 3. 'PorRegistarContabilidade' -> 'PorAnexarCPagamento'
    -- Descrição: (no futuro) lança o custo/proveito desta fatura num software externo de contabilidade financeira


    -- 4. 'PorAnexarCPagamento' -> 'PorRegistarPagamentoContab'
    -- Descrição: lança o pagamento por contrapartida da dívida existente (criada aquando da recepção da fatura) a fornecedor
    --            e associa o documento do tipo comprovativo de pagamento ao documento do tipo fatura
    ELSEIF v_Estado = 'PorAnexarCPagamento' THEN
      UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
      SET Extra = JSON_SET(Extra, '$.ComprovativoPagamentoId', in_ComprovativoPagamentoId)
      WHERE Id = in_FaturaId;
      
      -- Lançar pagamento e abater à conta de fornecedores:
      CALL <?=tableNameWithModule("LancamentosPagarDividaFornecedor")?>  (in_FaturaId, in_ComprovativoPagamentoId);


    -- 5. 'PorRegistarPagamentoContab' -> 'Concluido'
    -- Descrição: (no futuro) envia os dados do pagamento para o software externo de contabilidade financeira

    END IF;
    
    
    -- 6. Se a fatura tinha sido rejeitada, reverter essa condição
    UPDATE <?=tableNameWithModule("Documentos","DOC")?> 
    SET Extra = JSON_SET(Extra, '$.Rejeitada', 0, '$.MotivoRejeicao', NULL)
    WHERE Id = in_FaturaId; 

  END;
  
//

DELIMITER ;
