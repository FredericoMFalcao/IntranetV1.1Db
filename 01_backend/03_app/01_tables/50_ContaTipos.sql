-- Tabela: ContaTipos
-- Descrição: Lista todos os tipos de conta que existem

CREATE TABLE <?=tableNameWithModule()?> (
  Tipo VARCHAR(255) NOT NULL, -- e.g. Fornecedor, Cliente, Colaborador, Banco, CentroResultado, Analitica  
  
  PRIMARY KEY(Tipo)
  
);
