-- Tabela: DocTipos
-- Descricao: Lista todos os tipos de documento e respectivos schemas

CREATE TABLE DocTipos (  
  Tipo VARCHAR(50) NOT NULL,
  DocSchema JSON,
  
  PRIMARY KEY (Tipo)
);

-- Dados Iniciais
INSERT INTO DocTipos (Tipo) VALUES ('FaturaFornecedor');
