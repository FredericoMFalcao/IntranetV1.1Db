DROP PROCEDURE IF EXISTS FatFornecedor_ClassificarFornecedor;

DELIMITER //

CREATE PROCEDURE FatFornecedor_ClassificarFornecedor (
IN NumSerie                 TEXT,
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
 
   
  -- 1. Começar Transacao
  START TRANSACTION;
  
  -- 2. Alterar dados
  -- 2.1 Inserir Lancamento Fornecedor
  INSERT INTO Lancamentos (Conta, TipoConta, CoefRateio, DocNumSerie) 
  VALUES (FornecedorCodigo, 'Fornecedor', 1, NumSerie);
  
  -- 2.2 Acrescentar dados a documento
  UPDATE Documentos
   SET
    Estado = 'PorClassificarFornecedor',
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
