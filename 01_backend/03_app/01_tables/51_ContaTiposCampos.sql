-- Tabela: ContaTipoCampos
-- Descrição: Lista todos os campos e respectivos tipos para cada tipo de conta

CREATE TABLE <?=tableNameWithModule()?> (
  ContaTipo VARCHAR(255) NOT NULL,
  Campo VARCHAR(255) NOT NULL, -- e.g. (Nome, Morada, NIF)
  Tipo VARCHAR(255) NOT NULL,
  ValorDefeito TEXT,
  Opcoes JSON,
  
  FOREIGN KEY (ContaTipo) REFERENCES <?=tableNameWithModule("ContaTipos")?> (Tipo),
  FOREIGN KEY (Tipo)      REFERENCES <?=tableNameWithModule("Types","PLT")?>(Name)
);
