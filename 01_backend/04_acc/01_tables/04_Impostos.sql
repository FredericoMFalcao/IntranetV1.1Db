-- Tabela: Impostos
-- Descrição: Contém as taxas de imposto aplicáveis
--                (uma entrada para cada intervalo de datas, no caso de alterações das taxas)

CREATE TABLE <?=tableNameWithModule()?> (
  Nome VARCHAR(30) NOT NULL,
  DataInicio DATE NOT NULL,
  DataFim DATE NOT NULL,
  Taxa FLOAT NOT NULL
);

INSERT INTO <?=tableNameWithModule()?> (Nome, DataInicio, DataFim, Taxa) VALUES ('ImpostoIndustrial', '2012-01-01', '2015-12-31', 0.0525);
INSERT INTO <?=tableNameWithModule()?> (Nome, DataInicio, DataFim, Taxa) VALUES ('ImpostoIndustrial', '2016-01-01', '2040-12-31', 0.065);
INSERT INTO <?=tableNameWithModule()?> (Nome, DataInicio, DataFim, Taxa) VALUES ('ImpostoPredial', '2012-01-01', '2040-12-31', 0.15);
