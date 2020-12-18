-- Tabela: ContaTipos
-- Descrição: Lista todos os tipos de conta que existem

CREATE TABLE <?=tableNameWithModule()?> (
  Tipo VARCHAR(255) NOT NULL,
  Sigla CHAR(2) NOT NULL,
  
  PRIMARY KEY(Tipo)
);

INSERT INTO <?=tableNameWithModule()?>
VALUES ("Analitica", "AN"),
       ("ContaBancaria", "CB"),
       ("CentroResultados", "CR"),
       ("Cliente", "CL"),
       ("Colaborador", "CO"),
       ("Fornecedor", "FO"),
       ("Impostos", "IM")
;
