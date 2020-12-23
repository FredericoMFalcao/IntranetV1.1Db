-- Tabela: ContaTipos
-- Descrição: Lista todos os tipos de conta que existem

CREATE TABLE <?=tableNameWithModule()?> (
  Tipo VARCHAR(255) NOT NULL,
  Sigla CHAR(2) NOT NULL,
  
  PRIMARY KEY(Tipo)
);

