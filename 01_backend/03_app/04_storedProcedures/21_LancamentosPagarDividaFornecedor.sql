DROP PROCEDURE IF EXISTS LancamentosPagarDividaFornecedor;

DELIMITER //

CREATE PROCEDURE LancamentosPagarDividaFornecedor (IN in_FaturaId TEXT, IN in_ComprovativoPagamentoId INT)
 
  BEGIN
           
    -- 1. Inserir lançamentos na conta do fornecedor
    CALL CriarLancamento (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId), '$.FornecedorCodigo'),
      -1,
      JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId), '$.PeriodoFaturacao'),
      (SELECT NumSerie FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId)
    );
    
    
    -- 2. Inserir lançamentos na conta bancária
    CALL CriarLancamento (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_ComprovativoPagamentoId), '$.ContaBancaria'),
      1,
      JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId), '$.PeriodoFaturacao'),
      (SELECT NumSerie FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_FaturaId)
    );
  
  END;
    
//

DELIMITER ;
