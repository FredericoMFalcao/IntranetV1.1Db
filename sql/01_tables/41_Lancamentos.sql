-- Tabela: Lancamentos
-- Descricao: Regista todos os lançamentos contabilísticos da empresa

CREATE TABLE Lancamentos (
  Conta        VARCHAR(30) NOT NULL, -- pode ser conta composta (e.g. '0101:020403:ABC' para Centro Resultados, Analítica e Colaborador)
  CoefRateio   FLOAT NOT NULL,       -- percentagem do valor total do respectivo documento (pode variar entre -1 e 1)
  Mes          DATE NOT NULL,        -- primeiro dia do mês a que o valor diz respeito
  DocNumSerie  VARCHAR(25) NOT NULL, -- foreign key
  
  PRIMARY KEY (Conta,CoefRateio,Mes,DocNumSerie),
  FOREIGN KEY (DocNumSerie) REFERENCES Documentos(NumSerie) ON DELETE CASCADE ON UPDATE CASCADE
);
