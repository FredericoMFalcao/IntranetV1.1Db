-- Tabela: Lancamentos
-- Descricao: Regista todos os lançamentos contabilísticos da empresa

CREATE TABLE Lancamentos (
  Conta        VARCHAR(20) NOT NULL, -- foreign key
  TipoConta    VARCHAR(50) NOT NULL, -- foreign key
  
  CoefRateio   FLOAT NOT NULL,
  
  Mes          DATE NOT NULL,        -- desc: primeiro dia do mês a que o valor diz respeito
  DocNumSerie  VARCHAR(25) NOT NULL, -- foreign key
  TipoDoc      VARCHAR(50) NOT NULL, -- foreign key
  Extra        JSON,
  
  FOREIGN KEY (Conta,TipoConta) REFERENCES Contas(Conta,Tipo) ON DELETE RESTRICT ON UPDATE CASCADE,
  FOREIGN KEY (DocNumSerie,TipoDoc) REFERENCES Documentos(NumSerie,Tipo) ON DELETE CASCADE ON UPDATE CASCADE
);

