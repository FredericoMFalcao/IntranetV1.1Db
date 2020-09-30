DROP PROCEDURE IF EXISTS LancamentosLancarCustoFornecedor;

DELIMITER //

CREATE PROCEDURE LancamentosLancarCustoFornecedor (
  IN _NumSerie                 TEXT,
  IN _PeriodoFaturacao         TEXT,
  -- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
  IN _FornecedorCodigo         TEXT
)
  BEGIN

    -- 1. Lançar em custos gerais / apagar lançamentos em fornecedor
    IF EXISTS (SELECT DocNumSerie FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = _NumSerie AND LEFT(Conta, 2) = 'FO') THEN
      DELETE FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = _NumSerie AND LEFT(Conta, 2) = 'FO';
    ELSE
      CALL CriarLancamento ("CG01", -1, _PeriodoFaturacao, _NumSerie);
    END IF;
					   
    -- 2. Inserir lançamentos na conta do fornecedor
    CALL CriarLancamento (_FornecedorCodigo, 1, _PeriodoFaturacao, _NumSerie);
  
  END;
	
//

DELIMITER ;
