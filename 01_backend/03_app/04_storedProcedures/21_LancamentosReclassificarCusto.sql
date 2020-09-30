DROP PROCEDURE IF EXISTS LancamentosReclassificarCusto;

DELIMITER //

CREATE PROCEDURE LancamentosReclassificarCusto (
  IN _NumSerie                    TEXT,
  IN _ClassificacaoAnalitica      TEXT
  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
)
  BEGIN
    DECLARE ValorFatura DECIMAL(18,2);
    DECLARE PeriodoFaturacao TEXT;
    DECLARE i INT;
    SET ValorFatura = FF_ValorTotal((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = _NumSerie));
    SET PeriodoFaturacao = JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = _NumSerie), '$.PeriodoFaturacao');
    SET i = 0;
	
    -- 0. Verificar validade dos argumentos
    IF _NumSerie NOT IN (SELECT NumSerie FROM <?=tableNameWithModule("Documentos")?> WHERE Estado != 'PorClassificarFornecedor')
      THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
    END IF;
    
    -- 1. Anular lançamentos em custos gerais / apagar lançamentos em custos específicos
    IF _NumSerie IN (SELECT NumSerie FROM <?=tableNameWithModule("Lancamentos")?> WHERE LEFT(Conta, 2) = 'CR') THEN
      DELETE FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = _NumSerie AND LEFT(Conta, 2) = 'CR';
    ELSE
      CALL CriarLancamento ("CG01", 1, PeriodoFaturacao, _NumSerie);
    END IF;

    -- 2. Inserir lançamentos em custos específicos
    WHILE i != JSON_LENGTH(_ClassificacaoAnalitica) DO

      CALL CriarLancamento (
        CONCAT_WS(":",
          JSON_EXTRACT(JSON_EXTRACT(_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
          JSON_EXTRACT(JSON_EXTRACT(_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
          JSON_EXTRACT(JSON_EXTRACT(_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador')
        ),
        JSON_EXTRACT(JSON_EXTRACT(_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura * -1,
        PeriodoFaturacao,
        _NumSerie
      );

      SET i = i + 1;

    END WHILE;

  END;

//

DELIMITER ;
