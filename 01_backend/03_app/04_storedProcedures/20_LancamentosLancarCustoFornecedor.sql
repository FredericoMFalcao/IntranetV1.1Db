DROP PROCEDURE IF EXISTS LancamentosLancarCustoFornecedor;

DELIMITER //

CREATE PROCEDURE LancamentosLancarCustoFornecedor (
  IN in_NumSerie                 TEXT,
  IN in_PeriodoFaturacao         TEXT,
  -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
  IN in_FornecedorCodigo         TEXT
)
  BEGIN

    -- 1. Lançar em custos gerais / apagar lançamentos em fornecedor
    IF EXISTS (SELECT DocNumSerie FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = in_NumSerie AND LEFT(Conta, 2) = 'FO') THEN
      DELETE FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = in_NumSerie AND LEFT(Conta, 2) = 'FO';
    ELSE
      CALL CriarLancamento ("CG01", -1, in_PeriodoFaturacao, in_NumSerie);
    END IF;
					   
    -- 2. Inserir lançamentos na conta do fornecedor
    CALL CriarLancamento (in_FornecedorCodigo, 1, in_PeriodoFaturacao, in_NumSerie);
  
  END;
	
//

DELIMITER ;
