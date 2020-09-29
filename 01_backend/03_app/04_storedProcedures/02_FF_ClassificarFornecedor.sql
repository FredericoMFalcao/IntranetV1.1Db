DROP PROCEDURE IF EXISTS FF_ClassificarFornecedor;

DELIMITER //

CREATE PROCEDURE FF_ClassificarFornecedor (
IN _NumSerie                TEXT,
-- underscore serve para distinguir dos campos de tabelas com o mesmo nome
IN NumFatura                TEXT,
IN Projecto                 TEXT,
IN DataFatura               DATE,
IN DataRecebida             DATE,
IN PeriodoFaturacao         TEXT,
-- e.g. {"Inicio": "2011-11-25", "Fim": "2011-11-25"}
IN DataValidade             DATE,
IN FornecedorCodigo         TEXT,
IN Valor                    TEXT,
-- e.g. {"Bens": {"ValorBase": 0.00, "Iva": 0.00}, "Servicos": {"ValorBase":0.00,"Iva":0.00}}
IN Moeda                    TEXT,
IN Descricao                TEXT,
IN ImpostoConsumo           DECIMAL(18,2),
IN Amortizacao              BOOLEAN
)
 BEGIN
 
  -- 0. Verificar validade dos argumentos
  IF _NumSerie NOT IN (SELECT NumSerie FROM <?=tableNameWithModule("Documentos")?> WHERE Estado = 'PorClassificarFornecedor')
   THEN signal sqlstate '20000' set message_text = 'Fatura inexistente ou indisponível para esta ação';
  END IF;
  
  -- 1. Alterar dados
  -- 1.1 Inserir Lançamentos em Fornecedor
  CALL CriarLancamento (FornecedorCodigo, 1, PeriodoFaturacao, _NumSerie);
  
  -- 1.2 Inserir Lançamentos em Custos Gerais
  CALL CriarLancamento ("CG01", -1, PeriodoFaturacao, _NumSerie);
  
  -- 1.3 Acrescentar dados a documento
  UPDATE <?=tableNameWithModule("Documentos")?> 
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
        '$.Descricao', Descricao,
        '$.ImpostoConsumo', ImpostoConsumo,
        '$.Amortizacao', Amortizacao
  ) 
  WHERE NumSerie = _NumSerie;
  
 END;
//

DELIMITER ;
