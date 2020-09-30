-- Tabela: Lancamentos
-- Descricao: Regista todos os lançamentos contabilísticos da empresa

CREATE TABLE <?=tableNameWithModule()?> (
  Conta        VARCHAR(30) NOT NULL, -- pode ser conta composta (e.g. 'CR0101:AN020403:COabc' para Centro Resultados, Analítica e Colaborador)
  CoefRateio   FLOAT NOT NULL,       -- percentagem do valor total do respectivo documento (pode variar entre -1 e 1)
  Mes          DATE NOT NULL,        -- primeiro dia do mês a que o valor diz respeito
  DocumentoId  INT NOT NULL,         -- foreign key
  
  PRIMARY KEY (Conta,CoefRateio,Mes,DocumentoId),
  FOREIGN KEY (DocumentoId) REFERENCES <?=tableNameWithModule("Documentos")?> (Id) ON DELETE CASCADE ON UPDATE CASCADE
);
