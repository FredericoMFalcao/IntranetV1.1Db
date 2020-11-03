-- Devolve o valor de imposto que deve ser retido ao fornecedor da fatura em causa
--     (se não for aplicável, devolve zero)

DROP FUNCTION IF EXISTS <?=tableNameWithModule()?>;

DELIMITER //

CREATE FUNCTION <?=tableNameWithModule()?> (in_NumSerie TEXT)
RETURNS FLOAT
  BEGIN
    DECLARE v_ValorBase DECIMAL(18,2);
    DECLARE v_DataFatura DATE;
    DECLARE v_Fornecedor TEXT;
    DECLARE v_ImpInd BOOLEAN;
    DECLARE v_ImpPred BOOLEAN;
    DECLARE v_ImpIndTaxa FLOAT;
    DECLARE v_ImpPredTaxa FLOAT;
    
    SET v_ValorBase = JSON_VALUE(JSON_EXTRACT(JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie), '$.Valor'), '$.Bens'), '$.ValorBase') +
                      JSON_VALUE(JSON_EXTRACT(JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie), '$.Valor'), '$.Servicos'), '$.ValorBase');
    SET v_DataFatura = JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie), '$.DataFatura');
    SET v_Fornecedor = JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie), '$.FornecedorCodigo');
    SET v_ImpInd = JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Contas")?> WHERE Conta = v_Fornecedor), '$.ImpostoIndustrial');
    SET v_ImpPred = JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Contas")?> WHERE Conta = v_Fornecedor), '$.ImpostoPredial');
    SET v_ImpIndTaxa = (SELECT Taxa FROM <?=tableNameWithModule("Impostos")?> WHERE Nome = 'ImpostoIndustrial' AND DataInicio < v_DataFatura AND DataFim > v_DataFatura);
    SET v_ImpPredTaxa = (SELECT Taxa FROM <?=tableNameWithModule("Impostos")?> WHERE Nome = 'ImpostoPredial' AND DataInicio < v_DataFatura AND DataFim > v_DataFatura);
    
    IF v_ImpInd = 1 THEN RETURN v_ValorBase * v_ImpIndTaxa;
    ELSEIF v_ImpPred = 1 THEN RETURN v_ValorBase * v_ImpPredTaxa;
    ELSE RETURN 0;
    END IF;

  END;
  
//

DELIMITER ;
