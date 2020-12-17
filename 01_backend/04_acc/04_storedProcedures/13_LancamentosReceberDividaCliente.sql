-- ------------------------
-- Tabela: Lancamentos | Funcao: ReceberDividaCliente
--
-- Descrição: cria os lançamentos contabilísticos associados ao recebimento de uma fatura (cliente), referentes a:
--              (1) anular a dívida do cliente
--              (2) entrada do montante na conta bancária
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (IN in_FaturaId INT, IN in_ComprovativoPagamentoId INT)
 
  BEGIN
    DECLARE v_NumSerie TEXT;
    DECLARE v_PeriodoFaturacao TEXT;
    DECLARE v_ValorFatura DECIMAL(18,2);
    
    SET v_NumSerie = (SELECT NumSerie FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);
    SET v_PeriodoFaturacao = JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId), '$.PeriodoFaturacao');
    SET v_ValorFatura = JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId), '$.Valor');
    
           
    -- 1. Inserir lançamentos na conta do cliente
    CALL <?=tableNameWithModule("CriarLancamento")?> (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId), '$.ClienteCodigo'),
      1,
      v_PeriodoFaturacao,
      v_NumSerie
    );
    
    
    -- 2. Inserir lançamentos na conta bancária
    CALL <?=tableNameWithModule("CriarLancamento")?> (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_ComprovativoPagamentoId), '$.ContaBancaria'),
      -1,
      v_PeriodoFaturacao,
      v_NumSerie
    );
  
  END;
    
//

DELIMITER ;
