-- Tabela: Documentos
-- Descricao: Lista todos os códigos e propriedades dos documentos inseridos na aplicação

CREATE TABLE Documentos (
  NumSerie VARCHAR(25),
  
  Tipo VARCHAR(50) NOT NULL, -- foreign key
  Estado VARCHAR(50) NOT NULL, -- foreign key
  
  FileId VARCHAR(255),
  Extra JSON,
  
  FOREIGN KEY (FileId) REFERENCES SYS_Files(Id),
  UNIQUE (NumSerie),
  FOREIGN KEY (Tipo,Estado) REFERENCES DocEstados(TipoDoc,Estado) ON DELETE RESTRICT ON UPDATE CASCADE
);
