DROP PROCEDURE IF EXISTS FF_ClassificarAnalitica;

DELIMITER //

CREATE PROCEDURE FF_ClassificarAnalitica (
IN NumSerie                      TEXT,
IN ValorFatura                   DECIMAL(18,2),
IN ClassificacaoAnalitica        TEXT
-- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
)
 BEGIN
  DECLARE i INT;
  SET i = 0;
 
  -- 0. Verificar validade dos argumentos
  IF NumSerie NOT IN (SELECT NumSerie FROM Documentos WHERE Estado = 'PorClassificarAnalitica')
   THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
  END IF;
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 2. Alterar dados
  -- 2.1 Inserir lançamentos com analíticas discriminadas
  WHILE i != JSON_LENGTH(ClassificacaoAnalitica) DO
 
   CALL GerarLancamentos (
     CONCAT_WS(":",
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador')
     ),
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura * -1,
     JSON_EXTRACT((SELECT Extra FROM Documentos WHERE NumSerie = NumSerie), '$.PeriodoFaturacao'),
     NumSerie
    );

   SET i = i + 1;
   
  END WHILE;

  -- 2.2 Inserir lançamento em custos gerais (com sinal contrário ao que foi lançado ao classificar o fornecedor)
   CALL GerarLancamentos ("CG01", 1, JSON_EXTRACT((SELECT Extra FROM Documentos WHERE NumSerie = NumSerie), '$.PeriodoFaturacao'), NumSerie);

  -- 2.3 Alterar estado do documento
   UPDATE Documentos
   SET Estado = 'PorAnexarCPagamento';
                  
  -- 10. Salvar
  COMMIT;
 END;
//

DELIMITER ;
