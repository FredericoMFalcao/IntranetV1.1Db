-- Tabela: Documentos
-- Descricao: Lista todos os códigos e propriedades dos documentos inseridos na aplicação

CREATE TABLE Documentos (
  NumSerie VARCHAR(25) NOT NULL,
  
  Tipo VARCHAR(50) NOT NULL, -- foreign key
  Estado VARCHAR(50) NOT NULL, -- foreign key
  
  FileId VARCHAR(255),
  Extra JSON,
  
  PRIMARY KEY (NumSerie),
  FOREIGN KEY (Tipo,Estado) REFERENCES DocEstados(Tipo,Estado) ON DELETE RESTRICT ON UPDATE CASCADE
);
