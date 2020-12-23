-- ------------------------
-- Tabela: DocEstados
-- Descricao: Lista todos os estados que cada tipo de documento pode ter
-- ------------------------

CREATE TABLE <?=tableNameWithModule()?> (  
  Id INT PRIMARY KEY AUTO_INCREMENT,
  TipoDoc VARCHAR(50) NOT NULL,
  Estado VARCHAR(50) NOT NULL,
  Descricao VARCHAR(255),
  `Schema` JSON DEFAULT '{}',
  
  UNIQUE (TipoDoc,Estado),
  FOREIGN KEY (TipoDoc) REFERENCES <?=tableNameWithModule("DocTipos")?>(Tipo) ON DELETE RESTRICT ON UPDATE CASCADE
);


