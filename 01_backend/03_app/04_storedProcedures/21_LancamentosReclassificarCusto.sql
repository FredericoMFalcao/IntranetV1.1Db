DROP PROCEDURE IF EXISTS LancamentosReclassificarCusto;

DELIMITER //

CREATE PROCEDURE LancamentosReclassificarCusto (
  IN in_NumSerie                    TEXT,
  IN in_ClassificacaoAnalitica      TEXT
  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
)
  BEGIN
    DECLARE ValorFatura DECIMAL(18,2);
    DECLARE PeriodoFaturacao TEXT;
    DECLARE i INT;
    SET ValorFatura = FF_ValorTotal((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = in_NumSerie));
    SET PeriodoFaturacao = JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = in_NumSerie), '$.PeriodoFaturacao');
    SET i = 0;
    
    -- 1. Anular lançamentos em custos gerais / apagar lançamentos em custos específicos
    IF EXISTS (SELECT DocNumSerie FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = in_NumSerie AND LEFT(Conta, 2) = 'CR') THEN
      DELETE FROM <?=tableNameWithModule("Lancamentos")?> WHERE DocNumSerie = in_NumSerie AND LEFT(Conta, 2) = 'CR';
    ELSE
      CALL CriarLancamento ("CG01", 1, PeriodoFaturacao, in_NumSerie);
    END IF;

    -- 2. Inserir lançamentos em custos específicos
    WHILE i != JSON_LENGTH(in_ClassificacaoAnalitica) DO

      CALL CriarLancamento (
        CONCAT_WS(":",
          JSON_EXTRACT(JSON_EXTRACT(in_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
          JSON_EXTRACT(JSON_EXTRACT(in_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
          JSON_EXTRACT(JSON_EXTRACT(in_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador')
        ),
        JSON_EXTRACT(JSON_EXTRACT(in_ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura * -1,
        PeriodoFaturacao,
        in_NumSerie
      );

      SET i = i + 1;

    END WHILE;

  END;

//

DELIMITER ;
