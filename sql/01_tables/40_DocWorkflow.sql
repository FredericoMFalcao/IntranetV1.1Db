-- Tabela: DocWorkflow
-- Descricao: Regista todas as alterações feitas a documentos

CREATE TABLE DocWorkflow (
  NumSerie VARCHAR(25) NOT NULL, -- foreign key
  TipoDoc VARCHAR(50) NOT NULL, -- foreign key
  Descricao VARCHAR(250) NOT NULL,
  Utilizador VARCHAR(20) NOT NULL, -- foreign key
  DataHora DATETIME NOT NULL,
  DocInfoAntes JSON NOT NULL,
  DocInfoDepois JSON NOT NULL

  FOREIGN KEY (NumSerie) REFERENCES Documentos(NumSerie) ON DELETE CASCADE ON UPDATE CASCADE,
  FOREIGN KEY (TipoDoc) REFERENCES DocTipos(Tipo) ON DELETE RESTRICT ON UPDATE CASCADE
--  FOREIGN KEY (Utilizador) REFERENCES Utilizadores(Utilizador) ON DELETE RESTRICT ON UPDATE CASCADE
);
