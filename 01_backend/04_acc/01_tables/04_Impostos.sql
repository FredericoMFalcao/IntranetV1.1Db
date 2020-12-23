-- Tabela: Impostos
-- Descrição: Contém as taxas de imposto aplicáveis
--                (uma entrada para cada intervalo de datas, no caso de alterações das taxas)

CREATE TABLE <?=tableNameWithModule()?> (
  Nome VARCHAR(30) NOT NULL,
  DataInicio DATE NOT NULL,
  DataFim DATE NOT NULL,
  Taxa FLOAT NOT NULL
);

