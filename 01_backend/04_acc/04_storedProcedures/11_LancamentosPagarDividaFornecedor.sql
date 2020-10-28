DROP PROCEDURE IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE PROCEDURE <?=tableNameWithModule()?> (IN in_FaturaId INT, IN in_ComprovativoPagamentoId INT)
 
  BEGIN
    DECLARE v_NumSerie TEXT;
    DECLARE v_PeriodoFaturacao TEXT;
    DECLARE v_ValorFatura DECIMAL(18,2);
    DECLARE v_Retencao FLOAT;
    SET v_NumSerie = (SELECT NumSerie FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId);
    SET v_PeriodoFaturacao = JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId), '$.PeriodoFaturacao');
    SET v_ValorFatura = FF_ValorTotal((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId));
    SET v_Retencao = FF_Retencao(v_NumSerie);
    
           
    -- 1. Inserir lançamentos na conta do fornecedor
    CALL <?=tableNameWithModule("CriarLancamento")?> (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_FaturaId), '$.FornecedorCodigo'),
      (v_Retencao / v_ValorFatura) - 1,
      v_PeriodoFaturacao,
      v_NumSerie
    );
    
    
    -- 2. Inserir lançamentos na conta bancária
    CALL <?=tableNameWithModule("CriarLancamento")?> (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE Id = in_ComprovativoPagamentoId), '$.ContaBancaria'),
      1 - (v_Retencao / v_ValorFatura),
      v_PeriodoFaturacao,
      v_NumSerie
    );
  
  END;
    
//

DELIMITER ;
