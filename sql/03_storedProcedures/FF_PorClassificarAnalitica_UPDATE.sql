DROP PROCEDURE IF EXISTS FF_PorClassificarAnalitica_UPDATE;

DELIMITER //

CREATE PROCEDURE FF_PorClassificarAnalitica_UPDATE (
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
IN Descricao                TEXT
)
 BEGIN
 
  -- 0. Verificar validade dos argumentos
  IF NumSerie NOT IN (SELECT NumSerie FROM Documentos WHERE Estado = 'PorClassificarAnalitica')
   THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
  END IF;
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 2. Alterar dados
  -- 2.1 Alterar Lançamento Fornecedor
  UPDATE Lancamentos
  SET Conta = FornecedorCodigo, Mes = DataFatura
  WHERE NumSerie = NumSerie AND LEFT(Conta,2) = 'FO';
  
  -- 2.2 Alterar Lançamento Custos Gerais
  UPDATE Lancamentos
  SET Mes = DataFatura
  WHERE NumSerie = NumSerie AND LEFT(Conta,2) = 'CG';
  
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
