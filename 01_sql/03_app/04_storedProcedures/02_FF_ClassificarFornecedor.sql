DROP PROCEDURE IF EXISTS FF_ClassificarFornecedor;

DELIMITER //

CREATE PROCEDURE FF_ClassificarFornecedor (
IN NumSerie                 TEXT,
IN NumFatura                TEXT,
IN Projecto                 TEXT,
IN DataFatura               DATE,
IN DataRecebida             DATE,
IN PeriodoFaturacao         TEXT,
-- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
IN DataValFatura            TEXT,
IN FornecedorCodigo         TEXT,
IN Valor                    TEXT,
-- e.g. {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase":0.00,"Iva":0.00}}
IN Moeda                    TEXT,
IN Descricao                TEXT
)
 BEGIN
 
  -- 0. Verificar validade dos argumentos
  IF NumSerie NOT IN (SELECT NumSerie FROM Documentos WHERE Estado = 'PorClassificarFornecedor')
   THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
  END IF;
  
  -- 1. Alterar dados
  -- 1.1 Inserir Lançamentos em Fornecedor
  CALL GerarLancamentos (FornecedorCodigo, 1, PeriodoFaturacao, NumSerie);
  
  -- 1.2 Inserir Lançamentos em Custos Gerais
  CALL GerarLancamentos ("CG01", -1, PeriodoFaturacao, NumSerie);
  
  -- 1.3 Acrescentar dados a documento
  UPDATE Documentos
   SET
    Estado = 'PorClassificarAnalitica',
    Extra = JSON_SET(Extra, 
        '$.NumFatura', NumFatura,
        '$.Projeto', Projeto,
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
