DROP PROCEDURE IF EXISTS FF_PorAnexarCPagamento_UPDATE;

DELIMITER //

CREATE PROCEDURE FF_PorAnexarCPagamento_UPDATE (
IN NumSerie                 TEXT,
IN FileId                   TEXT,
IN NumFatura                TEXT,
IN Projecto                 TEXT,
IN DataFatura               DATE,
IN DataRecebida             DATE,
IN PeriodoFacturacao        TEXT,
-- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
IN DataValFactura           TEXT,
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
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 2. Alterar dados
  -- 2.1 Alterar Lançamento Fornecedor
  UPDATE Lancamentos
  SET Conta = FornecedorCodigo, Mes = DataFatura
  WHERE NumSerie = NumSerie AND LEFT(Conta,2) = 'FO';
  
  -- 2.2 Alterar Lançamentos Custos Gerais
  UPDATE Lancamentos
  SET Mes = DataFatura
  WHERE NumSerie = NumSerie AND LEFT(Conta,2) = 'CG';

  -- 2.3 Alterar lançamentos com analíticas discriminadas
  DELETE FROM Lancamentos
  WHERE NumSerie = NumSerie AND LEFT(Conta,2) = 'CR';
  
  WHILE i != JSON_LENGTH(ClassificacaoAnalitica) DO
 
   INSERT INTO Lancamentos (Conta, CoefRateio, Mes, DocNumSerie)
    VALUES (
     CONCAT_WS(":",
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.CentroResultados'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Analitica'),
      JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Colaborador')
     ),
     JSON_EXTRACT(JSON_EXTRACT(ClassificacaoAnalitica, CONCAT("'$[", i, "]'")), '$.Valor') / ValorFatura * -1,
     NumSerie
    );

   SET i = i + 1;
   
  END WHILE;

  -- 2.3 Alterar dados do documento
  UPDATE Documentos
   SET
    FileId = FileId,
    Extra = JSON_SET(Extra, 
        '$.NumFatura', NumFatura,
        '$.Projeto', Projeto,
        '$.DataFactura', DataFatura,
        '$.DataRecebida', DataRecebida,
        '$.PeriodoFacturacao', PeriodoFacturacao,
        '$.DataValFactura', DataValFactura,
        '$.FornecedorCodigo', FornecedorCodigo,
        '$.Valor', Valor,
        '$.Moeda', Moeda,
        '$.Descricao', Descricao
  ) 
  WHERE NumSerie = NumSerie;
  
  -- 10. Salvar
  COMMIT;
 END;
//

DELIMITER ;
