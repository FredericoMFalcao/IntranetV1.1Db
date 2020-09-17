-- Tabela: DocTipos
-- Descricao: Lista todos os tipos de documento e respectivos schemas

CREATE TABLE DocTipos (  
  Tipo VARCHAR(50) NOT NULL,
  Schema JSON,
  
  PRIMARY KEY (Tipo)
);
