-- ------------------------
-- Tabela: Lancamentos | Funcao: LancarProveitoCliente
--
-- Descrição: cria os lançamentos contabilísticos associados emissão de uma fatura, referentes a:
--              (1) dívida do cliente
--              (2) classificação analítica dos proveitos
-- ------------------------

DELIMITER //

CREATE OR REPLACE PROCEDURE <?=tableNameWithModule()?> (
  IN in_NumSerie                    TEXT,
  IN in_ClassificacaoAnalitica      TEXT
  -- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Valor": 1000}, {...}]
)
  BEGIN
    DECLARE v_PeriodoFaturacao TEXT;
    DECLARE v_ValorFatura, v_Iva DECIMAL(18,2);
    DECLARE i INT;
    
    SET v_PeriodoFaturacao = JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie), '$.PeriodoFaturacao');
    SET v_ValorFatura = ACC_FFValorTotal((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie));
    SET v_Iva = ACC_FaturaIva((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie));
    SET i = 0;
    
           
    -- 1. Inserir lançamentos na conta do cliente
    CALL <?=tableNameWithModule("CriarLancamento")?> (
      JSON_VALUE((SELECT Extra FROM <?=tableNameWithModule("Documentos","DOC")?> WHERE NumSerie = in_NumSerie), '$.ClienteCodigo'),
      -1,
      v_PeriodoFaturacao,
      in_NumSerie
    );
    
    
    -- 2. Inserir lançamentos na conta de impostos (IVA Dedutível)
    CALL <?=tableNameWithModule("CriarLancamento")?> (
      "IM02",
      v_Iva / v_ValorFatura,
      v_PeriodoFaturacao,
      in_NumSerie
    );
    
    
    -- 3. Inserir lançamentos em contas analíticas específicas
    WHILE i != JSON_LENGTH(in_ClassificacaoAnalitica) DO

      CALL <?=tableNameWithModule("CriarLancamento")?> (
        CONCAT_WS(":",
          JSON_VALUE(in_ClassificacaoAnalitica, CONCAT("$[", i, "].CentroResultados")),
          JSON_VALUE(in_ClassificacaoAnalitica, CONCAT("$[", i, "].Analitica"))
        ),
        (JSON_VALUE(in_ClassificacaoAnalitica, CONCAT("$[", i, "].Valor")) / v_ValorFatura) * (1 - v_Iva / v_ValorFatura),
        v_PeriodoFaturacao,
        in_NumSerie
      );

      SET i = i + 1;

    END WHILE;
  
  END;
    
//

DELIMITER ;
