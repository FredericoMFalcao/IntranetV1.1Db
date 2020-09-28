DROP PROCEDURE IF EXISTS FF_PorAnexarCPagamento_UPDATE;

DELIMITER //

CREATE PROCEDURE FF_PorAnexarCPagamento_UPDATE (
IN NumSerie                 TEXT,
IN FileId                   TEXT,
IN NumFatura                TEXT,
IN DataFatura               DATE,
IN DataRecebida             DATE,
IN PeriodoFaturacao         TEXT,
-- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
IN DataValFatura            TEXT,
IN FornecedorCodigo         TEXT,
IN Valor                    TEXT,
-- e.g. {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase":0.00,"Iva":0.00}}
IN Moeda                    TEXT,
IN Descricao                TEXT,
IN ValorFatura              DECIMAL(18,2),
IN ClassificacaoAnalitica   TEXT
-- e.g. [{"CentroResultados": "CR0101", "Analitica": "AN0202", "Colaborador": "COabc", "Valor": 1000}, {...}]
)
 BEGIN
  DECLARE i INT;
  SET i = 0;
 
  -- 0. Verificar validade dos argumentos
  IF NumSerie NOT IN (SELECT NumSerie FROM Documentos WHERE Estado = 'PorAnexarCPagamento')
   THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
  END IF;
  
  -- 1. Alterar dados
  -- 1.1 Apagar lançamentos
  DELETE FROM Lancamentos
  WHERE NumSerie = NumSerie;
  
  -- 1.2 Inserir novos lançamentos em fornecedor
  CALL GerarLancamentos (FornecedorCodigo, 1, PeriodoFaturacao, NumSerie);
  
  -- 1.3 Inserir novos lançamentos em custos gerais
  CALL GerarLancamentos ("CG01", -1, PeriodoFaturacao, NumSerie);
  CALL GerarLancamentos ("CG01", 1, PeriodoFaturacao, NumSerie);

  -- 1.4 Inserir novos lançamentos com analíticas discriminadas
  WHILE i != JSON_LENGTH(ClassificacaoAnalitica) DO
 
   CALL GerarLancamentos (
     CONCAT_WS(":",
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador')
     ),
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura * -1,
     PeriodoFaturacao,
     NumSerie
    );

   SET i = i + 1;
   
  END WHILE;

  -- 1.5 Alterar dados do documento
  UPDATE Documentos
   SET
    FileId = FileId,
    Extra = JSON_SET(Extra, 
        '$.NumFatura', NumFatura,
        '$.DataFatura', DataFatura,
        '$.DataRecebida', DataRecebida,
        '$.PeriodoFaturacao', PeriodoFaturacao,
        '$.DataValFatura', DataValFatura,
        '$.FornecedorCodigo', FornecedorCodigo,
        '$.Valor', Valor,
        '$.Moeda', Moeda,
        '$.Descricao', Descricao
  ) 
  WHERE NumSerie = NumSerie;
  
 END;
//

DELIMITER ;
