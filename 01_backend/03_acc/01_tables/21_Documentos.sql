-- Tabela: Documentos
-- Descricao: Lista todos os códigos e propriedades dos documentos inseridos na aplicação

CREATE TABLE <?=tableNameWithModule()?> (
  Id INT PRIMARY KEY AUTO_INCREMENT,
  NumSerie VARCHAR(25), -- unique key
  
  Tipo VARCHAR(50) NOT NULL, -- foreign key
  Estado VARCHAR(50) NOT NULL, -- foreign key
  
  FileId VARCHAR(255) NOT NULL, -- foreign key
  Extra JSON DEFAULT '{}',
  
  FOREIGN KEY (FileId) REFERENCES SYS_Files(Id),
  UNIQUE (NumSerie),
  FOREIGN KEY (Tipo,Estado) REFERENCES <?=tableNameWithModule("DocEstados")?>(TipoDoc,Estado) ON DELETE RESTRICT ON UPDATE CASCADE
);
