DROP PROCEDURE IF EXISTS LancamentosPagarDividaFornecedor;

DELIMITER //

CREATE PROCEDURE LancamentosPagarDividaFornecedor (IN in_NumSerie TEXT, IN in_ComprovativoPagamentoId INT)
 
  BEGIN
           
    -- 1. Inserir lançamentos na conta do fornecedor
    CALL CriarLancamento (
      JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = in_NumSerie), '$.FornecedorCodigo'),
      -1,
      JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = in_NumSerie), '$.PeriodoFaturacao'),
      in_NumSerie
    );
    
    
    -- 2. Inserir lançamentos na conta bancária
    CALL CriarLancamento (
      JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE Id = in_ComprovativoPagamentoId), '$.ContaBancaria'),
      1,
      JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = in_NumSerie), '$.PeriodoFaturacao'),
      in_NumSerie
    );
  
  END;
    
//

DELIMITER ;
