-- Tabela: DocTipos
-- Descricao: Lista todos os tipos de documento e respectivos schemas

CREATE TABLE <?=tableNameWithModule()?> (  
  Tipo VARCHAR(50) NOT NULL,
  DocSchema JSON,
  selectCode TEXT,
  
  PRIMARY KEY (Tipo)
);

