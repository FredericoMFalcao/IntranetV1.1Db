DROP PROCEDURE IF EXISTS FF_ClassificarAnalitica;

DELIMITER //

CREATE PROCEDURE FF_ClassificarAnalitica (
IN _NumSerie                     TEXT,
-- underscore serve para distinguir dos campos de tabelas com o mesmo nome
IN ValorFatura                   DECIMAL(18,2),
IN ClassificacaoAnalitica        TEXT
-- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
)
 BEGIN
  DECLARE i INT;
  SET i = 0;
 
  -- 0. Verificar validade dos argumentos
  IF _NumSerie NOT IN (SELECT NumSerie FROM <?=tableNameWithModule("Documentos")?> WHERE Estado = 'PorClassificarAnalitica')
   THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
  END IF;
  
  -- 1. Alterar dados
  -- 1.1 Inserir lançamentos com analíticas discriminadas
  WHILE i != JSON_LENGTH(ClassificacaoAnalitica) DO
 
   CALL CriarLancamento (
     CONCAT_WS(":",
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador')
     ),
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura * -1,
     JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = _NumSerie), '$.PeriodoFaturacao'),
     _NumSerie
    );

   SET i = i + 1;
   
  END WHILE;

  -- 1.2 Inserir lançamentos em custos gerais (com sinal contrário ao que foi lançado ao classificar o fornecedor)
   CALL CriarLancamento ("CG01", 1, JSON_EXTRACT((SELECT Extra FROM <?=tableNameWithModule("Documentos")?> WHERE NumSerie = _NumSerie), '$.PeriodoFaturacao'), _NumSerie);

  -- 2.3 Alterar estado do documento
   UPDATE <?=tableNameWithModule("Documentos")?> 
   SET Estado = 'PorAnexarCPagamento';
                  
 END;
//

DELIMITER ;
