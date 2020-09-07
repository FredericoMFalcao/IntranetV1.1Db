-- Tabela: DocEstados
-- Descricao: Lista todos os estados que cada tipo de documento pode ter

CREATE TABLE DocEstados (
  Tipo VARCHAR(50) NOT NULL,
  Estado VARCHAR(50) NOT NULL,
  Descricao VARCHAR(255),
  
  PRIMARY KEY (TipoDoc,Estado)
);
