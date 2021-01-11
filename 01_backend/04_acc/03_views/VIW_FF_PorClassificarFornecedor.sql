-- View: VIW_FF_PorClassificarFornecedor
-- Descrição: Lista as faturas de fornecedores no estado 'PorClassificarFornecedor'
-- Depende de: tabela 'Documentos'

DROP VIEW IF EXISTS VIW_FF_PorClassificarFornecedor;

CREATE VIEW VIW_FF_PorClassificarFornecedor AS
SELECT Id, FileId
FROM <?=tableNameWithModule("Documentos","DOC")?> 
WHERE Tipo = 'FaturaFornecedor'
  AND Estado = 'PorClassificarFornecedor'
;
